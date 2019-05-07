Pod::Spec.new do |spec|
  spec.name         = "GYWebImageHelper"
  spec.version      = "0.0.1"
  spec.summary      = "A description of GYWebImageHelper."
  spec.description  = <<-DESC
      A very long description of GYWebImageHelper.
                   DESC
  spec.homepage     = "https://github.com/lyonsgy/GYWebImageHelper.git"
  spec.license      = "MIT"
  spec.author       = { "lyonsgy" => "gy_lyons@163.com" }
  spec.source       = { :git => "https://github.com/lyonsgy/GYWebImageHelper.git", :tag => "#{spec.version}" }
  spec.source_files  = "Libs/GYWebImageHelper/**/*.{h,m}"
  spec.platform      = :ios, "9.0"
  spec.requires_arc = true
  spec.dependency "SDWebImage"
end
