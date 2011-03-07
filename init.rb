# Following line causes error 134 in RubyMine during debug
#$:.unshift "#{File.dirname(__FILE__)}/lib"
# Replace with:
libdir = "#{File.dirname(__FILE__)}/lib"
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'sunspot'
require 'composite_setup'
require 'sunspot/dsl/fields'
require 'sunspot/dsl/standard_query'
require 'sunspot/type'
require 'sunspot/field'
require 'sunspot/setup'
require 'sunspot/field_factory'
require 'sunspot/indexer'
