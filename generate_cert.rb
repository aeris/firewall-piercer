#!/usr/bin/env ruby
$:.unshift 'lib'
require 'openssl'

unless File.exist? 'server.pem'
	key = OpenSSL::PKey::RSA.new 4096
	File.write 'server.pem', key.to_pem
end

unless File.exist? 'server.cert'
	key = OpenSSL::PKey.read File.new 'server.pem'

	name            = OpenSSL::X509::Name.parse 'CN=*.your.domain.name'
	cert            = OpenSSL::X509::Certificate.new
	cert.version    = 2
	cert.serial     = 0
	cert.not_before = Time.now
	cert.not_after  = Time.now + 60*60*24*365
	cert.public_key = key
	cert.subject    = name
	cert.issuer     = name

	extension_factory                     = OpenSSL::X509::ExtensionFactory.new nil, cert
	extension_factory.subject_certificate = cert
	extension_factory.issuer_certificate  = cert

	cert.add_extension extension_factory.create_extension 'basicConstraints', 'CA:TRUE', true
	cert.add_extension extension_factory.create_extension 'keyUsage', 'keyEncipherment,dataEncipherment,digitalSignature,nonRepudiation,keyCertSign'
	cert.add_extension extension_factory.create_extension 'extendedKeyUsage', 'serverAuth,clientAuth'
	cert.add_extension extension_factory.create_extension 'subjectKeyIdentifier', 'hash'
	cert.add_extension extension_factory.create_extension 'authorityKeyIdentifier', 'keyid:always'
	cert.add_extension extension_factory.create_extension 'subjectAltName', 'DNS:localhost'

	cert.sign key, OpenSSL::Digest::SHA512.new
	File.write 'server.crt', cert.to_pem
end
