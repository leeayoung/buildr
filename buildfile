require 'buildr/jetty'
$LOADED_FEATURES << 'jruby' unless RUBY_PLATFORM =~ /java/ # Pretend to have JRuby, keeps Nailgun happy.
require 'java/nailgun'

define 'buildr' do
  compile.using :source=>'1.4', :target=>'1.4', :debug=>false

  define 'java' do
    compile.using(:javac).from(FileList['lib/java/**/*.java']).into('lib/java').with(Buildr::Nailgun.artifact)
  end

  desc 'Buildr extra packages (Antlr, Cobertura, Hibernate, Javacc, JDepend, Jetty, OpenJPA, XmlBeans)'
  define 'extra', :version=>'1.0' do
    compile.using(:javac).from(FileList['lib/buildr/**/*.java']).into('lib/buildr').with(Buildr::Jetty::REQUIRES)
    # Legals included in source code and show in RDoc.
    legal = 'LICENSE', 'DISCLAIMER', 'NOTICE'
    package(:gem).include(legal).path('lib').include('lib/buildr')
    p package(:gem)
    package(:gem).spec do |spec|
      spec.author             = 'Apache Buildr'
      spec.email              = 'buildr-user@incubator.apache.org'
      spec.homepage           = "http://incubator.apache.org/buildr"
      spec.rubyforge_project  = 'buildr'
      spec.extra_rdoc_files   = legal
      spec.rdoc_options << '--webcvs' << 'http://svn.apache.org/repos/asf/incubator/buildr/trunk/'
      spec.add_dependency 'buildr', '~> 1.3'
    end

    install do
      addon package(:gem)
    end

    upload do
    end
  end
end
