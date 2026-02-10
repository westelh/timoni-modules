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

	destination: {
		// Annotations to apply to the Secret. Requires Create to be set
		// to true.
		annotations?: { [string]: string }

		// Labels to apply to the Secret. Requires Create to be set to
		// true.
		labels?: { [string]: string }

		// Create the destination Secret.
		// If the Secret already exists this should be set to false.
		create?: bool

		// Name of the Secret
		name!: string

		// Overwrite the destination Secret if it exists and Create is
		// true. This is
		// useful when migrating to VSO from a previous secret deployment
		// strategy.
		overwrite?: bool
	}

	// Mount path of the secret's engine in Vault.
	mount!: string

	// Namespace of the secrets engine mount in Vault. If not set, the
	// namespace that's
	// part of VaultAuth resource will be inferred.
	namespace?: string

	// Params that can be passed when requesting credentials/secrets.
	// When Params is set the configured RequestHTTPMethod will be
	// ignored. See RequestHTTPMethod for more details.
	// Please consult
	// https://developer.hashicorp.com/vault/docs/secrets if you are
	// uncertain about what 'params' should/can be set to.
	params?: { [string]: string }

	// Path in Vault to get the credentials for, and is relative to
	// Mount.
	// Please consult
	// https://developer.hashicorp.com/vault/docs/secrets if you are
	// uncertain about what 'path' should be set to.
	path!: string

	// RefreshAfter a period of time for VSO to sync the source secret
	// data, in
	// duration notation e.g. 30s, 1m, 24h. This value only needs to
	// be set when
	// syncing from a secret's engine that does not provide a lease
	// TTL in its
	// response. The value should be within the secret engine's
	// configured ttl or
	// max_ttl. The source secret's lease duration takes precedence
	// over this
	// configuration when it is greater than 0.
	renewalPercent?: uint & <=90

	// Revoke the existing lease on VDS resource deletion.
	revoke?: bool

	// RolloutRestartTargets should be configured whenever the
	// application(s) consuming the Vault secret does
	// not support dynamically reloading a rotated secret.
	// In that case one, or more RolloutRestartTarget(s) can be
	// configured here. The Operator will
	// trigger a "rollout-restart" for each target whenever the Vault
	// secret changes between reconciliation events.
	// See RolloutRestartTarget for more details.
	rolloutRestartTargets?: [...{
		// Kind of the resource
		kind!: "Deployment" | "DaemonSet" | "StatefulSet" | "argo.Rollout"

		// Name of the resource
		name!: string
	}]

	// VaultAuthRef to the VaultAuth resource, can be prefixed with a
	// namespace,
	// eg: `namespaceA/vaultAuthRefB`. If no namespace prefix is
	// provided it will default to
	// the namespace of the VaultAuth CR. If no value is specified for
	// VaultAuthRef the Operator
	// will default to the `default` VaultAuth, configured in the
	// operator's namespace.
	vaultAuthRef?: string
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		secret: #VaultDynamicSecret & { #config: config }
	}
}
