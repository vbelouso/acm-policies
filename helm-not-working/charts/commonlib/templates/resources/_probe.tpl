{{/*
This template serves as a blueprint for all Probe objects that are
created within the common library.
*/}}
{{- define "commonlib.resources.probe" -}}
  {{- $resourceName := include "commonlib.fullname" . -}}
  {{- $values := .ObjectValues.probe -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $resourceName = (tpl $values.nameOverride $) -}}
  {{- else if and (hasKey $values "name") $values.name -}}
    {{- $resourceName = printf "%v-%v" $resourceName (tpl $values.name $) -}}
  {{- end }}
---
apiVersion: monitoring.coreos.com/v1
kind: Probe
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
spec:
  {{- with $values.spec }}
    {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end }}
