require 'openssl'

module FirewallPiercer
	autoload :Client, 'firewall_piercer/client'
	autoload :Server, 'firewall_piercer/server'
	autoload :TlsServer, 'firewall_piercer/server'

	module Utils
		autoload :HttpConnect, 'firewall_piercer/utils/http_connect'
		autoload :Server, 'firewall_piercer/utils/server'
		autoload :SocketConnector, 'firewall_piercer/utils/socket_connector'
		autoload :TlsServer, 'firewall_piercer/utils/tls_server'

		module Socks
			require 'firewall_piercer/utils/socks/constants'
			autoload :Client, 'firewall_piercer/utils/socks/client'
			autoload :Server, 'firewall_piercer/utils/socks/server'
		end
	end

	class Client
		autoload :SocksServer, 'firewall_piercer/client/socks_server'
		autoload :TransportServer, 'firewall_piercer/client/transport_server'
		autoload :TlsClient, 'firewall_piercer/client/tls_client'
	end
end
