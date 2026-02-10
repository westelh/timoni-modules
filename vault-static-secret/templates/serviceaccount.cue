package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#ServiceAccount: corev1.#ServiceAccount & {
	#config: #Config

	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: #config.metadata & {
		name: #config.serviceAccount.name
	}
	if #config.serviceAccount.labels != _|_ {
		metadata: labels: #config.serviceAccount.labels
	}
	if #config.serviceAccount.annotations != _|_ {
		metadata: annotations: #config.serviceAccount.annotations
	}
	if #config.serviceAccount.automountServiceAccountToken != _|_ {
		automountServiceAccountToken: #config.serviceAccount.automountServiceAccountToken
	}
}
