#!$HOME/.rbenv/shims/ruby
# coding: utf-8
require 'date'

def ary_split(sep, ary)
  target_index = ary.index(sep)
  return ary if target_index.nil? || ary.length.zero?
  return [ary[0,target_index], ary[target_index + 1, ary.length]]
end

filename = ARGV.first
filename = DateTime.now.strftime("%Y-%m-%d %H:%M:%S").split.first if filename == "date"
did_ary, todo_ary = ary_split("_", ARGV.drop(1))
map = {did: did_ary, todo: todo_ary}
map2 = {did: "# 今日やること", todo: "# 明日やること"}

File.open("nippo/#{filename}.md", "w") do |f|

  f.puts("# #{filename}(#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")})")
  f.puts("")
  map.each do |type, ary|
    f.puts(map2[type])
    f.puts("")
    f.puts("---")
    f.puts("")
    ary.each do |x|
      f.puts("* #{x}")
      f.puts("")
    end
    f.puts("")
    f.puts("---")
    f.puts("")

    ary.each do |x|
      f.puts("## #{x}")
      f.puts("")
    end
    f.puts("")
  end
end
