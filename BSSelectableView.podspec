#
# Be sure to run `pod lib lint BSSelectableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'BSSelectableView'
  s.version          = '0.3'
  s.summary          = 'Easily manage your token along with your single or multiply select view.'
  s.description      = "Looking for simple Swift library to manage multiply or single selection? This one is for you:)"

  s.homepage         = 'https://github.com/kunass2/BSSelectableView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bartłomiej Semańczyk' => 'bartekss2@icloud.com' }
  s.source           = { :git => 'https://github.com/kunass2/BSSelectableView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'BSSelectableView/Classes/**/*'
end
