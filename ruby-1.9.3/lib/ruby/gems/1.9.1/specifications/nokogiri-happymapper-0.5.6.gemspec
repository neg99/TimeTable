# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nokogiri-happymapper"
  s.version = "0.5.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Damien Le Berrigaud", "John Nunemaker", "David Bolton", "Roland Swingler", "Etienne Vallette d'Osia", "Franklin Webber"]
  s.date = "2012-10-29"
  s.description = "Object to XML Mapping Library, using Nokogiri (fork from John Nunemaker's Happymapper)"
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md", "TODO"]
  s.files = ["README.md", "CHANGELOG.md", "TODO"]
  s.homepage = "http://github.com/dam5s/happymapper"
  s.post_install_message = "\n  Thank you for installing nokogiri-happymapper 0.5.6 / .\n\n  Changes:\n  \n\n"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.29"
  s.summary = "Provides a simple way to map XML to Ruby Objects and back again."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.5"])
      s.add_dependency(%q<rspec>, ["~> 2.8"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.5"])
    s.add_dependency(%q<rspec>, ["~> 2.8"])
  end
end
