module SunspotCell
  module Setup

    def self.included(base)
      base.class_eval do
        alias :sunspot_initialize :initialize unless method_defined?(:sunspot_initialize)
        def initialize(clazz)
          @attachment_field_factories, @attachment_field_factories_cache = *Array.new(8) { Hash.new }
          sunspot_initialize(clazz)
        end
        include InstanceMethods
      end
    end

    module InstanceMethods
      # Add field_factories for fulltext search on attachments
      #
      # ==== Parameters
      #
      def add_attachment_field_factory(name, options = {}, &block)
        stored = options[:stored]
        field_factory = Sunspot::FieldFactory::Static.new(name, Sunspot::Type::AttachmentType.instance, options, &block)
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
end