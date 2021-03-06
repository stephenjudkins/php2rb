begin
  require 'spec/rake/spectask'
rescue LoadError
  puts 'To use rspec for testing you must install rspec gem:'
  puts '$ sudo gem install rspec'
  exit
end

desc "Run the specs under spec"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end