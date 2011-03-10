%w(sunspot composite_setup sunspot/dsl/fields sunspot/dsl/standard_query sunspot/type sunspot/field sunspot/setup sunspot/field_factory sunspot/indexer).each do |file|
  require File.join(File.dirname(__FILE__), 'lib', file)
end