require 'ipaddr'
require 'socket'
require 'thwait'

module FirewallPiercer
	module Utils
		module Socks
			module Client
				def self.connect(socket, type, host, port)
					puts "SOCKS5 client #{type}/#{host}/#{port} : send version"
					socket.write [SOCKS_VERSION, 1, NO_AUTHENTICATION_REQUIRED].pack 'CCC'
					data = socket.read 2
					version, method = data.unpack 'CC'
					puts "SOCKS5 client #{type}/#{host}/#{port} : receive version"
					raise Exception, data unless version == SOCKS_VERSION and method == NO_AUTHENTICATION_REQUIRED

					t, target = case type
						               when :ipv4 then
							               [IPv4, IPAddr.new(host).hton]
						               when :ipv6 then
							               [IPv6, IPAddr.new(host).hton]
						               when :domain then
							               [DOMAIN_NAME, host]
					               end
					puts "SOCKS5 client #{type}/#{host}/#{port} : connect"
					socket.write [SOCKS_VERSION, CONNECT, RSV, t, target, port].pack 'CCCCa*S>'

					data = socket.read 4
					version, reply, rsv, t = data.unpack 'CCCC'
					raise Exception, data unless version == SOCKS_VERSION and reply == SUCCEEDED and rsv == RSV

					case t
						when IPv4
							socket.read 4
						when DOMAIN_NAME
							size, _ = socket.read(1).unpack 'C'
							socket.read size
						when IPv6
							socket.read 16
					end
					socket.read 2
					puts "SOCKS5 client #{type}/#{host}/#{port} : connected"

					socket
				end
			end
		end
	end
end
