#
#  Be sure to run `pod spec lint PlayerSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'PlayerSDK'
  s.version          = '1.0.0'
  s.summary          = 'net263 PlayerSDK.'

  s.description      = <<-DESC
  net 263 PlayerSDK framework
                       DESC

  s.homepage         = 'https://github.com/net263/PlayerSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'net263' => '277715243@qq.com' }
  s.source           = { :git => 'https://github.com/net263/PlayerSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  s.vendored_frameworks = 'PlayerSDK.framework'
  s.resource = 'Resources/PlayerSDK.bundle'
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  # s.resource_bundles = {
  #   'RtSDK' => ['RtSDK/Assets/*.png']
  # }
  s.static_framework = true
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'GLKit'
  s.dependency 'GSBaseKit'
  # s.libraries = 'z', 'c++','iconv','icucore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
