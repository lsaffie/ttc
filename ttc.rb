#!/usr/bin/env /Users/lsaffie/.rbenv/bin/ruby-local-exec

ENV['PATH'] = "/Users/lsaffie/.rbenv/shims:/Users/lsaffie/.rbenv/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/lsaffie/.rbenv/shims:/Users/lsaffie/.rbenv/bin"

if ARGV[1]
  `bundle exec ./client.rb #{ARGV[0]} #{ARGV[1]}`
else
  `bundle exec ./client.rb #{ARGV[0]}`
end
