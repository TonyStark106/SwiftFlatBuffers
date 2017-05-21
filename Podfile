platform :ios, '8.0'
use_frameworks!

workspace 'SwiftFlatBuffers.xcworkspace'
target 'Example' do
	project 'Example/Example'

  	pod 'SwiftFlatBuffers', :path => './'
 	pod 'MyFlatBuffers', :path => 'Example/MyFlatBuffers/'

  	target 'ExampleTests' do
 		inherit! :search_paths

    
  	end
end
