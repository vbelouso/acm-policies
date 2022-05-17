{{/*
Renders the probe objects required by the chart.
*/}}
{{- define "commonlib.probes" -}}
  {{- /* Generate named probes as required */ -}}
  {{- range $name, $probe := .Values.probes }}
    {{- if or $probe.enabled (not (hasKey $probe "enabled")) -}}
      {{- $probeValues := $probe -}}

      {{/* set the default name for the resource */}}
      {{- if not $probeValues.name -}}
        {{- $_ := set $probeValues "name" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "probe" $probeValues) -}}
      {{- include "commonlib.resources.probe" $ }}
    {{- end }}
  {{- end }}
{{- end }}
