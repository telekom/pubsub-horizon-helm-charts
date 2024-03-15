{{- define "horizon.galaxy.envs" -}}
{{- $customEnv := dict -}}
{{- range $key, $val := .Values.customEnv }}
  {{- $upper := upper (printf "%v_%v" (include "horizon.galaxy.name" $) $key) -}}
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
- name: GALAXY_DEFAULT_ENVIRONMENT
  value: {{ .Values.commonHorizon.defaultEnvironment | quote }}
- name: GALAXY_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: GALAXY_KAFKA_CONSUMING_TOPIC
  value: {{ .Values.galaxy.kafka.consumingTopic | quote }}
- name: GALAXY_KAFKA_GROUP_ID
  value: {{ .Values.galaxy.kafka.consumingGroupId | quote }}
- name: GALAXY_KAFKA_PARTITION_COUNT
  value: {{ .Values.galaxy.kafka.consumingPartitionCount | quote }}
- name: GALAXY_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: GALAXY_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: GALAXY_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: GALAXY_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: GALAXY_CORE_THREADPOOL_SIZE
  value: {{ .Values.galaxy.coreThreadpoolSize | quote }}
- name: GALAXY_MAX_THREADPOOL_SIZE
  value: {{ .Values.galaxy.maxThreadpoolSize | quote }}
- name: GALAXY_MAX_TIMEOUT
  value: {{ .Values.galaxy.maxTimeout | quote }}
- name: GALAXY_MAX_RETRIES
  value: {{ .Values.galaxy.maxRetries | quote }}
- name: GALAXY_INITIAL_BACKOFF_INTERVAL
  value: {{ .Values.galaxy.initialBackoffInterval | quote }}
- name: GALAXY_MAX_BACKOFF_INTERVAL
  value: {{ .Values.galaxy.maxBackoffInterval | quote }}
- name: GALAXY_BACKOFF_MULTIPLIER
  value: {{ .Values.galaxy.backoffMultiplier | quote }}
- name: GALAXY_REPROCESSING_ENABLED
  value: {{ .Values.galaxy.reprocessing.enabled | quote }}
- name: GALAXY_MAX_REPROCESS_RETRIES
  value: {{ .Values.galaxy.reprocessing.maxRetries| quote }}
- name: GALAXY_MAX_UNBRIDGED_MESSAGE_AGE
  value: {{ .Values.galaxy.reprocessing.maxUnbridgedMessageAgeMs | quote }}
- name: GALAXY_REPROCESS_INTERVAL
  value: {{ .Values.galaxy.reprocessing.reprocessIntervalMs | quote }}
- name: GALAXY_CACHE_SERVICE_DNS
  value: {{ .Values.galaxy.cache.serviceDns }}
- name: GALAXY_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: PANDORA_TRACING_DEBUG_ENABLED
  value: {{ .Values.commonHorizon.tracing.debugEnabled | quote }}
- name: PANDORA_TRACING_NAME
  value: {{ include "horizon.galaxy.name" $ | quote }}
{{- template "horizon.renderEnv" $customEnv -}}
{{- end -}}


