# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

target 'TrainingSchedule' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TrainingSchedule
  pod 'GoogleMaps', '8.4.0'
  pod 'SwiftLint'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
