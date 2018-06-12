Pod::Spec.new do |s|
  s.name             = 'SwedishSSN'
  s.version          = '1.0.0'
  s.summary          = 'A pod to validate and extract information from Swedish Social Security Number'
  s.description      = <<-DESC
A pod to validate and extract information from Swedish Social Security Number.
Validate if it is a `personnummer`, a `samordningsnummer` or an `organisationsnummer` and extract information
like gender and company type accordingly.
                       DESC
  s.homepage         = 'https://github.com/diamantidis/SwedishSSN'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ioannis Diamantidis' => 'diamantidis@outlook.com' }
  s.source           = { :git => 'https://github.com/diamantidis/SwedishSSN.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.3'
  s.swift_version    = '4.0'
  s.source_files     = 'SwedishSSN/Classes/**/*'
end
