{{- define "horizon.vortex.labels" -}}
app: {{ .Release.Name }}-vortex
app.kubernetes.io/name: horizon-vortex
app.kubernetes.io/instance: {{ .Release.Name }}-vortex-app
app.kubernetes.io/component: vortex
app.kubernetes.io/part-of: horizon
{{- end -}}

{{- define "horizon.vortex.selector" -}}
app.kubernetes.io/instance: {{ .Release.Name }}-vortex-app
{{- end -}}

{{- define "horizon.vortex.volumes" -}}
- name: tmp
  emptyDir: {}
{{- end -}}

{{- define "horizon.vortex.image" -}}
{{- $imageName := "vortex" -}}
{{- $imageTag := "develop" -}}
{{- $imageRepository := "example.devops.company.de" -}}
{{- $imageOrganization := "internal/example/horizon" -}}
{{- if .Values.image -}}
  {{- if not (kindIs "string" .Values.image) -}}
    {{ $imageRepository = .Values.image.repository | default $imageRepository -}}
    {{ $imageOrganization = .Values.image.organization | default $imageOrganization -}}
    {{ $imageName = .Values.image.name | default $imageName -}}
    {{ $imageTag = .Values.image.tag | default $imageTag -}}
    {{- printf "%s/%s/%s:%s" $imageRepository $imageOrganization $imageName $imageTag -}}
  {{- else -}}
    {{- .Values.image -}}
  {{- end -}}
{{- else -}}
 {{- printf "%s/%s/%s:%s" $imageRepository $imageOrganization $imageName $imageTag -}}
{{- end -}}
{{- end -}}

{{- define "horizon.vortex.envs" -}}
- name: {{ .Values.image.name | upper}}_LOGLEVEL
  value: {{ .Values.logLevel | quote }}
- name: {{ .Values.image.name | upper}}_KAFKA_BROKERS
  value: {{ .Values.kafka.broker | quote }}
- name: {{ .Values.image.name | upper}}_KAFKA_GROUPNAME
  value: {{ .Values.kafka.groupname | quote }}
- name: {{ .Values.image.name | upper}}_KAFKA_TOPICS
  value: {{ join "," .Values.kafka.topics }}
- name: {{ .Values.image.name | upper}}_KAFKA_SESSIONTIMEOUTSEC
  value: {{ .Values.kafka.sessionTimeoutSec | quote }}
- name: {{ .Values.image.name | upper}}_MONGO_URL
  valueFrom:
    secretKeyRef:
        name: {{ .Release.Name }}-vortex
        key: mongoUrl
- name: {{ .Values.image.name | upper}}_MONGO_DATABASE
  value: {{ .Values.mongo.database | quote }}
- name: {{ .Values.image.name | upper}}_MONGO_COLLECTION
  value: {{ .Values.mongo.collection | quote }}
- name: {{ .Values.image.name | upper}}_MONGO_BULKSIZE
  value: {{ .Values.mongo.bulkSize | quote }}
- name: {{ .Values.image.name | upper}}_MONGO_FLUSHINTERVALSEC
  value: {{ .Values.mongo.flushIntervalSec | quote }}
{{- if .Values.metrics.enabled }}
- name: {{ .Values.image.name | upper}}_METRICS_ENABLED
  value: {{ .Values.metrics.enabled | quote }}
- name: {{ .Values.image.name | upper}}_METRICS_PORT
  value: {{ .Values.metrics.port | quote }}
{{- end }}
{{- end -}}