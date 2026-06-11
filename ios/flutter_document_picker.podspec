#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_document_picker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_document_picker'
  s.version          = '0.0.1'
  s.summary          = 'Allows user pick a document.'
  s.description      = <<-DESC
Allows user to pick a document. The picked document is copied to the app temporary directory.
Optionally allows picking documents with a specific extension only.
                       DESC
  s.homepage         = 'https://github.com/sidlatau/flutter_document_picker'
  s.license          = { :type => 'Apache-2.0', :file => '../LICENSE' }
  s.author           = { 'sidlatau' => 'https://github.com/sidlatau' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_document_picker/Sources/flutter_document_picker/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
