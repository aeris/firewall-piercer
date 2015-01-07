require 'socket'
require 'thread'

module FirewallPiercer
	module Utils
		class TlsServer < Server
			def initialize(host: nil, port: nil, key: nil, cert: nil, ca: ca, method: :TLSv1_2_server, ciphers: 'ECDH+AES:EDH+AES:!SHA:@STRENGTH')
				super host: host, port: port

				tls_context = method ? OpenSSL::SSL::SSLContext.new : OpenSSL::SSL::SSLContext.new(method)
				tls_context.key = key if key
				tls_context.cert = cert if cert
				if ca
					tls_context.ca_file = ca
					tls_context.verify_mode = OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT
				end
				tls_context.ciphers = ciphers if ciphers
				tls_context.options = OpenSSL::SSL::OP_CIPHER_SERVER_PREFERENCE | OpenSSL::SSL::OP_NO_COMPRESSION

				@tls_server = OpenSSL::SSL::SSLServer.new @server, tls_context
			end

			def accept
				@tls_server.accept
			end

			def close
				@tls_server.close unless @tls_server.closed?
				super
			end
		end
	end
end
