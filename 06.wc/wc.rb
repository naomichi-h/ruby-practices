#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# 全体制御
def main(options)
  if ARGV[0].nil?
    text = $stdin.read
    options['l'] ? word_count_stdin_l(text) : word_count_stdin(text)
  else
    files = ARGV
    options['l'] ? word_count_l(files) : word_count(files)
  end
end

# wcコマンド（オプションなし）
def word_count(files)
  total_lines = 0
  total_words = 0
  total_bytesize = 0

  files.each do |file|
    text = File.read(file)
    print text.count("\n").to_s.rjust(8)
    print text.split(/\s+/).size.to_s.rjust(8)
    print text.bytesize.to_s.rjust(8)
    puts " #{file}"

    total_lines += text.count("\n")
    total_words += text.split(/\s+/).size
    total_bytesize += text.bytesize
  end

  # ファイルが複数ある場合はtotalを表示する
  return unless files[1]

  print total_lines.to_s.rjust(8)
  print total_words.to_s.rjust(8)
  print total_bytesize.to_s.rjust(8)
  puts ' total'
end

# wcコマンド（lオプション）
def word_count_l(files)
  total_lines = 0

  files.each do |file|
    text = File.read(file)
    print text.count("\n").to_s.rjust(8)
    puts " #{file}"

    total_lines += text.count("\n")
  end

  # ファイルが複数ある場合はtotalを表示する
  return unless files[1]

  print total_lines.to_s.rjust(8)
  puts ' total'
end

# wcコマンド(標準入力)
def word_count_stdin(text)
  print text.count("\n").to_s.rjust(8)
  print text.split(/\s+/).size.to_s.rjust(8)
  print "#{text.bytesize.to_s.rjust(8)}\n"
end

# wcコマンド(標準入力&lオプション)
def word_count_stdin_l(text)
  print "#{text.count("\n").to_s.rjust(8)}\n"
end

options = ARGV.getopts('l')
main(options)
