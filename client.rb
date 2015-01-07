#!/usr/bin/env ruby
$:.unshift 'lib'
require 'firewall_piercer'
require 'openssl'

key = OpenSSL::PKey.read File.new 'server.pem'
cert = OpenSSL::X509::Certificate.new File.new 'server.crt'
ca = File.join Dir.pwd, 'server.crt'

TRANS_HOST, TRANS_PORT = %w(127.0.0.1 ::1), 1081
SOCKS_HOST, SOCKS_PORT = %w(127.0.0.1 ::1), 1080
HTTP_PROXY_HOST, HTTP_PROXY_PORT = 'http.proxy.internal', 3128
PROXY_HOST, PROXY_PORT = 'socks.proxy.external', 443

server = FirewallPiercer::Client.new socks_host: SOCKS_HOST, socks_port: SOCKS_PORT,
                                     trans_host: TRANS_HOST, trans_port: TRANS_PORT,
                                     server_host: PROXY_HOST, server_port: PROXY_PORT,
                                     key: key, cert: cert, ca: ca,
                                     http_proxy_host: HTTP_PROXY_HOST, http_proxy_port: HTTP_PROXY_PORT
server.start
trap('INT') { server.stop; exit }
sleep
