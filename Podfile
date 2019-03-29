# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

def pods_added
  pod 'SwiftKeychainWrapper'
end

target 'TWSimulator' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TWSimulator
  pods_added
  
  target 'TWSimulatorTests' do
      inherit! :search_paths
      pods_added
  end

end
