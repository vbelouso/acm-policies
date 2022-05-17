{{/*
Renders the clusterSecretStore objects required by the chart.
*/}}
{{- define "commonlib.clusterSecretStores" -}}
  {{- /* Generate named clusterSecretStores as required */ -}}
  {{- range $name, $clusterSecretStore := .Values.clusterSecretStores }}
    {{- if or $clusterSecretStore.enabled (not (hasKey $clusterSecretStore "enabled")) -}}
      {{- $clusterSecretStoreValues := $clusterSecretStore -}}

      {{/* set the default name for the resource */}}
      {{- if not $clusterSecretStoreValues.name -}}
        {{- $_ := set $clusterSecretStoreValues "name" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "clusterSecretStore" $clusterSecretStoreValues) -}}
      {{- include "commonlib.resources.clusterSecretStore" $ }}
    {{- end }}
  {{- end }}
{{- end }}
