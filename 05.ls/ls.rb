#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

# Overall flow with or without options
def main_control(options)
  current_dir_files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')

  current_dir_files = options['r'] ? current_dir_files.reverse : current_dir_files

  options['l'] ? list_segments_l(current_dir_files) : list_segments(current_dir_files)
end

# Split current directory
def slice_dir(current_dir_files)
  slice_number = (current_dir_files.length % 3).zero? ? current_dir_files.length / 3 : current_dir_files.length / 3 + 1

  sliced_current_dir_files = []

  current_dir_files.each_slice(slice_number) { |s| sliced_current_dir_files << s }

  # Align the number of elements in sliced_current_dir_files so that they can be transposed
  unless sliced_current_dir_files.last.length == sliced_current_dir_files.first.length
    (sliced_current_dir_files.first.length - sliced_current_dir_files.last.length).times do
      sliced_current_dir_files.last.push('')
    end
  end

  sliced_current_dir_files
end

# When there is no option
def list_segments(current_dir_files)
  sliced_current_dir_files = slice_dir(current_dir_files)

  transposed_sliced_current_dir_files = sliced_current_dir_files.transpose

  transposed_sliced_current_dir_files.each do |array|
    blanc_number = current_dir_files.max_by(&:length).length + 10

    print array[0] + ' ' * (blanc_number - array[0].length)
    print array[1] + ' ' * (blanc_number - array[1].length)
    print array[2]
    puts "\n"
  end
end

# Get the filetype and permission
def convert_to_filetype_and_permission(file_mode)
  filetype_number = file_mode.length == 5 ? file_mode[0, 2] : file_mode[0, 3]

  permission_number = file_mode.length == 5 ? file_mode[2, 3] : file_mode[3, 3]

  filetype = convert_to_filetype(filetype_number)
  permission = convert_to_permission(permission_number[0]) + convert_to_permission(permission_number[1]) + convert_to_permission(permission_number[2])

  filetype + permission
end

# When there is l option
def list_segments_l(current_dir_files)
  total = 0
  file_data = []
  current_dir_files.each do |file|
    file_details = File.stat(file)
    file_mode = file_details.mode.to_s(8)

    # Get the filetype and permission
    filetype_and_permission = convert_to_filetype_and_permission(file_mode)

    nlink = file_details.nlink

    username = Etc.getpwuid(file_details.uid).name
    groupname = Etc.getgrgid(file_details.gid).name

    bytesize = file_details.size

    timestamp = file_details.mtime.strftime('%-m %e %H:%M')

    total += file_details.blocks

    file_data << "#{filetype_and_permission} #{nlink} #{username} #{groupname} #{bytesize} #{timestamp} #{file}"
  end

  puts "total #{total}"
  file_data.each do |x|
    puts x
  end
end

# Convert file type to ls command symbol
def convert_to_filetype(filetype_number)
  {
    "100": '-',
    "40": 'd',
    "20": 'c',
    "60": 'b',
    "120": 'l'
  }[filetype_number.to_sym]
end

# Convert permission to ls command symbol
def convert_to_permission(permission_number)
  {
    '0': '---',
    '1': '--x',
    '2': '-w-',
    '3': '-wx',
    '4': 'r--',
    '5': 'r-x',
    '6': 'rw-',
    '7': 'rwx'
  }[permission_number.to_sym]
end

options = ARGV.getopts('a', 'l', 'r')
main_control(options)
