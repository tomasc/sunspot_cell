module SunspotCell
  module Type

    class AttachmentType < Sunspot::Type::AbstractType
      def indexed_name(name)
        "#{name}_attachment"
      end

      def to_indexed(value)
        value if value
      end

      def cast(text)
        text
      end
    end

  end
end