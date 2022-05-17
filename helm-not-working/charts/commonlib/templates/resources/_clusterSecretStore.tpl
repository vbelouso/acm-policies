{{/*
This template serves as a blueprint for all ClusterSecretStore objects that are
created within the common library.
*/}}
{{- define "commonlib.resources.clusterSecretStore" -}}
  {{- $resourceName := include "commonlib.fullname" . -}}
  {{- $values := .ObjectValues.clusterSecretStore -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $resourceName = (tpl $values.nameOverride $) -}}
  {{- else if and (hasKey $values "name") $values.name -}}
    {{- $resourceName = printf "%v-%v" $resourceName (tpl $values.name $) -}}
  {{- end }}
---
{{- if .Capabilities.APIVersions.Has "external-secrets.io/v1beta1" }}
apiVersion: external-secrets.io/v1beta1
{{- else }}
apiVersion: external-secrets.io/v1alpha1
{{- end }}
kind: ClusterSecretStore
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
