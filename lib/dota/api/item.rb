module Dota
  module API
    class Item
      include Utilities::Mapped

      attr_reader :id, :name

      def initialize(id)
        @id = id

        # make old items "empty"
        if mapping.key?(id)
          @internal_name = mapping[id][0]
          @name = mapping[id][1]
        else
          @internal_name = mapping[0][0]
          @name = mapping[0][1]
        end
      end

      # Possible values for type:
      # :lg - 85x64 PNG image
      # :eg - 27x20 PNG image
      def image_url(type = :lg)
        filename = "#{internal_name.sub(/\Arecipe_/, '')}_#{type}.png"
        "http://cdn.dota2.com/apps/dota2/images/items/#{filename}"
      end

      private

      attr_reader :internal_name
    end
  end
end
