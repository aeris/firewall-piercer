require 'ipaddr'
require 'socket'
require 'thwait'

module FirewallPiercer
	module Utils
		module Socks
			class Server
				def initialize(socket)
					@socket, @target = socket, socket.peeraddr
					puts "New SOCKS5 server : #{self.to_s}"
				end

				def process
					puts "SOCKS5 server #{self.to_s} : waiting version"
					data = @socket.read 2
					version, n_methods = data.unpack 'CC'
					puts "SOCKS5 server #{self.to_s} : receive version #{version}"
					raise Exception, data unless version == SOCKS_VERSION
					puts "SOCKS5 server #{self.to_s} : waiting methods"
					data = @socket.read n_methods
					methods = data.unpack('C*')
					puts "SOCKS5 server #{self.to_s} : receive methods #{methods}"
					method = (AUTHENTICATION_METHODS & methods).first || NO_ACCEPTABLE_METHODS
					@socket.write [SOCKS_VERSION, method].pack 'CC'
					puts "SOCKS5 server #{self.to_s} : select method #{method}"
					return if method == NO_ACCEPTABLE_METHODS

					puts "SOCKS5 server #{self.to_s} : waiting command"
					data = @socket.read 4
					version, command, rsv, type = data.unpack 'CCCC'
					puts "SOCKS5 server #{self.to_s} : receive command #{command}, type #{type}"
					unless version == SOCKS_VERSION and COMMANDS.include?(command) and rsv == RSV and TYPES.include?(type)
						return
					end
					puts "SOCKS5 server #{self.to_s} : waiting target"
					target = case type
						         when IPv4 then
							         IPAddr::ntop @socket.read 4
						         when DOMAIN_NAME
							         size, _ = @socket.read(1).unpack 'C'
							         @socket.read size
						         when IPv6
							         IPAddr::ntop @socket.read 16
					         end
					port, _ = @socket.read(2).unpack 'S>'
					puts "SOCKS5 server #{self.to_s} : receive target #{target}, type #{port}"
					case command
						when CONNECT
							begin
								puts "SOCKS5 server #{self.to_s} : connecting to #{target}/#{port}"
								@client_socket = TCPSocket.new target, port
								status = SUCCEEDED
								puts "SOCKS5 server #{self.to_s} : connected to #{target}/#{port}"
							rescue Errno::ENETUNREACH
								puts "SOCKS5 server #{self.to_s} : #{target}/#{port} network unreachable"
								status = NETWORK_UNREACHABLE
							rescue Errno::EHOSTUNREACH
								puts "SOCKS5 server #{self.to_s} : #{target}/#{port} host unreachable"
								status = HOST_UNREACHABLE
							rescue Errno::ECONNREFUSED
								puts "SOCKS5 server #{self.to_s} : #{target}/#{port} connection refused"
								status = CONNECTION_REFUSED
							rescue => e
								puts "SOCKS5 server #{self.to_s} : #{target}/#{port} error #{e}"
								status = SOCKS_SERVER_FAILURE
							end
							bind_addr, bind_port = IPAddr.new('0.0.0.0').hton, 0
							@socket.write [SOCKS_VERSION, status, RSV, IPv4, bind_addr, bind_port].pack 'CCCCa*S>'
							raise Exception, status unless status == SUCCEEDED

							begin
								puts "SOCKS5 server #{self.to_s} : connecting sockets"
								FirewallPiercer::Utils::SocketConnector.connect @socket, @client_socket
							ensure
								@client_socket.close unless @client_socket.closed?
							end
					end
				ensure
					@socket.close unless @socket.closed?
					puts "SOCKS5 server #{self.to_s} : end"
				end

				def stop
					puts "SOCKS5 server #{self.to_s} : stopping"
					close
					@thread.wait unless @thread.nil?
					puts "SOCKS5 server #{self.to_s} : stopped"
				end

				def to_s
					"#{@target[2]}/#{@target[1]}"
				end

				private
				def connect(src, dest, name)
					loop { dest.write src.readpartial 1024 }
				ensure
					puts "SOCKS5 server #{self.to_s} : #{name} socket end"
				end

				def close
					@client_socket.close unless @client_socket.nil? or @client_socket.closed?
					@socket.close unless @socket.closed?
				end
			end
		end
	end
end
