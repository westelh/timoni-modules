package templates

import (
	vaultauth "secrets.hashicorp.com/vaultauth/v1beta1"
)

#VaultAuth: vaultauth.#VaultAuth & {
	#config: #Config

	metadata: #config.metadata
	spec: {
		method: "kubernetes"

		kubernetes: {
			if #config.audiences != _|_ {
				audiences: #config.audiences
			}
			if #config.role != _|_ {
				role: #config.role
			}
			if #config.serviceAccount != _|_ {
				serviceAccount: #config.serviceAccount
			}
			if #config.tokenExpirationSeconds != _|_ {
				tokenExpirationSeconds: #config.tokenExpirationSeconds
			}
		}

		if #config.allowedNamespaces != _|_ {
			allowedNamespaces: #config.allowedNamespaces
		}

		if #config.headers != _|_ {
			headers: #config.headers
		}

		if #config.mount != _|_ {
			mount: #config.mount
		}
		if #config.namespace != _|_ {
			namespace: #config.namespace
		}
		if #config.params != _|_ {
			params: #config.params
		}

		if #config.vaultConnectionRef != _|_ {
			vaultConnectionRef: #config.vaultConnectionRef
		}
	}
}
