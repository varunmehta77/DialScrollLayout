Pod::Spec.new do |s|
  s.name             = 'DialScrollLayout'
  s.version          = '0.1.0'
  s.summary          = 'DialScrollLayout is collection view with scrolling cells'

  s.description      = <<-DESC
        DialScrollLayout is collection view with scrolling cells with centering at corner of scrollview like old phone dial.
                       DESC

  s.homepage         = 'https://github.com/varunmehta77/DialScrollLayout.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Varun Mehta' => 'varunmehta077@gmail.com' }
  s.source           = { :git => 'https://github.com/varunmehta77/DialScrollLayout.git', :tag => '{s.version}' }

  s.ios.deployment_target = '10.0'
  s.source_files = 'DialScrollLayout/DialScrollLayout.swift'

end

