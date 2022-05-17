# default-network-policy

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Network policies managed by ACM Governance.

<!-- markdownlint-disable MD034 -->
## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://finastra-engineering.github.io/fusion-operate-charts | commonlib | 0.2.2 |
<!-- markdownlint-enable MD034 -->

## TL;DR

```console
helm repo add finastra-engineering https://finastra-engineering.github.io/fusion-operate-charts/
helm repo update
helm install default-network-policy finastra-engineering/default-network-policy
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| complianceType | string | `"musthave"` | Expected behavior that be evaluated or applied to the managed clusters. The parameter values are mustonlyhave, musthave, mustnothave. |
| configurationPolicyName | string | `"default-network-policy-cfg"` | Configuration policy resource name. |
| disable | bool | `false` | Enable or disable policy. |
| namespaceSelector.exclude | list | `["kube-*","openshift*","open-cluster-management*"]` | Explicitly specified namespace(s) to which the policy will not apply. |
| namespaceSelector.include | list | `["*"]` | Explicitly specified namespace(s) to which the policy will apply. |
| remediationAction | string | `"inform"` | The remediation of the policy. The parameter values are enforce or inform. |
| severity | string | `"high"` | Define the severity when the policy is non-compliant. The parameter values are low, medium or high. |
<!-- markdownlint-disable MD012 -->

<!-- markdownlint-enable MD012 -->
## Description

This chart deploys default network policies for OpenShift clusters using ACM Governance.

There are two network policies applied to the managed cluster:

1. `deny-all` blocking network traffic between namespaces.
2. `allow-same-namespace` allowing all network traffic inside namespace.

By default network policies not applied to `kube-*`, `openshift*`, `open-cluster-management*` namespaces.

The default policy action is to `enforce` to detect existing misconfigurations and fix it.

The correctness of the policy can be checked in the `Governance` menu of the ACM console.

## Usage

In general, this Helm chart doesn't require any extra settings:

```shell
helm upgrade --install --create-namespace --namespace container-platform network-policies finastra-engineering/network-policies
```
