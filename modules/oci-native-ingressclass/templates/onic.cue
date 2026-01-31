package templates

import (
	"encoding/json"
	networkv1 "k8s.io/api/networking/v1"
)

#Params: {
	#config: #Config
	apiVersion: "ingress.oraclecloud.com/v1beta1"
	kind: "IngressClassParameters"
	metadata: #config.metadata
	spec: {
		compartmentId: #config.compartmentId
		subnetId: #config.subnetId
		loadBalancerName: #config.loadBalancerName
		isPrivate: #config.isPrivateLB
		maxBandwidthMbps: #config.maxBandwidthMbps
		minBandwidthMbps: #config.minBandwidthMbps
	}
}

#ONIC: networkv1.#IngressClass & {
	#config: #Config
	#params: #Params
	apiVersion: "networking.k8s.io/v1"
	kind: "IngressClass"
	metadata: #config.metadata
	if #config.isDefault {
		metadata: annotations: {
			"ingressclass.kubernetes.io/is-default-class": "true"
		}
	}
	metadata: annotations: {
		"oci-native-ingress.oraclecloud.com/network-security-group-ids": #config.nsgId
		if len(#config.definedTags) != 0 {
			"oci-native-ingress.oraclecloud.com/defined-tags": json.Marshal(#config.definedTags)
		}
		if len(#config.freeformTags) != 0 {
			"oci-native-ingress.oraclecloud.com/freeform-tags": json.Marshal(#config.freeformTags)
		}
	}
	spec: {
		controller: "oci.oraclecloud.com/native-ingress-controller"
		parameters: {
			scope: "Namespace"
			namespace: #params.metadata.namespace
			apiGroup: "ingress.oraclecloud.com"
			kind: "ingressclassparameters"
			name: #params.metadata.name
		}
	}
}
