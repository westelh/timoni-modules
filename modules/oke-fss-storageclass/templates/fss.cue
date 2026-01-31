package templates

import (
	"encoding/json"
	storagev1 "k8s.io/api/storage/v1"
)

#Fss: storagev1.#StorageClass & {
	#config: #Config
	apiVersion: "storage.k8s.io/v1"
	kind: "StorageClass"
	metadata: #config.metadata
	provisioner: "fss.csi.oraclecloud.com"
	parameters: {
		availabilityDomain: #config.adName
		mountTargetOcid: #config.mountTargetOcid
		compartmentOcid: #config.compartmentOcid
		if #config.encryptInTransit {
			encryptInTransit: "true"
		}
		if !#config.encryptInTransit {
			encryptInTransit: "false"
		}
		if #config.kmsKeyOcid != _|_ {
			kmsKeyOcid: #config.kmsKeyOcid
		}
		if #config.exportPath != _|_ {
			exportPath: #config.exportPath
		}
		if #config.exportOptions != _|_ {
			exportOptions: #config.exportOptions
		}
		"oci.oraclecloud.com/initial-defined-tags-override": json.Marshal(#config.definedTags)
		"oci.oraclecloud.com/initial-freeform-tags-override": json.Marshal(#config.freeformTags)
	}
	reclaimPolicy: #config.reclaimPolicy
	allowVolumeExpansion: #config.allowVolumeExpansion
}
