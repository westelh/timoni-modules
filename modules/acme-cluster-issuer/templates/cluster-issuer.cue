package templates

import (
	clusterissuerv1 "cert-manager.io/clusterissuer/v1"
)

#ClusterIssuer: clusterissuerv1.#ClusterIssuer & {
	#config: #Config

	apiVersion: "cert-manager.io/v1"
	kind:       "ClusterIssuer"
	metadata:   #config.metadata
	spec:       #config.spec
}
