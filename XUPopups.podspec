Pod::Spec.new do |s|
  s.name             = 'XUPopups'
  s.version          = '0.2.0'
  s.summary          = 'XUPopups'
  s.description      = <<-DESC
                          Qingting iOS XUPopups Framework
                       DESC

  s.homepage         = 'https://git2.qingtingfm.com/CocoaPods/XUPopups'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xupeng' => 'xupeng@qingting.fm' }
  s.source           = { :git => 'https://github.com/xupeng48/xupopups.git', :tag => s.version.to_s }
  # s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.platform = :ios

  s.public_header_files = 'Source/Classes/XUPopups.h'
  s.source_files = 'Source/Classes/XUPopups.h'

  s.subspec 'Base' do |sb|
    sb.source_files = 'Source/Classes/Base/*'
  end

  s.subspec 'AlertView' do |sa|
    sa.source_files = 'Source/Classes/AlertView/*'
    sa.dependency 'XUPopups/Base'
    sa.resource_bundles = {
      'XUPopups' => ['Source/Assets/images/*.png']
    }
  end
  
  s.subspec 'SheetView' do |ss|
    ss.source_files = 'Source/Classes/SheetView/*'
    ss.dependency 'XUPopups/Base'
  end

  s.subspec 'Toast' do |st|
    st.source_files = 'Source/Classes/Toast/*'
  end

end
