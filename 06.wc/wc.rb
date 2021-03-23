files = ARGV

files.each do |file|
  text = File.read(file)
  print text.count("\n").to_s.rjust(8)
  print text.split(/\s+/).size.to_s.rjust(8)
  print text.bytesize.to_s.rjust(8)
  puts " #{file}"
end