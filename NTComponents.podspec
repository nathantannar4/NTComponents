Pod::Spec.new do |s|


# 1 - Specs
s.platform = :ios
s.ios.deployment_target = '9.1'
s.name = 'NTComponents'
s.summary = "A collection of everything I find useful when developing any app!"
s.requires_arc = true

# 2 - Version
s.version = "0.0.7"

# 3 - License
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Author
s.author = { "Nathan Tannar" => "nathantannar4@gmail.com" }

# 5 - Homepage
s.homepage = "https://github.com/nathantannar4/NTComponents"

# 6 - Source
s.source = { :git => "https://github.com/nathantannar4/NTComponents.git", :tag => "#{s.version}"}

# 7 - Dependencies
s.framework = "UIKit"

# 8 - Source Files
s.source_files = "NTComponents/**/*.{swift}"

# 9 - Resources
s.resources = "NTComponents/**/*.{xcassets,otf,ttf,xib,storyboard}"



end
