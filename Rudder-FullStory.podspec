require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
    s.name             = 'Rudder-FullStory'
    s.version          = package['version']
    s.summary          = 'Privacy and Security focused Segment-alternative. FullStory App Events Native SDK integration support.'

    s.description      = <<-DESC
    Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
    DESC

    s.homepage         = 'https://github.com/rudderlabs/rudder-integration-fullstory-ios'
    s.license          = { :type => "Apache", :file => "LICENSE" }
    s.author           = { 'Rudderlabs' => 'arnab@rudderlabs.com' }
    s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-fullstory-ios.git', :tag => "v#{s.version}" }
    s.platform         = :ios, "9.0"

    s.source_files = 'Rudder-FullStory/Classes/**/*'
    s.ios.vendored_frameworks = 'Frameworks/FullStory/FullStory.xcframework'
    s.dependency 'Rudder', '~> 1.1.4'
    # s.dependency 'FullStory'
end
