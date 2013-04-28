#!/usr/bin/env ruby

`ln -f #{File.expand_path(File.dirname(__FILE__))}/vfl2objc.rb /usr/bin/`
`rm -rf ~/Library/Services/vfl-file.workflow`
`cp -r #{File.expand_path(File.dirname(__FILE__))}/vfl-file.workflow ~/Library/Services/`

