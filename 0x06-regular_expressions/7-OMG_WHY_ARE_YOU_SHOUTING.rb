#!/usr/bin/env ruby
# A regular expression that is matches ony capital letters
printf ARGV[0].scan(/[A-Z]/).join
