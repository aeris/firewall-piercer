require 'socket'
require 'thread'

module FirewallPiercer
	module Utils
		class Server
			class StopException < Exception
			end

			def initialize(host: nil, port: 1080)
				@host, @port = host, port
				@server = TCPServer.new host, port
				puts "New server : #{@host}/#{@port}"
			end

			def accept
				@server.accept
			end

			def close
				@server.close unless @server.closed?
			end

			def start
				puts "Server #{@host}/#{@port} : starting"
				@thread = Thread.new do
					loop do
						puts "Server #{@host}/#{@port} : waiting incoming resquest"
						begin
							Thread.new(accept) do |s|
								begin
									serve s
								ensure
									s.close
								end
							end
						rescue StopException
							break
						rescue => e
							puts "Server #{@host}/#{@port} : error #{e}"
						end
					end
				end
				puts "Server #{@host}/#{@port} : started"
			end

			def stop
				puts "Server #{@host}/#{@port} : stopping"
				if @thread
					@thread.raise StopException.new
					@thread.join
				end
				close
				puts "Server #{@host}/#{@port} : stopped"
			end
		end
	end
end
