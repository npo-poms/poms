require 'poms/has_ancestors'

module Poms
  # Poms wrapper for a season of a serie.
  class Season < Poms::Builder::NestedOpenStruct
    include Poms::HasBaseAttributes
    include Poms::HasAncestors

    def related_group_mids
      descendant_of.map(&:mid_ref)
    end
  end
end
