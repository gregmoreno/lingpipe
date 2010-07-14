require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "lingpipe"
    gem.summary     = %Q{LingPipe wrapper}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email       = "greg.moreno@gmail.com"
    gem.homepage    = "http://github.com/gregmoreno/lingpipe"
    gem.authors     = ["Greg Moreno"]
    gem.add_development_dependency "shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.ruby_opts << '-rubygems'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lingpipe #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


namespace :demos  do
  [['dictionary-chunker', 'ne/dictionary_chunker.rb'],
   ['approx-chunker',     'ne/approximate_chunker.rb'],
   ['run-genetag',        'ne/run_chunker.rb'],
   ['run-genetag-conf',   'ne/run_confidence_chunker.rb'],
   ['train-genetag',      'ne/train_genetag.rb'],

   ['findbounds', 'sentences/sentence_boundary.rb'],
   ['findchunks', 'sentences/sentence_chunker.rb']

  ].each do |t, f|
    instance_eval <<-EOT
      Rake::TestTask.new('#{t}') do |test|
        test.libs << 'lib'
        test.ruby_opts << '-rubygems'
        test.pattern = 'demos/tutorial/#{f}'
      end
    EOT
  end
end
