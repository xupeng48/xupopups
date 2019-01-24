Pod::Spec.new do |s|
    s.name             = 'QTAlertView'
    s.version          = '0.1.0'
    s.summary          = 'QTAlertView'
    s.description      = <<-DESC
    Qingting iOS QTAlertView Framework
    DESC
    
    s.homepage         = 'https://git2.qingtingfm.com/CocoaPods/QTAlertView'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'xupeng' => 'xupeng@qingting.fm' }
    s.source           = { :git => 'https://git2.qingtingfm.com/CocoaPods/qtalertview.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    
    s.public_header_files = 'QTAlertView/Classes/**/*.h'
    s.source_files = 'QTAlertView/Classes/**/*'
    s.resource_bundles = {
        'QTAlertView' => ['QTAlertView/Assets/images/*.png']
    }
    
end
