#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'json'

class TranmissionContral
  def initialize
	@uri = URI("http://localhost:9091/transmission/rpc")
	res = Net::HTTP.get_response(@uri)
	@session = res["X-Transmission-Session-Id"]
	@tags=Random.rand().floor
  end
  def addTorrent(filePath)
	http = Net::HTTP.new(@uri.host, @uri.port)
	req = Net::HTTP::Post.new(@uri.path, initheader = {'Content-Type' =>'application/json', 'X-Transmission-Session-Id' => @session})
	json = {
	  "method" => "torrent-add",
	  "arguments" => {
	    "filename" => "#{filePath}"
	  },
	  "tags" => @tags
	}.to_json
	req.body=json
	res = http.request(req)
	puts "Response #{res.code} #{res.message}: #{res.body}"
  end
end

if __FILE__ == $0
  contral = TranmissionContral.new
  contral.addTorrent(ARGV[1])
end
