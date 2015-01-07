require 'openssl'

module FirewallPiercer
	class Client
		def initialize(socks_host: %w(127.0.0.1 ::1), socks_port: 1080,
		               trans_host: %w(127.0.0.1 ::1), trans_port: 1081,
		               server_host: nil, server_port: 443,
		               key: nil, cert: nil, ca: ca, method: :TLSv1_2_client, ciphers: 'ECDH+AES:EDH+AES:!SHA:@STRENGTH',
		               http_proxy_host: nil, http_proxy_port: nil)
			@servers = []
			tls_client = TlsClient.new server_host: server_host, server_port: server_port,
			                           key: key, cert: cert, ca: ca, method: method, ciphers: ciphers,
			                           http_proxy_host: http_proxy_host, http_proxy_port: http_proxy_port
			(socks_host || []).each { |h| @servers << SocksServer.new(tls_client, host: h, port: socks_port) }
			(trans_host || []).each { |h| @servers << TransportServer.new(tls_client, host: h, port: trans_port) }
		end

		def start
			@servers.each { |s| s.start }
		end

		def stop
			@servers.each { |s| s.stop }
		end
	end
end
