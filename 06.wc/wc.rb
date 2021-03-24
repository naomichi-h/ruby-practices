files = ARGV

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

#ファイルが複数ある場合はtotalを表示する
if files[1]
  print total_lines.to_s.rjust(8)
  print total_words.to_s.rjust(8)
  print total_bytesize.to_s.rjust(8)
  puts " total"
end