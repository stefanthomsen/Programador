platform :ios, '10.0'
use_frameworks!

target 'Programador' do
    pod 'Alamofire'
    pod 'SWXMLHash'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'RealmSwift'
    pod 'ObjectMapper+Realm'
    pod 'Kingfisher'
    pod 'KVLoading'
    pod 'Agrume'
    pod 'Kanna'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.1'
    end
  end
end
