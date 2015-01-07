module FirewallPiercer
	module Utils
		module HttpConnect
			class ConnectException < Exception
			end

			def self.connect(socket, hostname, port)
				socket.write "CONNECT #{hostname}:#{port} HTTP/1.0\r\n\r\n"
				data = socket.gets
				raise ConnectException.new, "Unexpected response: #{data}" unless data =~ %r{\AHTTP/1\.[01] 200 .*Connection established\r\n}m
				until socket.gets == "\r\n"
				end
				socket
			end
		end
	end
end
