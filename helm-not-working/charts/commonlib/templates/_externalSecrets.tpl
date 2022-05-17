{{/*
Renders the externalSecret objects required by the chart.
*/}}
{{- define "commonlib.externalSecrets" -}}
  {{- /* Generate named ExternalSecrets as required */ -}}
  {{- range $name, $externalSecret := .Values.externalSecrets }}
    {{- if or $externalSecret.enabled (not (hasKey $externalSecret "enabled")) -}}
      {{- $externalSecretValues := $externalSecret -}}

      {{/* set the default name for the resource */}}
      {{- if not $externalSecretValues.name -}}
        {{- $_ := set $externalSecretValues "name" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "externalSecret" $externalSecretValues) -}}
      {{- include "commonlib.resources.externalSecret" $ }}
    {{- end }}
  {{- end }}
{{- end }}
