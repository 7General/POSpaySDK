#
# Be sure to run `pod lib lint MSPOSPaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSPOSPaySDK'
  s.version          = '0.0.1'
  s.summary          = 'MSPOSPaySDK for POS'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/7General'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanghuizhou21@163.com' => 'wanghuizhou@guazi.com' }
  s.source           = { :git => 'https://github.com/7General/POSpaySDK.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '8.0'

  s.source_files = 'MSPOSPaySDK/Classes/**/*'
  
  s.resources    = 'MSPOSPaySDK/Boundles/UMSCashierPlugin.bundle'
  s.vendored_libraries = 'MSPOSPaySDK/Frameworks/libUMSCashierPlugin.a'
  
  s.frameworks        = 'CoreData', 'UIKit', 'Foundation'
  s.libraries         = 'sqlite3', 'icucore'
  
#  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }

end

