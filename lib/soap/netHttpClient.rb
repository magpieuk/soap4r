=begin
SOAP4R - net/http wrapper
Copyright (C) 2003  NAKAMURA, Hiroshi.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PRATICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 675 Mass
Ave, Cambridge, MA 02139, USA.
=end


require 'net/http'


module SOAP


class NetHttpClient

  attr_accessor :proxy
  attr_accessor :debug_dev
  attr_reader :session_manager

  class SessionManager
    attr_accessor :connect_timeout
    attr_accessor :send_timeout
    attr_accessor :receive_timeout
  end

  class Response
    attr_reader :content
    attr_reader :status
    attr_reader :reason
    attr_reader :contenttype

    def initialize(res)
      @status = res.code.to_i
      @reason = res.message
      @contenttype = res['content-type']
      @content = res.body
    end
  end

  def initialize(proxy = nil, agent = nil)
    @proxy = proxy
    @agent = agent
    @debug_dev = nil
    @session_manager = SessionManager.new
  end

  def reset(url)
    # ignored.
  end

  def post(url, req_body, header = {})
    url = URI.parse(url)
    extra = header.dup
    extra['User-Agent'] = @agent if @agent
    res = start(url) { |http|
	http.post(url.instance_eval('path_query'), req_body, extra)
      }
    Response.new(res)
  end

  def get_content(url, header = {})
    url = URI.parse(url)
    extra = header.dup
    extra['User-Agent'] = @agent if @agent
    res = start(url) { |http|
	http.get(url.instance_eval('path_query'), extra)
      }
    res.body
  end

private

  def start(url)
    proxy_host = @proxy ? @proxy.host : nil
    proxy_port = @proxy ? @proxy.port : nil
    response = nil
    Net::HTTP::Proxy(proxy_host, proxy_port).start(url.host, url.port) { |http|
      if http.respond_to?(:set_debug_output)
	http.set_debug_output(@debug_dev)
      end
      response, = yield(http)
    }
    response
  end
end


end