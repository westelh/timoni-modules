package templates

import (
	issuerv1 "cert-manager.io/issuer/v1"
	clusterissuerv1 "cert-manager.io/clusterissuer/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#IssuerMeta: {
	#Meta: timoniv1.#Metadata
	metadata: {
		name:      #Meta.name
		namespace: #Meta.namespace
		labels:    #Meta.labels
		if #Meta.annotations != _|_ {
			annotations: #Meta.annotations
		}
	}
}

#Issuer: issuerv1.#Issuer & #IssuerMeta
#ClusterIssuer: clusterissuerv1.#ClusterIssuer & #IssuerMeta

#LetsEncrypt: #Issuer & {
	#config: #Config
	#Meta: #config.metadata
	spec: {
		acme: {
			if #config.production {
				server: "https://acme-v02.api.letsencrypt.org/directory"
			}
			if !#config.production {
				server: "https://acme-staging-v02.api.letsencrypt.org/directory"
			}
			privateKeySecretRef: {
				name: #Meta.name
			}
			solvers: #config.solvers
		}
	}
}

#ClusterLetsEncrypt: #ClusterIssuer & {
	#config: #Config
	#Meta: #config.metadata
	spec: {
		acme: {
			if #config.production {
				server: "https://acme-v02.api.letsencrypt.org/directory"
			}
			if !#config.production {
				server: "https://acme-staging-v02.api.letsencrypt.org/directory"
			}
			privateKeySecretRef: {
				name: #Meta.name
			}
			solvers: #config.solvers
		}
	}
}

