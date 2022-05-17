{{/*
This template serves as a blueprint for all ClusterExternalSecret objects that
are created within the common library.
*/}}
{{- define "commonlib.resources.clusterExternalSecret" -}}
  {{- $resourceName := include "commonlib.fullname" . -}}
  {{- $values := .ObjectValues.clusterExternalSecret -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $resourceName = (tpl $values.nameOverride $) -}}
  {{- else if and (hasKey $values "name") $values.name -}}
    {{- $resourceName = printf "%v-%v" $resourceName (tpl $values.name $) -}}
  {{- end }}

  {{/* Allow templating of secretStoreRef.name value */}}
  {{- if and (hasKey $values "spec") (hasKey $values.spec "externalSecretSpec") -}}
    {{- if and (hasKey $values.spec.externalSecretSpec "secretStoreRef") (hasKey $values.spec.externalSecretSpec.secretStoreRef "name") -}}
      {{- if $values.spec.externalSecretSpec.secretStoreRef.name -}}
        {{- $_ := set $values.spec.externalSecretSpec.secretStoreRef "name" (tpl $values.spec.externalSecretSpec.secretStoreRef.name $) -}}
      {{- end }}
    {{- end }}
  {{- end }}
---
apiVersion: external-secrets.io/v1beta1
kind: ClusterExternalSecret
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
