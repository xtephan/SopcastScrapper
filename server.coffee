### 
Node.js Server, translated in coffeescript
 (c) 2014 Stefan Fodor
 Scraps Websites for Sopcast URLS
###

#vars
http = require 'http'
jsdom = require 'jsdom'
io = require 'socket.io'
all_sources = []

#Create ze server
server = http.createServer (request, response) -> 
  response.end 'hello world' 
  return

server.listen 1337

#Main Scrapper for Cool-tv
cool_tv_scrapper = ()->
	
	console.log "Scrapping cool-tv.ro..."

	sources = [  
		"http://www.cool-tv.ro/ch/protv.html",
		"http://www.cool-tv.ro/ch/protv-s2.html",
		"http://www.cool-tv.ro/ch/protv-s3.html",
		"http://www.cool-tv.ro/ch/protv-s4.html",
		"http://www.cool-tv.ro/ch/protv-s5.html",
		"http://www.cool-tv.ro/ch/protv-s6.html"
	]

	find_sopcast_url = (source)->
		jsdom.env {
		  url: source,
		  scripts: ["http://code.jquery.com/jquery.js"],
		  done: (errors, window)->
				 
			    url = window.$("#SopPlayer").find("[name='SopAddress']").val()
			    title = window.$("em").first().html()
			    all_sources.push { url: url, source: source, title: title } if url
	
			    return 
		}
		return
		
	find_sopcast_url source for source in sources

	return

# sockets logic
socket = io.listen(server)

socket.on('connection', (client) ->

	#Client Connected, lets send the urls cached
	client.emit 'url_updated', all_sources
  
  	#Client requested an uddate
	client.on 'update_url', ()->
  		
  		all_sources = []
  		cool_tv_scrapper()
		
		return
  
	return
)


# Scrap Data on first run
cool_tv_scrapper()

console.log "All right, dawg!"