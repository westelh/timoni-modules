# vault-dynamic-secret

A [timoni.sh](http://timoni.sh) module for creating a Vault Secrets Operator `VaultDynamicSecret` resource.

## Install

This module requires the HashiCorp Vault Secrets Operator CRDs (including `VaultDynamicSecret`) to be installed in the cluster.

To create an instance using the default values:

```shell
timoni -n default apply vault-dynamic-secret oci://ghcr.io/westelh/timoni/modules/xxx
```

To change the [default configuration](#configuration),
create one or more `values.cue` files and apply them to the instance.

For example, create a file `my-values.cue` with the following content:

```cue
values: {
	destination: {
		name:      "app-credentials"
		create:    true
		overwrite: true
	}
	mount:        "database"
	path:         "creds/app"
	vaultAuthRef: "vault-auth"
	rolloutRestartTargets: [{
		kind: "Deployment"
		name: "app"
	}]
}
```

And apply the values with:

```shell
timoni -n default apply vault-dynamic-secret oci://ghcr.io/westelh/timoni/modules/xxx \
--values ./my-values.cue
```

## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n default delete vault-dynamic-secret
```

## Configuration

### General values

| Key                         | Type                  | Default | Description |
|-----------------------------|-----------------------|---------|-------------|
| `metadata: labels:`         | `{[ string]: string}` | `{}`    | Common labels for all resources. The `app.kubernetes.io/name` and `app.kubernetes.io/version` labels are managed by the module. |
| `metadata: annotations:`    | `{[ string]: string}` | `unset` | Common annotations for all resources. |
| `destination: annotations:` | `{[string]: string}`  | `unset` | Annotations applied to the destination Secret (requires `destination.create: true`). |
| `destination: labels:`      | `{[string]: string}`  | `unset` | Labels applied to the destination Secret (requires `destination.create: true`). |
| `destination: create:`      | `bool`                | `unset` | Create the destination Secret. Set to `false` if it already exists. |
| `destination: name:`        | `string`              | `unset` | Name of the destination Secret. |
| `destination: overwrite:`   | `bool`                | `unset` | Overwrite the destination Secret when `destination.create: true`. Useful for migrations. |
| `mount:`                    | `string`              | `unset` | Vault secrets engine mount path. |
| `namespace:`                | `string`              | `unset` | Vault namespace for the secrets engine mount. If unset, the namespace from the `VaultAuth` is inferred. |
| `params:`                   | `{[string]: string}`  | `unset` | Additional parameters to pass when requesting credentials/secrets. When set, the operator ignores `requestHTTPMethod`. |
| `path:`                     | `string`              | `unset` | Vault path (relative to `mount`) to request credentials for. |
| `renewalPercent:`           | `uint`                | `unset` | Renewal percentage for syncing when the secrets engine does not provide a lease TTL (maximum `90`). |
| `revoke:`                   | `bool`                | `unset` | Revoke the existing lease when the `VaultDynamicSecret` is deleted. |
| `rolloutRestartTargets:`    | `[...]`               | `unset` | Resources to rollout-restart when the secret changes. Each item includes `kind` (`Deployment`, `DaemonSet`, `StatefulSet`, `argo.Rollout`) and `name`. |
| `vaultAuthRef:`             | `string`              | `unset` | Reference to a `VaultAuth` resource, optionally prefixed with a namespace (for example, `namespace-a/vault-auth`). If unset, the operator defaults to `default` in its namespace. |

#### Recommended values

Typical configuration for an app consuming dynamic credentials:

```cue
values: {
	destination: {
		name:   "app-credentials"
		create: true
	}
	mount:        "database"
	path:         "creds/app"
	vaultAuthRef: "vault-auth"
}
```
