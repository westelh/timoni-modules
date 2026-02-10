package templates

import (
	networkingv1 "k8s.io/api/networking/v1"
)

#Ingress: networkingv1.#Ingress & {
	#config: #Config

	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata:   #config.metadata

	spec: {
		if #config.ingressClassName != _|_ {
			ingressClassName: #config.ingressClassName
		}
		if #config.defautBackend != _|_ {
			defautBackend: #config.defautBackend
		}
		if #config.tls != _|_ {
			tls: #config.tls
		}
		if #config.rules != _|_ {
			rules: #config.rules
		}
	}
}
