require 'sinatra'
require 'open-uri'
require 'rexml/document'
require 'cgi'

FLICKR_API_KEY = '09990d03b665bce30c2af1eacb75ee24'
#---
def flickr_call(method_name, arg_map={}.freeze)
  args = arg_map.collect {|k,v| CGI.escape(k) + '=' + CGI.escape(v)}.join('&')
  url = "http://www.flickr.com/services/rest/?api_key=%s&method=%s&%s" %
    [FLICKR_API_KEY, method_name, args]
  doc = REXML::Document.new(open(url).read)
end
#---
def pick_a_photo(tag)
 doc = flickr_call('flickr.photos.search', 'tags' => tag, 'license' => '4',
                   'per_page' => '1')
 photo = REXML::XPath.first(doc, '//photo')
 small_photo_url(photo) if photo
end
#---
def small_photo_url(photo)
 server, id, secret = ['server', 'id', 'secret'].collect do |field|
   photo.attribute(field)
 end
 "http://static.flickr.com/#{server}/#{id}_#{secret}_m.jpg"
end
#---

not_found do
  erb :'404'
end

error do
  erb :'500'
end

# http://vivid-flower-63.heroku.com/
get '/' do
  erb :accept
end

post '/display' do
  erb :show
end 