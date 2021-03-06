#
# Be sure to run `pod lib lint ABNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ABNetwork"
  s.version          = "0.1.0"
  s.summary          = "ABNetwork 是参考YTKNetwork，基于AFNetwork的封装库。"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       知米听力（ZhiMiHearing）的网络库
                       对AFNetwork进行封装，实现离散型API接口调用基础。
                       
                       DESC
                       
  s.homepage         = "https://github.com/youmoxiyou/ABNetwork"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "AbeHui" => "sky_boy_0574@126.com" }
  s.source           = { :git => "https://github.com/youmoxiyou/ABNetwork.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ABNetwork' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.0'
end
