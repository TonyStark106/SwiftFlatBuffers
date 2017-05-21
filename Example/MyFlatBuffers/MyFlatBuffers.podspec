Pod::Spec.new do |s|  
  	s.name    		  = 'MyFlatBuffers'
  	s.version 	  	= '0.0.1'
  	s.summary  	   	= "This is useful to install flatbuffers easily."
 	  s.description  	= <<-DESC
                    	Use 'pod install' to generate proto files.
                    	When you change the proto file and want to use 'pod install', you should change the property of version in this file.
                  	 DESC

  	s.homepage     	= "https://github.com/TonyStark106/SwiftFlatBuffers"

  	s.author       	= { "Tony" => "lvconan@foxmail.com" }
  	s.source 	     	= { :path => "src" }
  	s.license    		= 'MIT'

  	s.ios.deployment_target = '8.0'
    s.module_name = s.name

  	source_dir      = "src"
    s.requires_arc  = true
    s.source_files  = "#{source_dir}/*.{swift}"
    s.dependency "SwiftFlatBuffers"

end