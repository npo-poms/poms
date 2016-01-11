require 'active_support'
require 'open-uri'
require 'json'
require 'poms/base'
require 'poms/version'
require 'poms/builder'
require 'poms/schedule_event'
require 'poms/broadcast'
require 'poms/season'
require 'poms/series'
require 'poms/views'
require 'poms/fields'
require 'poms/builderless/broadcast'
require 'poms/builderless/clip'
require 'poms/merged_series'
require 'poms/poms_error'

module Poms
  extend Poms::Views
  extend Poms::Fields
  extend self

  URL = 'http://docs.poms.omroep.nl'
  MEDIA_PATH = '/media/'
  BROADCASTS_VIEW_PATH = '/media/_design/media/_view/broadcasts-by-broadcaster-and-start'
  ANCESTOR_AND_TYPE_PATH = '/media/_design/media/_view/by-ancestor-and-type'
  ANCESTOR_AND_SORTDATE_PATH = '/media/_design/media/_view/by-ancestor-and-sortdate'
  CHANNEL_AND_START_PATH = '/media/_design/media/_view/broadcasts-by-channel-and-start'
  VALID_CHANNELS = /^NED(1|2|3)$/

  def fetch(mid)
    return nil if mid.nil?
    hash = fetch_raw_json mid
    Poms::Builder.process_hash hash
  end

  def fetch_clip(mid)
    clip_hash = fetch_raw_json(mid)
    Poms::Builderless::Clip.new(clip_hash)
  end

  def fetch_playlist_clips(mid)
    uri = Poms::Views.by_group(mid)
    playlist_hash = get_bare_json(uri)
    playlist_hash['rows'].map { |hash| Poms::Builderless::Clip.new(hash['doc']) }
  end

  def fetch_raw_json(mid)
    uri = [MEDIA_PATH, mid].join
    get_json(uri)
  end

  def fetch_group(mid)
    uri = Poms::Views.by_group(mid)
    get_bare_json(uri)
  end

  def upcoming_broadcasts(zender, start_time = Time.now, end_time = Time.now + 7.days)
    uri = [BROADCASTS_VIEW_PATH, broadcast_view_params(zender, start_time, end_time)].join
    hash = get_json(uri)
    hash['rows'].map { |item| Poms::Builder.process_hash item['doc'] }
  end

  def fetch_descendants_for_serie(mid, type = 'BROADCAST')
    uri = [ANCESTOR_AND_TYPE_PATH, ancestor_type_params(mid, type)].join
    hash = get_json(uri) || { 'rows' => [] }
    hash['rows'].map { |item| Poms::Builder.process_hash item['doc'] }
  end

  alias_method :fetch_broadcasts_for_serie, :fetch_descendants_for_serie

  def fetch_descendants_by_date_for_serie(mid, start_time = 1.week.ago)
    uri = [ANCESTOR_AND_SORTDATE_PATH, ancestor_sortdate_params(mid, start_time)].join
    hash = get_json(uri) || { 'rows' => [] }
    hash['rows'].map { |item| Poms::Builder.process_hash item['doc'] }
  end

  def fetch_descendant_mids(mid, type = 'BROADCAST')
    uri = [ANCESTOR_AND_TYPE_PATH, ancestor_type_params(mid, type), '&include_docs=false'].join
    hash = get_json(uri) || { 'rows' => [] }
    hash['rows'].map { |item| item['id'] }
  end

  def fetch_broadcasts_by_channel_and_start(channel, start_time = 1.week.ago, end_time = Time.now)
    uri = [CHANNEL_AND_START_PATH, channel_params(channel, start_time, end_time)].join
    hash = get_json(uri)
    hash['rows'].map { |item| Poms::Builder.process_hash item['doc'] }
  end

  def fetch_current_broadcast(channel)
    uri = Poms::Views.broadcasts_by_channel_and_start(channel)
    hash = get_bare_json(uri)
    row = hash['rows'].first
    Builderless::Broadcast.new(row['doc']) if row
  end

  def fetch_current_broadcast_and_key(channel)
    hash = get_json(channel_and_start_uri(channel, Time.now, 1.day.ago, limit: 1, descending: true))
    { key: get_first_key(hash), broadcast: get_first_broadcast(hash) }
  end

  def fetch_next_broadcast(channel)
    hash = get_json(channel_and_start_uri(channel, Time.now, 1.day.from_now, limit: 1))
    get_first_broadcast(hash)
  end

  def fetch_next_broadcast_and_key(channel)
    hash = get_json(channel_and_start_uri(channel, Time.now, 1.day.from_now, limit: 1))
    { key: get_first_key(hash), broadcast: get_first_broadcast(hash) }
  end

  def broadcast_view_params(zender, start_time, end_time)
    zender = zender.capitalize
    "?startkey=[\"#{zender}\",#{start_time.to_i * 1000}]&endkey=[\"#{zender}\",#{end_time.to_i * 1000}]&reduce=false&include_docs=true"
  end

  def ancestor_type_params(mid, type)
    "?reduce=false&key=[\"#{mid}\",\"#{type}\"]&include_docs=true"
  end

  def ancestor_sortdate_params(mid, start_time = 1.month.ago)
    end_time_i    = 1.week.from_now.to_i * 1000
    start_time_i  = start_time.to_i * 1000
    "?reduce=false&startkey=[\"#{mid}\",#{start_time_i}]&endkey=[\"#{mid}\",#{end_time_i}]&include_docs=true"
  end

  def channel_params(channel, start_time, end_time)
    "?startkey=[\"#{channel}\",#{start_time.to_i * 1000}]&endkey=[\"#{channel}\",#{end_time.to_i * 1000}]&reduce=false&include_docs=true"
  end

  def get_json(uri)
    get_bare_json(URI.escape([URL, uri].join))
  end

  private

  def get_bare_json(uri)
    JSON.parse(open(uri).read)
  rescue OpenURI::HTTPError => e
    raise e unless e.message.match(/404/)
    nil
  end

  def channel_and_start_uri(channel, start_time, end_time, options = {})
    query_options = options.blank? ? '' : "&#{options.to_query}"
    [CHANNEL_AND_START_PATH, channel_params(channel, start_time, end_time), query_options].join
  end

  def get_first_broadcast(hash)
    rows = hash['rows']
    Poms::Builder.process_hash(rows.empty? ? {} : rows.first['doc'])
  end

  def get_first_key(hash)
    rows = hash['rows']
    rows.empty? ? [] : rows.first['key']
  end
end
