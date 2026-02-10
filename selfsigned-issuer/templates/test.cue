package templates

import (
	certv1 "cert-manager.io/certificate/v1"
)

#TestCertRequest: certv1.#Certificate & {
	#config: #Config
	#Meta: #config.metadata
	metadata: {
		name:      #Meta.name
		namespace: #Meta.namespace
		labels:    #Meta.labels
		if #Meta.annotations != _|_ {
			annotations: #Meta.annotations
		}
	}
	spec: {
  	commonName: "my-selfsigned-ca"
  	secretName: #Meta.name
  	privateKey: {
			algorithm: "ECDSA"
  	  size: 256
		}
  	issuerRef: name: #Meta.name
	}
}
