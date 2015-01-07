module FirewallPiercer
	class Server < FirewallPiercer::Utils::Server
		def serve(socket)
			FirewallPiercer::Utils::Socks::Server.new(socket).process
		end
	end

	class TlsServer < FirewallPiercer::Utils::TlsServer
		def serve(socket)
			FirewallPiercer::Utils::Socks::Server.new(socket).process
		end
	end
end
