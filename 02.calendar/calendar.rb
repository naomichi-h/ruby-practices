#!/usr/bin/env ruby

require "date"
require "optparse"

#オプションの設定
params = ARGV.getopts("", "y:#{Date.today.year}", "m:#{Date.today.month}")

#日付の取得
year = params["y"].to_i
month = params["m"].to_i

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)


#カレンダーとして日付を並べて成形する
puts "#{month}月 #{year}".center(20)
oneweek = ["日", "月", "火", "水", "木", "金", "土"]
puts oneweek.join(" ")

#一日と曜日を揃えるための空白
(first_day.wday * 3).times do
	print " "
end

(first_day..last_day).each do |day|
	if day.saturday?
		print day.day.to_s.rjust(2) + " " + "\n"
	else
		print day.day.to_s.rjust(2) + " "
	end
end
puts "\n"