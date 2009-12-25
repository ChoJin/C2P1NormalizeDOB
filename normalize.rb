#! /usr/bin/env ruby

require 'csv'
require 'pp'

if ARGV.size != 2
  puts "Usage: normalize.rb <input.csv> <output.csv>"
  exit(1)
end

outfile = File.open(ARGV[1], 'wb')

CSV::Writer.generate(outfile, ";") do |csv|
  CSV.open(ARGV[0], 'r', ';') do |row|
    # edit birthdates
    pp row
    if row[7][/^\d\d\d\d\d$/]
      day = row[7][/^(\d)(\d\d\d\d)$/, 1].to_i
      reminder = row[7][/^(\d)(\d\d\d\d)$/, 2].to_i
      row[7] = sprintf("%.2d%.4d", day, reminder)
      csv << row
    elsif row[7][/^\d\d\/\d\d\/\d\d\d\d$/]
      day = row[7][/^(\d\d)\/(\d\d)\/(\d\d)(\d\d)$/, 1].to_i
      month = row[7][/^(\d\d)\/(\d\d)\/(\d\d)(\d\d)$/, 2].to_i
      year = row[7][/^(\d\d)\/(\d\d)\/(\d\d)(\d\d)$/, 3].to_i
      row[7] = sprintf("%.2d%.2d%.2d", day, month, year)
      csv << row
    elsif row[7][/^\d\d\d\d\d\d$/]
      csv << row
    else
      printf("Error with c2p1 #{row[0]}")
    end
  end
end

puts "Done!"
