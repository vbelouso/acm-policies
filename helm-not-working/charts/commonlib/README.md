
# commonlib

![Version: 0.2.3](https://img.shields.io/badge/Version-0.2.3-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

This is a library Helm chart that provides out-of-the-box support for most
commonly used resources across FusionOperate managed Helm charts.

## TL;DR

```shell
cd my-awesome-helm-chart
cat <<EOF >> Chart.yaml
dependencies:
  - name: commonlib
    version: 0.2.3
    repository: https://finastra-engineering.github.io/fusion-operate-charts/
EOF

cat <<EOF > templates/commonlib.yaml
{{ include "commonlib.all" . }}
EOF
```

## Common configuration parameters

List of parameters that are commonly supported across all resource and can be
configured on per resource basis:

* `name` - sets name prefix used to generate resulting resource name.
If not set, it defaults to `Key` name of the respective configuration item. This
parameter can be templated. Required: False

  ```yaml
  externalSecrets:
    example:
      name: example
      ...
  ```

  or

  ```yaml
  externalSecrets:
    example:
      name: {{ .Release.Name }}
      ...
  ```

* `nameOverride` - sets exact name of resulting resource. This parameter can be
templated. Required: False

  ```yaml
  externalSecrets:
    example:
      nameOverride: example
      ...
  ```

  or

  ```yaml
  externalSecrets:
    example:
      nameOverride: {{ .Release.Name }}
      ...
  ```

* `annotations` - annotations map added to resulting resource. Required: False

  ```yaml
  externalSecrets:
    example:
      ...
      annotations:
        owner.fusionoperate.io/team: container-platform
      ...
  ```

* `labels` - labels map added to resulting resource. Required: False

  ```yaml
  externalSecrets:
    example:
      ...
      labels:
        owner.fusionoperate.io/team: container-platform
      ...
  ```

## Supported resources

### External Secrets Operator

Library provides support for External Secret Operator resource types as defined
at [here](https://external-secrets.io/latest/api-overview/#resource-model)

### SecretStore

To create a `SecretStore` resource with helm chart you need to add `secretStores`
map to the `values.yaml` file. See [`values.yaml`](values.yaml) for a full list
of supported parameters.

#### Example

Following code snippet added to `values.yaml` file will create `example`
`SecretStore` resource as part of Helm chart deployment

```yaml
secretStores:
  example:
    spec:
      provider:
        azurekv:
          tenantId: "e17e2402-2a40-42ce-ad75-5848b8d4f6b6"
          vaultUrl: https://pintc010040040201050b001.vault.azure.net/
          authSecretRef:
            clientId:
              name: kubernetes-external-secrets
              key: clientId
            clientSecret:
              name: kubernetes-external-secrets
              key: clientSecret
```

### ClusterSecretStore

To create a `ClusterSecretStore` resource with helm chart you need to add
`clusterSecretStores` map to the `values.yaml` file.See [`values.yaml`](values.yaml)
for a full list of supported parameters.

#### Example

Following code snippet added to `values.yaml` file will create `example`
`ClusterSecretStore` resource as part of Helm chart deployment

```yaml
clusterSecretStores:
  example:
    spec:
      provider:
        azurekv:
          tenantId: "e17e2402-2a40-42ce-ad75-5848b8d4f6b6"
          vaultUrl: https://pintc010040040201050b001.vault.azure.net/
          authSecretRef:
            clientId:
              name: kubernetes-external-secrets
              key: clientId
              namespace: container-platform
            clientSecret:
              name: kubernetes-external-secrets
              key: clientSecret
              namespace: container-platform
```

### ClusterExternalSecret

To create a `ClusterExternalSecret` resource with helm chart you need to add
`clusterExternalSecrets` map to the `values.yaml` file. See [`values.yaml`](values.yaml)
for a full list of supported parameters.

#### Example

Following code snippet added to `values.yaml` file will create `example`
`ExternalSecret` resource as part of Helm chart deployment

```yaml
clusterExternalSecrets:
  example:
    enabled: false
    spec:
      externalSecretName: "example-es"
      namespaceSelector:
        matchLabels:
          cool: label
      refreshInterval: 1h
      externalSecretSpec:
        secretStoreRef:
          kind: SecretStore
          name: default
        target:
          name: example
          creationPolicy: Owner
        data:
          - secretKey: someSecret
            remoteRef:
              key: someSecret
```

### ExternalSecret

To create a `ExternalSecret` resource with helm chart you need to add
`externalSecrets` map to the `values.yaml` file. See [`values.yaml`](values.yaml)
for a full list of supported parameters.

#### Example

Following code snippet added to `values.yaml` file will create `example`
`ExternalSecret` resource as part of Helm chart deployment

```yaml
externalSecrets:
  example:
    spec:
      refreshInterval: 1h
      secretStoreRef:
        kind: SecretStore
        name: default
      target:
        name: example
        creationPolicy: Owner
      data:
        - secretKey: someSecret
          remoteRef:
            key: someSecret
```

### Grafana Dashboards

Once the library is included in the Helm Chart, built-in functions will
automatically search for Grafana dashboard files under the `dashboards/` folder
at the root of the chart's directory. It expects every dashboard to be stored
in a separate `json` file, for example, `dashboards/ingress-nginx-requests.json`.
It is also possible to override dashboard location by using the `filesGlob`
parameter or define 'em inline in the `values.yaml` file with the `data` key.

#### Example - override default folder

```yaml
grafanaDashboards:
  bundled-dashboards:
    labels:
      grafana_dashboard: "1"
    filesGlob: templates/grafana/*.json
```

#### Example - inline dashboard example

```yaml
grafanaDashboards:
  inline-dashboard:
    labels:
      grafana_dashboard: "1"
    data:
      dashboard1.json: |
        {
          "annotations": {
            ...
```

### Prometheus Probes

Library provides support for Prometheus Probes resource types as defined
at [here](https://prometheus-operator.dev/docs/operator/design/#probe).
For a complete set of supported parameters see [values.yaml](values.yaml) file.

#### Example

```yaml
probes:
  example:
    labels:
      prometheus: container-platform-incluster
    spec:
      prober:
        url: prometheus-blackbox-exporter.svc:9115
      module: http_2xx
      targets:
        ingress:
          namespaceSelector:
            any: true
          relabelingConfigs:
            - sourceLabels:
                - __meta_kubernetes_ingress_annotation_kubernetes_io_ingress_class
              action: keep
              regex: .+public$
            - sourceLabels: [__meta_kubernetes_ingress_path]
              action: drop
              regex: /oauth2$
            - sourceLabels: [__meta_kubernetes_namespace]
              action: drop
              regex: .+-tmp[a-zA-Z0-9-]+$
            - sourceLabels:
                - __meta_kubernetes_ingress_scheme
                - __meta_kubernetes_ingress_host
                - __meta_kubernetes_ingress_path
              regex: (.+);(.+);(.+)
              replacement: ${1}://${2}${3}
              targetLabel: __param_target
            - sourceLabels: [__param_target]
              targetLabel: instance
            - action: labelmap
              regex: __meta_kubernetes_ingress_label_(.+)
            - action: labeldrop
              regex: (app_kubernetes_io_|chart|heritage).*
```

### Prometheus Rules

Library provides support for Prometheus Rules resource types as defined
at [here](https://prometheus-operator.dev/docs/operator/design/#prometheusrule).
For a complete set of supported parameters see [values.yaml](values.yaml) file.

#### Example

```yaml
prometheusRules:
  example:
    groups:
      - name: general.rules
        rules:
          - alert: TargetDown
            annotations:
              message: "{{ $value }}% of the {{ $labels.job }} targets are down."
            expr: 100 * (count(up == 0) BY (job) / count(up) BY (job)) > 10
            for: 10m
            labels:
              severity: warning
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterExternalSecrets | object | See below | Configure [ClusterExternalSecret](https://external-secrets.io/v0.5.1/api-clusterexternalsecret/) resources for the chart here. Additional ClusterExternalSecret resources can be added by adding a dictionary key similar to the 'example' object. |
| clusterExternalSecrets.example.annotations | object | `{}` | Annotations to add to a dashboard configmap |
| clusterExternalSecrets.example.enabled | bool | `false` | Enables or disables rule deployment. Default: true |
| clusterExternalSecrets.example.labels | object | `{}` | Labels to add to the dashboard configmap |
| clusterExternalSecrets.example.spec | object | See `values.yaml` file for example | ExternalSecrets resource spec |
| clusterSecretStores | object | See below | Configure [ClusterSecretStore](https://external-secrets.io/v0.5.1/api-clustersecretstore/) resources for the chart here. Additional ClusterSecretStore resources can be added by adding a dictionary key similar to the 'example' object. |
| clusterSecretStores.example.annotations | object | `{}` | Annotations to add to the clusterSecretStore resource |
| clusterSecretStores.example.enabled | bool | `false` | Enables or disables rule deployment. Default: true |
| clusterSecretStores.example.labels | object | `{}` | Labels to add to the clusterSecretStore resource |
| clusterSecretStores.example.spec | object | See `values.yaml` file for example | ClusterSecretStore resource spec as defined [here](https://external-secrets.io/latest/api-clustersecretstore/) |
| externalSecrets | object | See below | Configure [ExternalSecret](https://external-secrets.io/v0.5.1/api-externalsecret/) resources for the chart here. Additional ExternalSecret resources can be added by adding a dictionary key similar to the 'example' object. |
| externalSecrets.example.annotations | object | `{}` | Annotations to add to a dashboard configmap |
| externalSecrets.example.enabled | bool | `false` | Enables or disables rule deployment. Default: true |
| externalSecrets.example.labels | object | `{}` | Labels to add to the dashboard configmap |
| externalSecrets.example.spec | object | See `values.yaml` file for example | ExternalSecrets resource spec |
| grafanaDashboards | object | See below | Configure Grafana Dashboards for the chart here. Additional dashboards can be added by adding a dictionary key similar to the 'bundled-dashboards' object. |
| grafanaDashboards.bundled-dashboards.annotations | object | `{}` | Annotations to add to a dashboard configmap |
| grafanaDashboards.bundled-dashboards.data | object | `{}` | Inline dashboards |
| grafanaDashboards.bundled-dashboards.enabled | bool | `true` | Enables or disables dashboards deployment. Default: true |
| grafanaDashboards.bundled-dashboards.filesGlob | string | `"dashboards/*.json"` | Glob to search for dashboards |
| grafanaDashboards.bundled-dashboards.labels | object | `{"grafana_dashboard":"1"}` | Labels to add to the dashboard configmap |
| probes | object | See below | Configure Prometheus Probes for the chart here. Additional probe resources can be added by adding a dictionary key similar to the 'example' object. |
| probes.example.annotations | object | `{}` | Annotations to add to a probe resource |
| probes.example.enabled | bool | `false` | Enables or disables rule deployment. Default: true |
| probes.example.labels | object | `{}` | Labels to add to the probe resource |
| probes.example.spec | object | See `values.yaml` file for example | Probe resource spec as defined [here](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/crds/crd-probes.yaml) |
| prometheusRules | object | See below | Configure Prometheus Rules for the chart here. Additional prometheus rules can be added by adding a dictionary key similar to the 'example' object. |
| prometheusRules.example.annotations | object | `{}` | Annotations to add to a Prometheus rule |
| prometheusRules.example.enabled | bool | `false` | Enables or disables rule deployment. Default: true |
| prometheusRules.example.groups | list | See `values.yaml` file for example | Content of Prometheus rule file |
| prometheusRules.example.labels | object | `{}` | Labels to add to the Prometheus rule |
| secretStores | object | See below | Configure [SecretStore](https://external-secrets.io/v0.5.1/api-secretstore/) resources for the chart here. Additional SecretStore resources can be added by adding a dictionary key similar to the 'example' object. |
| secretStores.example.annotations | object | `{}` | Annotations to add to a dashboard configmap |
| secretStores.example.enabled | bool | `false` | Enables or disables rule deployment. Default: true |
| secretStores.example.labels | object | `{}` | Labels to add to the dashboard configmap |
| secretStores.example.spec | object | See `values.yaml` file for example | SecretStore resource spec as defined [here](https://external-secrets.io/latest/api-secretstore/) |
<!-- markdownlint-disable MD012 -->

<!-- markdownlint-enable MD012 -->
