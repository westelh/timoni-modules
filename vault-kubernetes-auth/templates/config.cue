package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
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

	// AllowedNamespaces Kubernetes Namespaces which are allow-listed
	// for use with this AuthMethod.
	// This field allows administrators to customize which Kubernetes
	// namespaces are authorized to
	// use with this AuthMethod. While Vault will still enforce its
	// own rules, this has the added
	// configurability of restricting which VaultAuthMethods can be
	// used by which namespaces.
	// You only need to set allowedNamespaces when you want to control
	// access from a resource in
	// a different namespace than the VaultAuth it references. Secret
	// resources in
	// the same namespace as the VaultAuth bypass this check.
	// Accepted values:
	// []{"*"} - wildcard, all namespaces.
	// []{"a", "b"} - list of namespaces.
	// unset - disallow all namespaces except the Operator's the
	// VaultAuthMethod's namespace, this
	// is the default behavior.
	allowedNamespaces?: [...string]

	// Headers to be included in all Vault requests.
	headers?: {[string]: string}

	// TokenAudiences to include in the ServiceAccount token.
	audiences?: [...string]

	// Role to use for authenticating to Vault.
	role?: string

	// ServiceAccount to use when authenticating to Vault's
	// authentication backend. This must reside in the consuming
	// secret's (VDS/VSS/PKI) namespace.
	serviceAccount?: string

	// TokenExpirationSeconds to set the ServiceAccount token.
	tokenExpirationSeconds?: int64 & >=600

	// Mount to use when authenticating to auth method.
	mount?: string

	// Namespace to auth to in Vault
	namespace?: string

	// Params to use when authenticating to Vault
	params?: {
		[string]: string
	}

	// VaultConnectionRef to the VaultConnection resource, can be
	// prefixed with a namespace,
	// eg: `namespaceA/vaultConnectionRefB`. If no namespace prefix is
	// provided it will default to
	// the namespace of the VaultConnection CR. If no value is
	// specified for VaultConnectionRef the
	// Operator will default to the `default` VaultConnection,
	// configured in the operator's namespace.
	vaultConnectionRef?: string
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		auth: #VaultAuth & {#config: config}
	}
}
