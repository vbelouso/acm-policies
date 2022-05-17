{{/*
Common labels
*/}}
{{- define "commonlib.labels" -}}
helm.sh/chart: {{ include "commonlib.chart" . }}
{{ include "commonlib.selectorLabels" . }}
  {{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  {{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "commonlib.selectorLabels" -}}
app.kubernetes.io/name: {{ include "commonlib.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
