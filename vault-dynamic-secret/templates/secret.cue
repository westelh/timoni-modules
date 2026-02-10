package templates

import(
	dynamicSecret "secrets.hashicorp.com/vaultdynamicsecret/v1beta1"
)

#VaultDynamicSecret: dynamicSecret.#VaultDynamicSecret & {
	#config: #Config

	metadata: #config.metadata
	spec: {
		destination: {
			if #config.destination.annotations != _|_ {
				annotations: #config.destination.annotations
			}

			if #config.destination.labels!= _|_ {
				labels: #config.destination.labels
			}

			if #config.destination.create!= _|_ {
				create: #config.destination.create
			}

			name: #config.destination.name

			if #config.destination.overwrite != _|_ {
				overwrite: #config.destination.overwrite
			}
		}

		mount: #config.mount

		if #config.namespace != _|_ {
			namespace: #config.namespace
		}

		if #config.params != _|_ {
			params: #config.params
		}

		path: #config.path

		if #config.renewalPercent != _|_ {
			renewalPercent: #config.renewalPercent
		}

		if #config.revoke != _|_ {
			revoke: #config.revoke
		}

		if #config.rolloutRestartTargets != _|_ {
			rolloutRestartTargets: #config.rolloutRestartTargets
		}

		if #config.vaultAuthRef != _|_ {
			vaultAuthRef: #config.vaultAuthRef
		}
	}
}

