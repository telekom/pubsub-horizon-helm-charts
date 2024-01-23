{{- define "common.statusmonitor.labels" -}}
developer.telekom.de/cluster: {{ .Values.common.cluster | default "default" | quote }}
developer.telekom.de/namespace: {{ .Release.Namespace | default "undefined" | quote }}
developer.telekom.de/product: {{ .Values.common.product | default .Chart.Name | quote }}
developer.telekom.de/subproduct: {{ .Values.common.subProduct | default .Release.Name | quote }}
developer.telekom.de/team: {{ .Values.common.team | default "default" | quote }}
developer.telekom.de/environment: {{ .Values.common.metadata.environment | default "default" | quote }}
developer.telekom.de/expose-on-statuspage: 'true'
{{- end -}}

