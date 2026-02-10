package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
	networkingv1 "k8s.io/api/networking/v1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// The kubeVersion is a required field, set at apply-time
	// via timoni.cue by querying the user's Kubernetes API.
	kubeVersion!: string
	// Using the kubeVersion you can enforce a minimum Kubernetes minor version.
	// By default, the minimum Kubernetes version is set to 1.20.
	clusterVersion: timoniv1.#SemVer & {#Version: kubeVersion, #Minimum: "1.20.0"}

	// The moduleVersion is set from the user-supplied module version.
	// This field is used for the `app.kubernetes.io/version` label.
	moduleVersion!: string

	// The Kubernetes metadata common to all resources.
	// The `metadata.name` and `metadata.namespace` fields are
	// set from the user-supplied instance name and namespace.
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}

	// The labels allows adding `metadata.labels` to all resources.
	// The `app.kubernetes.io/name` and `app.kubernetes.io/version` labels
	// are automatically generated and can't be overwritten.
	metadata: labels: timoniv1.#Labels

	// The annotations allows adding `metadata.annotations` to all resources.
	metadata: annotations?: timoniv1.#Annotations

	issuer?: string

	clusterIssuer?: string

	ociNativeIngress?: {
		protocol?:           "HTTP2" | "TCP"
		backendTlsEnabled?:  bool
		httpListernerPort?:  int
		httpsListernerPort?: int
		policy?:             string
		healthCheck?: {
			protocol?:       string
			port?:           int
			path?:           string
			intervalMs?:     int
			timeoutMs?:      int
			retries?:        int
			returnCode?:     int
			responseRegex?:  string
			forcePlainText?: bool
		}
	}

	ingressClassName?: string

	defaultBackend?: networkingv1.#IngressBackend

	tls?: [...networkingv1.#IngressTLS]

	rules?: [...networkingv1.#IngressRule]

	if clusterIssuer != _|_ {
		metadata: annotations: "cert-manager.io/cluster-issuer": clusterIssuer
	}

	if issuer != _|_ {
		metadata: annotations: "cert-manager.io/issuer": issuer
	}

	if ociNativeIngress != _|_ {
		let it = ociNativeIngress
		if it.protocol != _|_ {
			metadata: annotations: "oci-native-ingress.oraclecloud.com/protocol": "\(it.protocol)"
		}
		if it.backendTlsEnabled != _|_ {
			metadata: annotations: "oci-native-ingress.oraclecloud.com/backend-tls-enabled": "\(it.backendTlsEnabled)"
		}
		if it.httpListernerPort != _|_ {
			metadata: annotations: "oci-native-ingress.oraclecloud.com/http-listener-port": "\(it.httpListernerPort)"
		}
		if it.httpsListernerPort != _|_ {
			metadata: annotations: "oci-native-ingress.oraclecloud.com/https-listener-port": "\(it.httpsListernerPort)"
		}
		if it.policy != _|_ {
			metadata: annotations: "oci-native-ingress.oraclecloud.com/policy": "\(it.policy)"
		}
		if it.healthCheck != _|_ {
			let it = it.healthCheck
			if it.protocol != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-protocol": "\(it.protocol)"
			}
			if it.port != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-port": "\(it.port)"
			}
			if it.path != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-path": "\(it.path)"
			}
			if it.intervalMs != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-interval-milliseconds": "\(it.intervalMs)"
			}
			if it.timeoutMs != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-timeout-milliseconds": "\(it.timeoutMs)"
			}
			if it.retries != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-retries": "\(it.retries)"
			}
			if it.returnCode != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-return-code": "\(it.returnCode)"
			}
			if it.responseRegex != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-response-regex": "\(it.responseRegex)"
			}
			if it.forcePlainText != _|_ {
				metadata: annotations: "oci-native-ingress.oraclecloud.com/healthcheck-path": "\(it.forcePlainText)"
			}
		}
	}
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		ingress: #Ingress & {#config: config}
	}
}
