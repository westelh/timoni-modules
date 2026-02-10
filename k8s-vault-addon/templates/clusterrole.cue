package templates

import (
	rbacv1 "k8s.io/api/rbac/v1"
)

#GetNamespaces: rbacv1.#PolicyRule & {
	apiGroups: [""]
	resources: ["namespaces"]
	verbs: ["get"]
}

#ManageServiceaccounts : rbacv1.#PolicyRule & {
	apiGroups: [""]
	resources: ["serviceaccounts", "serviceaccounts/token"]
	verbs: ["create", "update", "delete"]
}

#ManageBindings: rbacv1.#PolicyRule & {
	apiGroups: ["rbac.authorization.k8s.io"]
	resources: ["rolebindings", "clusterrolebindings"]
	verbs: ["create", "update", "delete"]
}

#ManageRoles: rbacv1.#PolicyRule & {
	apiGroups: ["rbac.authorization.k8s.io"]
	resources: ["roles", "clusterroles"]
	verbs: ["bind", "escalate", "create", "update", "delete"]
}

#ClusterRole: rbacv1.#ClusterRole & {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind: "ClusterRole"
	#config: #Config
	metadata: {
		name: "k8s-vault-addon-\(#config.metadata.name)"
		labels:    #config.metadata.labels
		if #config.metadata.annotations != _|_ {
			annotations: #config.metadata.annotations
		}
	}
	rules: [
		#GetNamespaces,
		#ManageServiceaccounts,
		#ManageBindings,
		#ManageRoles,
	]
}
