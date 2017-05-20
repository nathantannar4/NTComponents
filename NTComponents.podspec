Pod::Spec.new do |s|


# 1 - Specs
s.platform = :ios
s.ios.deployment_target = '9.1'
s.name = 'NTComponents'
s.summary = "A collection of everything I find useful when developing any app!"
s.requires_arc = true

# 2 - Version
s.version = "0.0.3"

# 3 - License
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Author
s.author = { "Nathan Tannar" => "nathantannar4@gmail.com" }

# 5 - Homepage
s.homepage = "https://github.com/nathantannar4/NTComponents"

# 6 - Source
s.source = { :git => "https://github.com/nathantannar4/NTComponents.git", :tag => "#{s.version}"}

# 7
s.framework = "UIKit"

# 8
s.source_files = "NTComponents/**/*.{swift}"

# 9
s.resources = "NTComponents/**/*.{xcassets,oft,ttf,xib,storyboard}"



end
