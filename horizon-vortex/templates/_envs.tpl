{{- define "horizon.vortex.envs" -}}
{{- $customEnv := dict -}}
{{- range $key, $val := .Values.customEnv }}
  {{- $upper := upper (printf "%v_%v" (include "horizon.vortex.name" $) $key) -}}
  {{- $_ := set $customEnv $upper $val -}}
{{- end -}}
- name: VORTEX_LOGLEVEL
  value: {{ .Values.logLevel | quote }}
- name: VORTEX_KAFKA_BROKERS
  value: {{ .Values.kafka.broker | quote }}
- name: VORTEX_KAFKA_GROUPNAME
  value: {{ .Values.kafka.groupname | quote }}
- name: VORTEX_KAFKA_TOPICS
  value: {{ join "," .Values.kafka.topics }}
- name: VORTEX_KAFKA_SESSIONTIMEOUTSEC
  value: {{ .Values.kafka.sessionTimeoutSec | quote }}
- name: VORTEX_MONGO_URL
  valueFrom:
    secretKeyRef:
        name: {{ include "horizon.vortex.fullname" . }}
        key: mongoUrl
- name: VORTEX_MONGO_DATABASE
  value: {{ .Values.mongo.database | quote }}
- name: VORTEX_MONGO_COLLECTION
  value: {{ .Values.mongo.collection | quote }}
- name: VORTEX_MONGO_BULKSIZE
  value: {{ .Values.mongo.bulkSize | quote }}
- name: VORTEX_MONGO_FLUSHINTERVALSEC
  value: {{ .Values.mongo.flushIntervalSec | quote }}
{{- if .Values.metrics.enabled }}
- name: VORTEX_METRICS_ENABLED
  value: {{ .Values.metrics.enabled | quote }}
- name: VORTEX_METRICS_PORT
  value: {{ .Values.metrics.port | quote }}
{{- end }}
{{- template "horizon.renderEnv" $customEnv -}}
{{- end -}}


