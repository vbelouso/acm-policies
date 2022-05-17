
{{/* Merge the local chart values and the commonlib chart defaults */}}
{{- define "commonlib.values.setup" -}}
    {{- if .Values.commonlib -}}
        {{- $defaultValues := deepCopy .Values.commonlib -}}
        {{- $userValues := deepCopy (omit .Values "commonlib") -}}
        {{- $mergedValues := mustMergeOverwrite $defaultValues $userValues -}}
        {{- $_ := set . "Values" (deepCopy $mergedValues) -}}
    {{- end -}}
{{- end -}}
