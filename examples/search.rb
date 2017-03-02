require 'poms'

Poms.descendants('VPWON_1251179', starts_at: Time.now, ends_at: 2.days.from_now)
# => Returns all media that is a descendant of the media by the given mid, and
# was broadcasted between now and next week

Poms.descendants('VPWON_1251179', starts_at: Time.now, type: 'BROADCAST')
# => Returns all media that is a descendant of the media by the given mid, has
# not aired yet and is a broadcast
