{{- define "horizon.pulsar.envs" -}}
{{- $envPrefix := upper (include "horizon.pulsar.name" $) -}}
{{- $customEnv := dict -}}
{{- range $key, $val := .Values.customEnv }}
  {{- $upper := upper (printf "%v_%v" (include "horizon.pulsar.name" $) $key) -}}
  {{- $_ := set $customEnv $upper $val -}}
{{- end -}}
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
    --add-modules=java.se
    --add-exports=java.base/jdk.internal.ref=ALL-UNNAMED
    --add-opens=java.base/java.lang=ALL-UNNAMED
    --add-opens=java.management/sun.management=ALL-UNNAMED
    --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED
{{- else }}
  value: >-
    -XX:MaxRAMPercentage=75.0
    --add-opens=java.base/java.nio=ALL-UNNAMED
    --add-opens=java.base/sun.nio.ch=ALL-UNNAMED
    --add-opens=java.base/sun.nio.cs=ALL-UNNAMED
    --add-modules=java.se
    --add-exports=java.base/jdk.internal.ref=ALL-UNNAMED
    --add-opens=java.base/java.lang=ALL-UNNAMED
    --add-opens=java.management/sun.management=ALL-UNNAMED
    --add-opens=jdk.management/com.sun.management.internal=ALL-UNNAMED
{{- end }}
- name: SPRING_PROFILES_ACTIVE
  value: "prod"
- name: LOG_LEVEL
  value: {{ .Values.commonHorizon.logLevel | quote }}
- name: JAEGER_COLLECTOR_URL
  value: {{ .Values.commonHorizon.tracing.jaegerCollectorBaseUrl | quote }}
- name: ZIPKIN_SAMPLER_PROBABILITY
  value: {{ .Values.commonHorizon.tracing.samplerProbability | quote }}
- name: HORIZON_LOG_LEVEL
  value: {{ .Values.commonHorizon.horizonLogLevel | quote }}
- name: HORIZON_MONGO_CLIENTID
  value: {{ .Values.pulsar.mongo.clientId | quote }}
- name: HORIZON_MONGO_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "horizon.pulsar.fullname" . }}
      key: mongoUrl
- name: PULSAR_ISSUER_URL
  value: {{ .Values.commonHorizon.issuerUrl | quote }}
- name: PULSAR_DEFAULT_ENVIRONMENT
  value: {{ .Values.commonHorizon.defaultEnvironment | quote }}
- name: PULSAR_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: PULSAR_KAFKA_GROUP_ID
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
- name: PULSAR_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: PULSAR_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: PULSAR_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: PULSAR_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: PULSAR_FEATURE_SUBSCRIBER_CHECK
  value: {{ .Values.pulsar.features.subscriberCheck | quote }}
- name: PULSAR_SSE_POLL_DELAY
  value: {{ .Values.pulsar.ssePollDelay | quote }}
- name: PULSAR_SSE_TIMEOUT
  value: {{ .Values.pulsar.sseTimeout | quote }}
- name: PULSAR_SSE_BATCH_SIZE
  value: {{ .Values.pulsar.sseBatchSize | quote }}
- name: PULSAR_THREADPOOL_SIZE
  value: {{ .Values.pulsar.threadPoolSize | quote }}
- name: PULSAR_QUEUE_CAPACITY
  value: {{ .Values.pulsar.queueCapacity | quote }}
- name: PULSAR_SECURITY_OAUTH
  value: {{ .Values.pulsar.oauthEnabled | default true | toString | quote }}
- name: PULSAR_CACHE_DE_DUPLICATION_ENABLED
  value: {{ .Values.pulsar.cache.deDuplication.enabled | quote }}
- name: PULSAR_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: PANDORA_TRACING_DEBUG_ENABLED
  value: {{ .Values.commonHorizon.tracing.debugEnabled | quote }}
- name: PANDORA_TRACING_NAME
  value: {{ include "horizon.pulsar.name" $ | quote }}
{{- template "horizon.renderEnv" $customEnv -}}
{{- end -}}


