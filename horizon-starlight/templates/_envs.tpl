{{- define "horizon.starlight.envs" -}}
{{- $envPrefix := upper (include "horizon.starlight.name" $) -}}
{{- $customEnv := dict -}}
{{- range $key, $val := .Values.customEnv }}
  {{- $upper := upper (printf "%v_%v" (include "horizon.starlight.name" $) $key) -}}
  {{- $_ := set $customEnv $upper $val -}}
{{- end -}}
- name: SPRING_PROFILES_ACTIVE
  value: "prod"
- name: LOG_LEVEL
  value: {{ .Values.commonHorizon.logLevel | quote }}
- name: JAVA_TOOL_OPTIONS
{{- if eq (toString .Values.commonHorizon.jmxRemote.enabled) "true" }}
  value: >-
    -XX:MaxRAMPercentage=75.0
    -Dcom.sun.management.jmxremote
    -Dcom.sun.management.jmxremote.authenticate=false
    -Dcom.sun.management.jmxremote.ssl=false
    -Dcom.sun.management.jmxremote.local.only=false
    -Dcom.sun.management.jmxremote.port=9010
    -Dcom.sun.management.jmxremote.rmi.port=9010
    -Djava.rmi.server.hostname=127.0.0.1
    --add-opens=java.base/java.nio=ALL-UNNAMED
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED
    --add-opens=java.base/sun.nio.cs=ALL-UNNAMED
{{- else }}
  value: >-
    -XX:MaxRAMPercentage=75.0
    --add-opens=java.base/java.nio=ALL-UNNAMED
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED
    --add-opens=java.base/sun.nio.cs=ALL-UNNAMED
{{- end }}
- name: {{ $envPrefix }}_ISSUER_URL
  value: {{ .Values.commonHorizon.issuerUrl | quote }}
- name: {{ $envPrefix }}_DEFAULT_ENVIRONMENT
  value: {{ .Values.commonHorizon.defaultEnvironment | quote }}
- name: {{ $envPrefix }}_PUBLISHING_TIMEOUT_MS
  value: {{ .Values.commonHorizon.publishingTimeoutMs | quote }}
- name: {{ $envPrefix }}_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: {{ $envPrefix }}_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: {{ $envPrefix }}_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: {{ $envPrefix }}_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: {{ $envPrefix }}_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: {{ $envPrefix }}_FEATURE_PUBLISHER_CHECK
  value: {{ .Values.starlight.features.publisherCheck | quote }}
- name: {{ $envPrefix }}_FEATURE_SCHEMA_VALIDATION
  value: {{ .Values.starlight.features.schemaValidation | quote }}
- name: {{ $envPrefix }}_KAFKA_TRANSACTION_PREFIX
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
- name: {{ $envPrefix }}_KAFKA_GROUP_ID
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
{{- if .Values.starlight.features.customPublishingTopics }}
- name: {{ $envPrefix }}_CUSTOM_PUBLISHING_TOPICS
  value: |
    {{- toYaml .Values.starlight.features.customPublishingTopics | nindent 4 }}
{{- end }}
- name: IRIS_ISSUER_URL
  value: {{ .Values.starlight.eniapi.issuerUrl | toString | quote }}
- name: CLIENT_ID
  valueFrom:
    secretKeyRef:
      name: {{ include "horizon.starlight.fullname" . }}
      key: eniApiClientId
- name: CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "horizon.starlight.fullname" . }}
      key: eniApiClientSecret
- name: ENIAPI_BASEURL
  value: {{ .Values.starlight.eniapi.baseurl | toString | quote }}
- name: {{ $envPrefix }}_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: JAEGER_COLLECTOR_URL
  value: {{ .Values.commonHorizon.tracing.jaegerCollectorBaseUrl | quote }}
- name: ZIPKIN_SAMPLER_PROBABILITY
  value: {{ .Values.commonHorizon.tracing.samplerProbability | quote }}
{{- template "horizon.renderEnv" $customEnv -}}
{{- end -}}


