require 'openssl'

module FirewallPiercer
	class Client
		class SocksServer < FirewallPiercer::Utils::Server
			def initialize(client, host: nil, port: 1080)
				super host: host, port: port
				@client = client
			end

			def serve(client)
				puts "SOCKS5 server #{@host}/#{@port} : incoming"
				socket, tls_socket = @client.open
				FirewallPiercer::Utils::SocketConnector.connect tls_socket, client
			rescue => e
				puts "SOCKS5 server #{@host}/#{@port}: error #{e}"
				raise
			ensure
				[tls_socket, socket].each { |s| s.close if s and !s.closed? }
				puts "SOCKS5 server #{@host}/#{@port} : end"
			end
		end
	end
end
