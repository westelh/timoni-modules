package templates

import (
	issuerv1 "cert-manager.io/issuer/v1"
)

#Issuer: issuerv1.#Issuer & {
	#config: #Config

	apiVersion: "cert-manager.io/v1"
	kind:       "Issuer"
	metadata:   #config.metadata
	spec:       #config.spec
}
