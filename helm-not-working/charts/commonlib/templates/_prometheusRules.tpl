{{/*
Renders the prometheusRules objects required by the chart.
*/}}
{{- define "commonlib.prometheusRules" -}}
  {{- /* Generate named prometheusRules as required */ -}}
  {{- range $name, $prometheusRule := .Values.prometheusRules }}
    {{- if or $prometheusRule.enabled (not (hasKey $prometheusRule "enabled")) -}}
      {{- $prometheusRuleValues := $prometheusRule -}}

      {{/* set the default name for the resource */}}
      {{- if not $prometheusRuleValues.name -}}
        {{- $_ := set $prometheusRuleValues "name" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "prometheusRule" $prometheusRuleValues) -}}
      {{- include "commonlib.resources.prometheusRule" $ }}
    {{- end }}
  {{- end }}
{{- end }}
