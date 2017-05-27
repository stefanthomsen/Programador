platform :ios, '10.0'
use_frameworks!

target 'Programador' do    
pod 'Alamofire'
pod 'AlamofireImage'
pod 'SWXMLHash'
pod 'Kanna'
pod 'Agrume'
pod 'KVLoading'
pod 'Fabric'
pod 'Crashlytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
