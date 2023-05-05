#
# Be sure to run `pod lib lint ChattyWebviews.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChattyWebviews'
  s.version          = '0.1.0'
  s.summary          = 'ChattyWebviews iOS SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ChattyWebviews adds messaging between your webviews and native classes. The SDK also manages over-the-air updates pushed by the CLI.
                       DESC

  s.homepage         = 'https://github.com/ChattyWebviews/ChattyWebviews'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tdermendjiev' => 'tdermendjievft@gmail.com' }
  s.source           = { :git => 'https://github.com/ChattyWebviews/ChattyWebviews.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'ChattyWebviews/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ChattyWebviews' => ['ChattyWebviews/Assets/*.png']
  # }
  s.dependency 'SSZipArchive'
end
