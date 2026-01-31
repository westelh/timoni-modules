@if(debug)

package main

// Values used by debug_tool.cue.
// Debug example 'cue cmd -t debug -t name=test -t namespace=test -t mv=1.0.0 -t kv=1.28.0 build'.
values: {
	compartmentId: "ocid.xxxx"
	subnetId: "ocid.xxxx"
	nsgId: "ocid.xxxx"
	loadBalancerName: "oke-lb"
	maxBandwidthMbps: 10
	minBandwidthMbps: 10
	isDefault: true
	definedTags: {
		"Oracle-Standard": Environment: "Staging"
	}
	freeformTags: {}
}
