require "uri"
require "net/http"

def post_page(token, fname, tags)
  uri = URI.parse('https://blog.londone.net/api/page')
  req = Net::HTTP::Post.new(uri)
  req.set_form_data({'title' => File.basename(fname, ".md"),
                     'body' => File.open(fname).read, 'tags[]' => tags,
                     'token' => token,
                     'type' => 'md'})
  req_options = {
    use_ssl: uri.scheme == "https"
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(req)
  end
  p response.header
  p response.body
end

order = ARGV.first
token = ARGV[1]
tags = ARGV.drop(2)
sorted_file_names = Dir.glob("./nippo/*.md").sort{|a,b| File::Stat.new(a).mtime <=> File::Stat.new(b).mtime }.reverse
if order == "latest-view"
  p File.open(sorted_file_names.first).read
elsif order == "latest"
  sorted_file_names = sorted_file_names.take(1)
  sorted_file_names.each{|fname|
    sleep(1)
    post_page(token, fname, tags)
  }
end
