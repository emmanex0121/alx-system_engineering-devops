#!/usr/bin/env ruby
# PROGRAM BY PHOENIX
# Ruby Program that matches 2 to 5 occurences of
# the letter t between the characters of the word starting
# with hb and n

puts ARGV[0].scan(/hbt{2,5}n/).join
