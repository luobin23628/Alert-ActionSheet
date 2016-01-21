#
# Be sure to run `pod lib lint TKAlertAndTKActionSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TKAlert&TKActionSheet"
  s.version          = "1.0.19"
  s.summary          = "A custom TKAlert and TKActionSheet."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
s.description  = <<-DESC
                可替换系统的UIAlertView和UIActionSheet，使用灵活简单，可自定义样式和弹出动画
                    DESC

  s.homepage         = "https://github.com/luobin23628"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "luobin" => "luobin23628@163.com" }
  s.source           = { :git => "https://github.com/luobin23628/Alert-ActionSheet.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, "6.0"
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TKAlertAndTKActionSheet' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
