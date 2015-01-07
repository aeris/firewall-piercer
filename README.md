# Firewall Piercer

This application create a SOCKS5 over TLS server, allowing bypass of a facist firewall.

This application also provide client side a SOCKS5 server, a transparent proxy and can use HTTPS proxy to exit.

Can replace Tor if Tor « side effects » (random output IP, latency…) is not acceptable, but your privacy is not protected this way !

## Installation

Require Ruby 2.0.0 or later.

No external ruby dependency.

Just clone this repo :)

## Usage

### Certificates

The client/server communications are protected with TLS and need certificates.

The server strongly authenticate the client with it X.509 certificate.

You can use any X.509 certificates you want, but for easy deployment, there is a `generate_cert.rb` script to generate
client/server keys and certificates.

### Server side

Just run the `server.rb`

By default, the server run on the 443 port.
You can edit the script to select keys/certificates and port to use.

### Client side

Just run the `client.rb`

By default, the client start a SOCKS5 server on 1080 port and a transparent proxy server on 1081.
You can edit the script to select keys/certificates and port to use.

If you have to use a HTTPS proxy server, fill PROXY_HOST and PROXY_PORT.
Currently proxy authentication is not supported.

Just point applications supporting SOCKS5 to the SOCKS port.

If your application don’t support SOCKS5, you can use `iptables` to redirect all the traffic to the server, for example :

    iptables -t nat -A OUTPUT -p tcp --dport ssh --syn -j REDIRECT --to-ports 1081

## License

This software is released under GPLv3 or later license.

# Todo

 * Boot script (SysV/SystemD)
 * Config file
 * Improve logging

# Contributing

1. Fork it ( https://github.com/aeris/firewall-piercer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# I am Charlie

In memory of

 * Charb
 * Cabu
 * Wolinski
 * Tignous
 * Bernard Maris
 * Michel Renaud
 * Honoré
 * Mustapha Ourad
 * Ahmed Merabet
 * Franck Brinsolaro
 * Frédéric Boisseau
 * Elsa Cayat

cartoonists, journalists, police officers or citizens, killed this 01/07/2015 for defending freedom speech.

Just my very tiny contribution for defending this kind of freedom on this world, compared to theirs…
