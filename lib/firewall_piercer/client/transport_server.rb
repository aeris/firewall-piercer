require 'ipaddr'
require 'openssl'
require 'socket'

module FirewallPiercer
	class Client
		class TransportServer < FirewallPiercer::Utils::Server
			SO_ORIGINAL_DST = 80
			IP6T_SO_ORIGINAL_DST = 80
			SOL_IPV6 = 41

			def initialize(client, host: nil, port: 1081)
				super host: host, port: port
				@client = client
			end

			def serve(client)
				puts "Transport server #{@host}/#{@port}: incoming client"
				family = client.addr[0]
				family, level, name = case family
					                      when 'AF_INET' then
						                      [:ipv4, Socket::SOL_IP, SO_ORIGINAL_DST]
					                      when 'AF_INET6' then
						                      [:ipv6, SOL_IPV6, IP6T_SO_ORIGINAL_DST]
				                      end
				port, host = Socket.unpack_sockaddr_in client.getsockopt(level, name).data
				puts "Transport server #{@host}/#{@port} : request #{host}/#{port}"
				socket, tls_socket = @client.open
				FirewallPiercer::Utils::Socks::Client.connect tls_socket, family, host, port
				FirewallPiercer::Utils::SocketConnector.connect tls_socket, client
				puts "Transport server #{@host}/#{@port} to #{host}/#{port} : end"
			ensure
				[tls_socket, socket].each { |s| s.close if s and !s.closed? }
			end
		end
	end
end
