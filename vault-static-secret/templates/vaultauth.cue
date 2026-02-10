package templates

import (
	vaultauthv1beta1 "secrets.hashicorp.com/vaultauth/v1beta1"
)

#VaultAuth: vaultauthv1beta1.#VaultAuth & {
	#config: #Config
	#vc:     #VaultConnection

	metadata: #config.metadata
	spec: #config.auth & {
		vaultConnectionRef: #vc.metadata.name
		if #config.serviceAccount.create {
			if #config.auth.kubernetes != _|_ {
				kubernetes: serviceAccount: *#config.serviceAccount.name | string
			}
			if #config.auth.jwt != _|_ {
				jwt: serviceAccount: *#config.serviceAccount.name | string
			}
		}
	}
}
