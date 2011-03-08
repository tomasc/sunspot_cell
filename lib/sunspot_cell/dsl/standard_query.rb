module SunspotCell
  module DSL
    module StandardQuery

      def self.included(base)
        base.class_eval do
          include InstanceMethods
        end
      end

      module InstanceMethods

        def fulltext(keywords, options = {}, &block)
          if keywords && !(keywords.to_s =~ /^\s*$/)
            fulltext_query = @query.add_fulltext(keywords)
            if field_names = options.delete(:fields)
              Util.Array(field_names).each do |field_name|
                @setup.text_fields(field_name).each do |field|
                  fulltext_query.add_fulltext_field(field, field.default_boost)
                end
              end
            end
            if minimum_match = options.delete(:minimum_match)
              fulltext_query.minimum_match = minimum_match.to_i
            end
            if tie = options.delete(:tie)
              fulltext_query.tie = tie.to_f
            end
            if query_phrase_slop = options.delete(:query_phrase_slop)
              fulltext_query.query_phrase_slop = query_phrase_slop.to_i
            end
            if highlight_field_names = options.delete(:highlight)
              if highlight_field_names == true
                fulltext_query.add_highlight
              else
                highlight_fields = []
                Util.Array(highlight_field_names).each do |field_name|
                  highlight_fields.concat(@setup.text_fields(field_name))
                end
                fulltext_query.add_highlight(highlight_fields)
              end
            end
            if block && fulltext_query
              fulltext_dsl = Fulltext.new(fulltext_query, @setup)
              Util.instance_eval_or_call(
                fulltext_dsl,
                &block
              )
            end
            if !field_names && (!fulltext_dsl || !fulltext_dsl.fields_added?)
              @setup.all_text_fields.each do |field|
                unless fulltext_query.has_fulltext_field?(field)
                  unless fulltext_dsl && fulltext_dsl.exclude_fields.include?(field.name)
                    fulltext_query.add_fulltext_field(field, field.default_boost)
                  end
                end
              end
            end
          end
          if !field_names && (!fulltext_dsl || !fulltext_dsl.fields_added?)
            unless @setup.all_attachment_fields.empty?
              @setup.all_attachment_fields.each do |attachment_text_field|
                unless fulltext_dsl && fulltext_dsl.exclude_fields.include?(attachment_text_field.name)
                  fulltext_query.add_fulltext_field(attachment_text_field, attachment_text_field.default_boost)
                end
              end
            end
          end
        end

      end
    end
  end
end