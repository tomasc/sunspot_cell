module Sunspot
  class Setup
    
    def initialize(clazz)
      @class_object_id = clazz.object_id
      @class_name = clazz.name
      @field_factories, @text_field_factories, @dynamic_field_factories, @attachment_field_factories,
        @field_factories_cache, @text_field_factories_cache,
        @dynamic_field_factories_cache, @attachment_field_factories_cache = *Array.new(8) { Hash.new }
      @stored_field_factories_cache = Hash.new { |h, k| h[k] = [] }
      @more_like_this_field_factories_cache = Hash.new { |h, k| h[k] = [] }
      @dsl = DSL::Fields.new(self)
      add_field_factory(:class, Type::ClassType.instance)
    end
    
    
    
    # Add field_factories for fulltext search on attachments
    #
    # ==== Parameters
    #
    def add_attachment_field_factory(name, options = {}, &block)
      stored = options[:stored]
      field_factory = FieldFactory::Static.new(name, Type::AttachmentType.instance, options, &block)
      @attachment_field_factories[name] = field_factory
      @attachment_field_factories_cache[field_factory.name] = field_factory
      if stored
        @attachment_field_factories_cache[field_factory.name] << field_factory
      end
    end
    
    
    
    def text_fields(field_name)
      text_field = 
        if field_factory = @text_field_factories_cache[field_name.to_sym]
          field_factory.build
        else
          if field_factory = @attachment_field_factories_cache[field_name.to_sym]
            field_factory.build
          else
            raise(
              UnrecognizedFieldError,
              "No text field configured for #{@class_name} with name '#{field_name}'"
            )
          end
        end
      [text_field]
    end
    
    
    
    def all_attachment_fields
      attachment_field_factories.map { |field_factory| field_factory.build }
    end
    
    
    
    # Get the text field_factories associated with this setup as well as all inherited
    # attachment field_factories
    #
    # ==== Returns
    #
    # Array:: Collection of all text field_factories associated with this setup
    #
    def attachment_field_factories
      collection_from_inheritable_hash(:attachment_field_factories)
    end
    
    
    def all_field_factories
      all_field_factories = []
      all_field_factories.concat(field_factories).concat(text_field_factories).concat(dynamic_field_factories).concat(attachment_field_factories)
      all_field_factories
    end
    
  end
end