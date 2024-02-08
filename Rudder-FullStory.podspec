require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

rudder_sdk_version = '~> 1.12'
deployment_target = '11.0'

Pod::Spec.new do |s|
    s.name             = 'Rudder-FullStory'
    s.version          = package['version']
    s.summary          = 'Privacy and Security focused Segment-alternative. FullStory App Events Native SDK integration support.'

    s.description      = <<-DESC
    Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
    DESC

    s.homepage         = 'https://github.com/rudderlabs/rudder-integration-fullstory-ios'
    s.license          = { :type => "ELv2", :file => "LICENSE.md" }
    s.author           = { 'Rudderlabs' => 'arnab@rudderlabs.com' }
    s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-fullstory-ios.git', :tag => "v#{s.version}" }
    s.platform         = :ios, "9.0"

    s.source_files = 'Rudder-FullStory/Classes/**/*'
    s.static_framework = true
    s.ios.deployment_target = deployment_target


if defined?($RudderSDKVersion)
  Pod::UI.puts "#{s.name}: Using user specified Rudder SDK version '#{$RudderSDKVersion}'"
  rudder_sdk_version = $RudderSDKVersion
else
  Pod::UI.puts "#{s.name}: Using default Rudder SDK version '#{rudder_sdk_version}'"
end

    s.dependency 'Rudder', rudder_sdk_version
    s.dependency 'FullStory'
end
