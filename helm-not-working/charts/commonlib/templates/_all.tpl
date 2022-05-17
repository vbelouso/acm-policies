{{/*
Main entrypoint for the common library chart. It will render all underlying templates based on the provided values.
*/}}
{{- define "commonlib.all" -}}
  {{- /* Merge the local chart values and the common chart defaults */ -}}
  {{- include "commonlib.values.setup" . }}

  {{- /* Render Grafana Dashboard resources */ -}}
  {{- include "commonlib.grafanaDashboards" . }}

  {{- /* Render PrometheusRules resources */ -}}
  {{- include "commonlib.prometheusRules" . }}

  {{- /* Render Probe resources */ -}}
  {{- include "commonlib.probes" . }}

  {{- /* Render ClusterSecretStore resources */ -}}
  {{- include "commonlib.clusterSecretStores" . }}

  {{- /* Render SecretStore resources */ -}}
  {{- include "commonlib.secretStores" . }}

  {{- /* Render ClusterExternalSecret resources */ -}}
  {{- include "commonlib.clusterExternalSecrets" . }}

  {{- /* Render ExternalSecret resources */ -}}
  {{- include "commonlib.externalSecrets" . }}
{{- end -}}
