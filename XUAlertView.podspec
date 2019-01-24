Pod::Spec.new do |s|
    s.name             = 'XUAlertView'
    s.version          = '0.1.0'
    s.summary          = 'XUAlertView'
    s.description      = <<-DESC
    Qingting iOS XUAlertView Framework
    DESC
    
    s.homepage         = 'https://github.com/xupeng48/xualertview'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'xupeng' => 'xupeng@qingting.fm' }
    s.source           = { :git => 'https://github.com/xupeng48/xualertview.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    
    s.public_header_files = 'XUAlertView/Classes/**/*.h'
    s.source_files = 'XUAlertView/Classes/**/*'
    s.resource_bundles = {
        'XUAlertView' => ['XUAlertView/Assets/images/*.png']
    }
    
end
