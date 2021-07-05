#
# Be sure to run `pod lib lint SFFeatureFlag.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFFeatureFlag'
  s.version          = '1.0.0'
  s.summary          = 'SFFeatureFlag provides mechanism for controlling the availability of features based on a remote configuration'

  s.description      = <<-DESC
SFFeatureFlag is a Scalefocus library that provides mechanism for controlling the availability of features based on a remote configuration, without requiring users to download an app update.
                       DESC

  s.homepage         = 'https://github.com/scalefocus/SFFeatureFlag'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maja Sapunova' => 'maja.sapunova@scalefocus.com' }
  s.source           = { :git => 'https://github.com/scalefocus/SFFeatureFlag.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'SFFeatureFlag/Classes/**/*.swift'
  
end
