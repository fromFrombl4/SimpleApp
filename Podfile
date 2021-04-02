platform :ios, '13.0'

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

target 'SimpleApp' do
  use_frameworks!

  pod 'SwiftLint'
  pod 'Kingfisher'
  pod 'Hex'

  target 'SimpleAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Sourcery'
  end
end
