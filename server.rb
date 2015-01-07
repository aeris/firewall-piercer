#!/usr/bin/env ruby
$:.unshift 'lib'
require 'firewall_piercer'
require 'openssl'

key = OpenSSL::PKey.read File.new 'server.pem'
cert = OpenSSL::X509::Certificate.new File.new 'server.crt'
ca = File.join Dir.pwd, 'server.crt'

TLS_HOST, TLS_PORT = %w(::), 443

servers = TLS_HOST.collect do |h|
	server = FirewallPiercer::TlsServer.new host: h, port: TLS_PORT, key: key, cert: cert, ca: ca
	server.start
	server
end
trap('INT') do
	servers.each { |s| s.stop }
	exit
end
sleep
