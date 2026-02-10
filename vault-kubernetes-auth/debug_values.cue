@if(debug)

package main

// Values used by debug_tool.cue.
// Debug example 'cue cmd -t debug -t name=test -t namespace=test -t mv=1.0.0 -t kv=1.28.0 build'.
values: {
	role:           "app-role"
	serviceAccount: "app-sa"
	audiences:      ["vault"]
	allowedNamespaces: [
		"apps",
	]
	vaultConnectionRef: "vault-connection"
}
