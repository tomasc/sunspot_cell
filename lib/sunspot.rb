%w(rich_document).each do |filename|
  require File.join(File.dirname(__FILE__), 'sunspot', filename)
end