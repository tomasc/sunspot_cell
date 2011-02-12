module Sunspot
  module Type
    
    # class <<self
      
      class AttachmentType < AbstractType
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
      
    # end
    
  end
end