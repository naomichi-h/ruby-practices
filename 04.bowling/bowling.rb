#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X' # srtike
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

# [10,0]を[10]に変換する
frames.each_with_index do |f, i|
  if f[0] == 10
    frames[i].clear
    frames[i] << 10
  end
end

# 3投目が投げられた時のフレームの処理
case frames.length
when 11
  frames[10].each { |f| frames[9] << f }
  frames.delete_at(10)
when 12
  frames[9].push(frames[10][0])
  frames[9].push(frames[11][0])
  2.times { frames.delete_at(10) }
end

# 得点計算
point = 0
frames.each_with_index do |frame, i|
  point += if i == 8 && frame[0] == 10 # 9フレームでストライク
             10 + frames[i + 1][0] + frames[i + 1][1]
           elsif i <= 7 && frame[0] == 10 && frames[i + 1][0] == 10 # 1~8フレームでストライクかつその次もストライク
             20 + frames[i + 2][0]
           elsif i <= 7 && frame[0] == 10 # 1~8フレームでストライクかつその次はストライクでは無い
             10 + frames[i + 1].sum
           elsif i != 9 && frame.sum == 10 # スペア(10フレーム以外)
             10 + frames[i + 1][0]
           else
             frame.sum
           end
end

puts point
