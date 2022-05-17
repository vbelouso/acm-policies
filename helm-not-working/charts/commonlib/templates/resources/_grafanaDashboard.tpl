{{/*
This template serves as a blueprint for all GrafanaDashboard objects that are
created within the common library.
*/}}
{{- define "commonlib.resources.grafanaDashboard" -}}
  {{- $resourceName := include "commonlib.fullname" . -}}
  {{- $values := .ObjectValues.grafanaDashboard -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $resourceName = (tpl $values.nameOverride $) -}}
  {{- else if and (hasKey $values "name") $values.name -}}
    {{- $resourceName = printf "%v-%v" $resourceName (tpl $values.name $) -}}
  {{- end }}

  {{- $sourceFromFiles := false -}}
  {{- if hasKey $values "filesGlob" -}}
    {{- if gt (len (.Files.Glob $values.filesGlob)) 0 -}}
      {{- $sourceFromFiles = true -}}
    {{- end }}
  {{- end }}

  {{- if or $sourceFromFiles $values.data }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $resourceName }}
  {{- with $values.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "commonlib.labels" . | nindent 4 }}
    {{- with $values.labels }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
data:
  {{- if $sourceFromFiles }}
    {{- (.Files.Glob $values.filesGlob).AsConfig | nindent 2 }}
  {{- end }}
  {{- with $values.data }}
    {{- tpl (toYaml .) $ | nindent 2 }}
  {{- end }}
  {{- end }}
{{- end }}
