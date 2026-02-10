# vault-kubernetes-auth

A [timoni.sh](http://timoni.sh) module for creating a Vault Secrets Operator `VaultAuth` resource configured for the Kubernetes auth method.

## Install

This module requires the HashiCorp Vault Secrets Operator CRDs (including `VaultAuth`) to be installed in the cluster.

To create an instance using the default values:

```shell
timoni -n default apply vault-kubernetes-auth oci://<container-registry-url>
```

To change the [default configuration](#configuration),
create one or more `values.cue` files and apply them to the instance.

For example, create a file `my-values.cue` with the following content:

```cue
values: {
	role:           "app-role"
	serviceAccount: "app-sa"
	audiences:      ["vault"]
	allowedNamespaces: [
		"apps",
	]
	vaultConnectionRef: "vault-connection"
}
```

And apply the values with:

```shell
timoni -n default apply vault-kubernetes-auth oci://<container-registry-url> \
--values ./my-values.cue
```

## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n default delete vault-kubernetes-auth
```

## Configuration

### General values

| Key                       | Type                  | Default           | Description                                                                                                                                                                                                                              |
|---------------------------|-----------------------|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `metadata: labels:`       | `{[ string]: string}` | `{}`              | Common labels for all resources. The `app.kubernetes.io/name` and `app.kubernetes.io/version` labels are managed by the module.                                                                                                        |
| `metadata: annotations:`  | `{[ string]: string}` | `unset`           | Common annotations for all resources.                                                                                                                                                                                                    |
| `allowedNamespaces:`      | `[...string]`         | `unset`           | Namespaces allow-listed to use this `VaultAuth`. Use `["*"]` for all namespaces or an explicit list. Unset restricts to the `VaultAuth` namespace.                                                                                     |
| `headers:`                | `{[string]: string}`  | `unset`           | Headers included in all Vault requests.                                                                                                                                                                                                   |
| `audiences:`              | `[...string]`         | `unset`           | Audiences to include in the ServiceAccount token.                                                                                                                                                                                         |
| `role:`                   | `string`              | `unset`           | Vault role to use for authenticating.                                                                                                                                                                                                     |
| `serviceAccount:`         | `string`              | `unset`           | ServiceAccount to use when authenticating to Vault. Must exist in the consuming secret's namespace.                                                                                                                                      |
| `tokenExpirationSeconds:` | `int64`               | `unset`           | ServiceAccount token expiration in seconds (minimum `600`).                                                                                                                                                                               |
| `mount:`                  | `string`              | `"kubernetes"`    | Vault auth mount path.                                                                                                                                                                                                                    |
| `namespace:`              | `string`              | `unset`           | Vault namespace to authenticate against.                                                                                                                                                                                                  |
| `params:`                 | `{[string]: string}`  | `unset`           | Additional parameters for authentication.                                                                                                                                                                                                 |
| `vaultConnectionRef:`     | `string`              | `unset`           | Reference to a `VaultConnection` resource, optionally prefixed with a namespace (for example, `namespace-a/vault-connection`). If unset, the operator defaults to `default` in its namespace.                                           |

#### Recommended values

Typical configuration for a dedicated application namespace:

```cue
values: {
	role:           "app-role"
	serviceAccount: "app-sa"
	audiences:      ["vault"]
	allowedNamespaces: ["apps"]
	vaultConnectionRef: "vault-connection"
}
```
