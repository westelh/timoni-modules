@if(debug)

package main

// Values used by debug_tool.cue.
// Debug example 'cue cmd -t debug -t name=test -t namespace=test -t mv=1.0.0 -t kv=1.28.0 build'.
values: {
	spec: {
		acme: {
			email:  "user@example.com"
			server: "https://acme-staging-v02.api.letsencrypt.org/directory"
			privateKeySecretRef: {
				name: "example-issuer-account-key"
			}
			solvers: [
				{
					http01: {
						ingress: {
							ingressClassName: "nginx"
						}
					}
				},
			]
		}
	}
}
