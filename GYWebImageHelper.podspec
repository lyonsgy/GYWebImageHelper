Pod::Spec.new do |spec|
  spec.name         = "GYWebImage"
  spec.version      = "0.0.2"
  spec.summary      = "A description of GYWebImage."
  spec.description  = <<-DESC
      A very long description of GYWebImage.
                   DESC
  spec.homepage     = "https://github.com/lyonsgy/GYWebImage.git"
  spec.license      = "MIT"
  # spec.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author       = { "lyonsgy" => "gy_lyons@163.com" }
  spec.source       = { :git => "https://github.com/lyonsgy/GYWebImage.git", :tag => "#{spec.version}" }
  spec.source_files  = "Libs/GYWebImage/**/*.{h,m}"
  spec.platform      = :ios, "9.0"
  spec.requires_arc = true
  spec.dependency "Masonry"
  spec.dependency "SDWebImage"
end
