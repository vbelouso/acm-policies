{{/*
Renders the configMap objects with grafana dashboards required by the chart.
*/}}
{{- define "commonlib.grafanaDashboards" -}}
  {{- /* Generate named configMaps as required */ -}}
  {{- range $name, $gdashboard := .Values.grafanaDashboards }}
    {{- if or $gdashboard.enabled (not (hasKey $gdashboard "enabled")) -}}
      {{- $gdashboardValues := $gdashboard -}}

      {{/* set the default name for the resource */}}
      {{- if not $gdashboardValues.name -}}
        {{- $_ := set $gdashboardValues "name" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "grafanaDashboard" $gdashboardValues) -}}
      {{- include "commonlib.resources.grafanaDashboard" $ }}
    {{- end }}
  {{- end }}
{{- end }}
