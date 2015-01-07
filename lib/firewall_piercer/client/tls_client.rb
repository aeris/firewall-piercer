require 'openssl'
require 'socket'

module FirewallPiercer
	class Client
		class TlsClient
			def initialize(server_host: nil, server_port: 443,
			               key: nil, cert: nil, ca: ca, method: :TLSv1_2_client, ciphers: 'ECDH+AES:EDH+AES:!SHA:@STRENGTH',
			               http_proxy_host: nil, http_proxy_port: nil)
				@server_host, @server_port = server_host, server_port

				@tls_context = method ? OpenSSL::SSL::SSLContext.new : OpenSSL::SSL::SSLContext.new(method)
				@tls_context.key = key if key
				@tls_context.cert = cert if cert
				if ca
					@tls_context.ca_file = ca
					@tls_context.verify_mode = OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT
				end
				@tls_context.ciphers = ciphers if ciphers

				@http_proxy_host, @http_proxy_port = http_proxy_host, http_proxy_port
			end

			def open
				puts "TLS SOCKS5 client #{@server_host}/#{@server_port} : connecting"
				socket = if @http_proxy_host
					         puts "TLS SOCKS5 client #{@server_host}/#{@server_port} : using #{@http_proxy_host}/#{@http_proxy_port} HTTPS proxy"
					         socket = TCPSocket.new @http_proxy_host, @http_proxy_port
					         FirewallPiercer::Utils::HttpConnect.connect socket, @server_host, @server_port
					     else
						     TCPSocket @server_host, @server_port
					     end
				puts "TLS SOCKS5 client #{@server_host}/#{@server_port} : TCP connected"
				tls_socket = OpenSSL::SSL::SSLSocket.new socket, @tls_context
				tls_socket.hostname = @server_host
				tls_socket.connect
				puts "TLS SOCKS5 client #{@server_host}/#{@server_port} : TLS connected"
				[socket, tls_socket]
			end
		end
	end
end
