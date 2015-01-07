require 'thread'
require 'thwait'

module FirewallPiercer
	module Utils
		class SocketConnector
			def self.connect(socket1, socket2)
				threads = [
						Thread.new { pair_connect socket1, socket2 },
						Thread.new { pair_connect socket2, socket1 }
				]
				waiting = ThreadsWait.new *threads
				waiting.join
				threads.each { |t| t.raise 'stop' }
				waiting.all_waits
			end

			private
			def self.pair_connect(src, dest)
				loop { dest.write src.readpartial 1024 }
			end
		end
	end
end
