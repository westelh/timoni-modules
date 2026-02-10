package templates

import (
	connection "secrets.hashicorp.com/vaultconnection/v1beta1"
)

#VaultConnection: connection.#VaultConnection & {
	#config: #Config

	metadata: #config.metadata
	spec: {
		_server:       #config.server
		address:       _server.address
		skipTLSVerify: _server.skipTLSVerify

		if _server.caCertPath != _|_ {
			caCertPath: _server.caCertPath
		}

		if _server.caCertSecretRef != _|_ {
			caCertSecretRef: _server.caCertSecretRef
		}

		if _server.headers != _|_ {
			headers: _server.headers
		}

		if _server.timeout != _|_ {
			timeout: _server.timeout
		}

		if _server.tlsServerName != _|_ {
			tlsServerName: _server.tlsServerName
		}
	}
}
