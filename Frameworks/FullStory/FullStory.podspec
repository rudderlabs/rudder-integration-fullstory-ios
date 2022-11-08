Pod::Spec.new do |s|
  s.name = "FullStory"
  s.version = "1.18.0"
  s.summary = "FullStory's iOS capture library."
  s.author = { "FullStory" => "sales@fullstory.com" }
  s.description = <<-DESC
                    Necessary frameworks and libraries for capture of iOS
                    sessions using FullStory Native Mobile.
                  DESC
  s.homepage = "https://fullstory.com/"
  s.license = { :type => "Proprietary", :file => "FullStory.xcframework/ACKNOWLEDGEMENTS.md" }
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.source = {
    :http => "https://ios-releases.fullstory.com/fullstory-1.18.0-xcframework.tar.gz"
  }
  s.vendored_frameworks = "FullStory.xcframework"
  s.preserve_path = 'tools'
  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-lc++ -lObjC'
  }
end
