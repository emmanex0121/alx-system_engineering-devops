#!/usr/bin/env ruby
# PROGRAM BY PHOENIX

puts ARGV[0].scan(/\[from:(.*?)\]\s\[to:(.*?)\]\s\[flags:(.*?)\]/).join(',')
