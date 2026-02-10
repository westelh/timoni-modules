@if(debug)

package main

values: {
	production:    false
	email:         "debug@example.com"
	clusterIssuer: true
	solvers: [{
		dns01: {
			cloudDNS: {
				project: ""
				serviceAccountSecretRef: {
					name: ""
					key:  ""
				}
			}
		}
	}]
}
