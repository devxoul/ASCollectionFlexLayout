Pod::Spec.new do |s|
  s.name             = "ASCollectionFlexLayout"
  s.version          = "1.0.0"
  s.summary          = "A custom collection layout that allows to use Texture layout specs in ASCollectionNode."
  s.homepage         = "https://github.com/devxoul/ASCollectionFlexLayout"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Suyeol Jeon" => "devxoul@gmail.com" }
  s.source           = { :git => "https://github.com/devxoul/ASCollectionFlexLayout.git",
                         :tag => s.version.to_s }
  s.source_files = "Sources/ASCollectionFlexLayout/*.{swift,h,m}"
  s.frameworks   = "UIKit"
  s.swift_version = "5.0"

  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"

  s.dependency "Texture", "~> 3.0"
end
