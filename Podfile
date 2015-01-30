source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

inhibit_all_warnings!

workspace 'Swisscom'

target :Swisscom do
    xcodeproj 'Swisscom'
    
    pod 'AFNetworking', '~>2.5.0'
    pod 'libextobjc/EXTScope'
    pod 'Reachability'

end


post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
