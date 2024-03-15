{{- define "horizon.comet.envs" -}}
{{- $customEnv := dict -}}
{{- range $key, $val := .Values.customEnv }}
  {{- $upper := upper (printf "%v_%v" (include "horizon.comet.name" $) $key) -}}
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
- name: HORIZON_LOG_LEVEL
  value: {{ .Values.commonHorizon.horizonLogLevel | quote }}
- name: JAEGER_COLLECTOR_URL
  value: {{ .Values.commonHorizon.tracing.jaegerCollectorBaseUrl | quote }}
- name: ZIPKIN_SAMPLER_PROBABILITY
  value: {{ .Values.commonHorizon.tracing.samplerProbability | quote }}
- name: IRIS_TOKEN_ENDPOINT
  value: {{ .Values.comet.iris.tokenEndpoint | quote }}
- name: IRIS_CLIENT_ID
  value: {{ .Values.comet.iris.clientId | quote }}
- name: IRIS_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "horizon.comet.fullname" . }}
      key: clientSecret
- name: COMET_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: COMET_KAFKA_GROUP_ID
  value: {{ .Values.comet.kafka.consumingGroupId | quote }}
- name: COMET_KAFKA_PARTITION_COUNT
  value: {{ .Values.comet.kafka.consumingPartitionCount | quote }}
- name: COMET_KAFKA_CONSUMER_THREADPOOL_SIZE
  value: {{ .Values.comet.kafka.consumerThreadpoolSize | quote }}
- name: COMET_KAFKA_CONSUMER_QUEUE_CAPACITY
  value: {{ .Values.comet.kafka.consumerQueueCapacity | quote }}
- name: COMET_KAFKA_MAX_POLL_RECORDS
  value: {{ .Values.comet.kafka.maxPollRecords | quote }}
- name: COMET_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: COMET_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: COMET_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: COMET_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: COMET_MAX_TIMEOUT
  value: {{ .Values.comet.callback.maxTimeout | quote }}
- name: COMET_MAX_RETRIES
  value: {{ .Values.comet.callback.maxRetries | quote }}
- name: COMET_INITIAL_BACKOFF_INTERVAL_MS
  value: {{ .Values.comet.callback.initialBackoffIntervalMs | quote }}
- name: COMET_MAX_BACKOFF_INTERVAL_MS
  value: {{ .Values.comet.callback.maxBackoffIntervalMs | quote }}
- name: COMET_BACKOFF_MULTIPLIER
  value: {{ .Values.comet.callback.backoffMultiplier | quote }}
- name: COMET_MAX_CONNECTIONS
  value: {{ .Values.comet.callback.maxConnections | quote }}
- name: COMET_SUCCESSFUL_STATUS_CODES
  value: {{ .Values.comet.callback.successfulStatusCodes | quote }}
- name: COMET_REDELIVERY_STATUS_CODES
  value: {{ .Values.comet.callback.redeliveryStatusCodes | quote }}
- name: COMET_REDELIVERY_THREADPOOL_SIZE
  value: {{ .Values.comet.callback.redeliveryThreadpoolSize | quote }}
- name: COMET_REDELIVERY_QUEUE_CAPACITY
  value: {{ .Values.comet.callback.redeliveryQueueCapacity | quote }}
- name: COMET_RETRIEVE_TOKEN_CONNECT_TIMEOUT
  value: {{ .Values.comet.security.retrieveTokenConnectTimeout | quote }}
- name: COMET_RETRIEVE_TOKEN_READ_TIMEOUT
  value:  {{ .Values.comet.security.retrieveTokenReadTimeout | quote }}
- name: COMET_CACHE_SERVICE_DNS
  value: {{ .Values.comet.cache.serviceDNS | quote }}
- name: COMET_CACHE_DE_DUPLICATION_ENABLED
  value: {{ .Values.comet.cache.deDuplication.enabled | quote }}
- name: COMET_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: PANDORA_TRACING_DEBUG_ENABLED
  value: {{ .Values.commonHorizon.tracing.debugEnabled | quote }}
- name: PANDORA_TRACING_NAME
  value: {{ include "horizon.comet.name" $ | quote }}
{{- template "horizon.renderEnv" $customEnv -}}
{{- end -}}


