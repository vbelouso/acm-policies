{{/*
Renders the secretStore objects required by the chart.
*/}}
{{- define "commonlib.secretStores" -}}
  {{- /* Generate named secretStores as required */ -}}
  {{- range $name, $secretStore := .Values.secretStores }}
    {{- if or $secretStore.enabled (not (hasKey $secretStore "enabled")) -}}
      {{- $secretStoreValues := $secretStore -}}

      {{/* set the default name for the resource */}}
      {{- if not $secretStoreValues.name -}}
        {{- $_ := set $secretStoreValues "name" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "secretStore" $secretStoreValues) -}}
      {{- include "commonlib.resources.secretStore" $ }}
    {{- end }}
  {{- end }}
{{- end }}
