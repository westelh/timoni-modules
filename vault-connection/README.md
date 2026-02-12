# vault-connection

A [timoni.sh](http://timoni.sh) module for deploying VaultConnection resources to Kubernetes clusters.

## Install

To create an instance using the default values:

```shell
timoni -n default apply vault-connection oci://ghcr.io/westelh/timoni/modules/xxx
```

To change the [default configuration](#configuration),
create one or more `values.cue` files and apply them to the instance.

For example, create a file `my-values.cue` with the following content:

```cue
values: {
	server: {
		address: "https://vault.example.com"
		skipTLSVerify: false
	}
}
```

And apply the values with:

```shell
timoni -n default apply vault-connection oci://ghcr.io/westelh/timoni/modules/xxx \
--values ./my-values.cue
```

## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n default delete vault-connection
```

## Configuration

### General values

| Key                       | Type                  | Default              | Description                                                                       |
|---------------------------|-----------------------|----------------------|-----------------------------------------------------------------------------------|
| `metadata: labels:`       | `{[ string]: string}` | `{}`                 | Common labels for all resources                                                   |
| `metadata: annotations:`  | `{[ string]: string}` | `{}`                 | Common annotations for all resources                                              |
| `server: address:`        | `string`              | `vault.example.com`  | Vault server address                                                              |
| `server: skipTLSVerify:`  | `bool`                | `false`              | Skip TLS verification when connecting to Vault                                    |
| `server: caCertPath:`     | `string`              | `<none>`             | Path to a CA bundle mounted in the controller                                     |
| `server: caCertSecretRef:` | `string`              | `<none>`             | Name of a Kubernetes Secret that contains a `ca.crt` entry                        |
| `server: headers:`        | `{[ string]: string}` | `<none>`             | HTTP headers sent to Vault (e.g., for authentication or routing)                  |
| `server: timeout:`        | `string`              | `<none>`             | Vault client timeout (format depends on the VaultConnection API)                  |
| `server: tlsServerName:`  | `string`              | `<none>`             | Server name override for TLS (SNI)                                                |

#### Recommended values

Set a custom CA bundle and optional headers when connecting to Vault over TLS:

```cue
values: {
	server: {
		address: "https://vault.example.com"
		caCertSecretRef: "vault-ca"
		headers: {
			"X-Vault-Namespace": "platform"
		}
	}
}
```
