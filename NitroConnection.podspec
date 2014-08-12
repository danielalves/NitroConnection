Pod::Spec.new do |s|
  s.name         = 'NitroConnection'
  s.version      = '1.0.0'
  s.summary      = 'A very fast, simple and lightweight HTTP connection for iOS as an alternative to AFNetworking'
  s.homepage     = 'http://github.com/danielalves/NitroConnection'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = 'Daniel L. Alves'
  s.social_media_url   = 'http://twitter.com/alveslopesdan'
  s.source       = { :git => 'https://github.com/danielalves/NitroConnection.git', :tag => s.version.to_s }
  s.platform     = :ios
  s.source_files = 'NitroConnection/NitroConnection'
  s.xcconfig     = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.requires_arc = true
  s.dependency 'NitroMisc', '~> 1.0.1'
end
