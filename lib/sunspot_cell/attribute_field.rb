module SunspotCell
  module AttributeField


    def self.included(base)
      base.class_eval do
        attr_reader :default_boost
      end
    end

  end
end
