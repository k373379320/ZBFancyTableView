#
Pod::Spec.new do |s|
  s.name = 'ZBFancyTableView'
  s.version = '1.0.1'
  s.summary = 'A delightful iOS ZBFancyTableView framework.'
  s.homepage = 'https://github.com/k373379320/ZBFancyTableView'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { '373379320@qq.com' => '373379320@qq.com' }
  s.source = { :git => 'https://github.com/k373379320/ZBFancyTableView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'ZBFancyTableView/Classes/**/*'
  s.prefix_header_contents = '#import "ZBFancyTableVIewHeader.h"'
  s.ios.dependency 'BlocksKit'
  s.frameworks = 'UIKit','CoreFoundation'
end
