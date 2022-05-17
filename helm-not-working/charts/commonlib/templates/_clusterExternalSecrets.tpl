{{/*
Renders the clusterExternalSecret objects required by the chart.
*/}}
{{- define "commonlib.clusterExternalSecrets" -}}
  {{- /* Generate named ExternalSecrets as required */ -}}
  {{- range $name, $clusterExternalSecret := .Values.clusterExternalSecrets }}
    {{- if or $clusterExternalSecret.enabled (not (hasKey $clusterExternalSecret "enabled")) -}}
      {{- $clusterExternalSecretValues := $clusterExternalSecret -}}

      {{/* set the default name for the resource */}}
      {{- if not $clusterExternalSecretValues.name -}}
        {{- $_ := set $clusterExternalSecretValues "name" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "clusterExternalSecret" $clusterExternalSecretValues) -}}
      {{- include "commonlib.resources.clusterExternalSecret" $ }}
    {{- end }}
  {{- end }}
{{- end }}
