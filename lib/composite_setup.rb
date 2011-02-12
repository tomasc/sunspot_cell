module Sunspot
  class CompositeSetup
    
    # Collection of all attachment fields configured for any of the enclosed types.
    #
    # === Returns
    #
    # Array:: Text fields configured for the enclosed types
    #
    def all_attachment_fields
      @attachment_fields ||= attachment_fields_hash.values.map { |set| set.to_a }.flatten
    end
    
    private
    
    # Return a hash of field names to atachment field objects, containing all fields
    # that are configured for any of the types enclosed.
    #
    # ==== Returns
    #
    # Hash:: Hash of field names to text field objects.
    #
    def attachment_fields_hash
      @attachment_fields_hash ||=
        setups.inject({}) do |hash, setup|
          setup.all_attachment_fields.each do |text_field|
            (hash[text_field.name] ||= Set.new) << text_field
          end
          hash
        end
    end
    
  end
end
