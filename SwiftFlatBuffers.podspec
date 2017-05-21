Pod::Spec.new do |s|
  s.name             = 'SwiftFlatBuffers'
  s.version          = '1.0.0'
  s.summary          = 'SwiftFlatBuffers is a Swift implementation of FlatBuffers.'

  s.description      = <<-DESC
FlatBuffers is an efficient cross platform serialization library.
SwiftFlatBuffers is a Swift implementation of FlatBuffers.
                       DESC

  s.homepage         = 'https://github.com/TonyStark106/SwiftFlatBuffers'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'TonyStark106' => 'lvconan@foxmail.com' }
  s.source           = { :git => 'https://github.com/TonyStark106/SwiftFlatBuffers.git', :tag => s.version }

  s.requires_arc          = true

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'SwiftFlatBuffers/src/*'

  s.frameworks = 'Foundation'
end
