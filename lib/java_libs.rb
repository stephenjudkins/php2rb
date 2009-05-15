require 'java'

Dir.glob(File.dirname(__FILE__) + "/java/*.jar").each do |jar|
  require jar
end