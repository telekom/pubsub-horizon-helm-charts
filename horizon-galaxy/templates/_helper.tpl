{{- define "horizon.galaxy.labels" -}}
app: {{ .Release.Name }}
app.kubernetes.io/name: horizon-galaxy
app.kubernetes.io/instance: {{ .Release.Name }}-app
app.kubernetes.io/component: app
app.kubernetes.io/part-of: pubsub
{{- end -}}

{{- define "horizon.galaxy.selector" -}}
app.kubernetes.io/instance: {{ .Release.Name }}-app
{{- end -}}

{{- define "horizon.galaxy.volumes" -}}
- name: tmp
  emptyDir: {}
{{- end -}}

{{- define "horizon.galaxy.volumeMounts" -}}
- mountPath: /tmp
  name: tmp
{{- end -}}

{{- define "horizon.galaxy.image" -}}
{{- $imageName := "galaxy" -}}
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

{{- define "horizon.galaxy.envs" -}}
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
- name: {{ .Values.image.name | upper }}_DEFAULT_ENVIRONMENT
  value: {{ .Values.commonHorizon.defaultEnvironment | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_CONSUMING_TOPIC
  value: {{ .Values.galaxy.kafka.consumingTopic | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_GROUP_ID
  value: {{ .Values.galaxy.kafka.consumingGroupId | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_PARTITION_COUNT
  value: {{ .Values.galaxy.kafka.consumingPartitionCount | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: {{ .Values.image.name | upper }}_CORE_THREADPOOL_SIZE
  value: {{ .Values.galaxy.coreThreadpoolSize | quote }}
- name: {{ .Values.image.name | upper }}_MAX_THREADPOOL_SIZE
  value: {{ .Values.galaxy.maxThreadpoolSize | quote }}
- name: {{ .Values.image.name | upper }}_MAX_TIMEOUT
  value: {{ .Values.galaxy.maxTimeout | quote }}
- name: {{ .Values.image.name | upper }}_MAX_RETRIES
  value: {{ .Values.galaxy.maxRetries | quote }}
- name: {{ .Values.image.name | upper }}_INITIAL_BACKOFF_INTERVAL
  value: {{ .Values.galaxy.initialBackoffInterval | quote }}
- name: {{ .Values.image.name | upper }}_MAX_BACKOFF_INTERVAL
  value: {{ .Values.galaxy.maxBackoffInterval | quote }}
- name: {{ .Values.image.name | upper }}_BACKOFF_MULTIPLIER
  value: {{ .Values.galaxy.backoffMultiplier | quote }}
- name: {{ .Values.image.name | upper }}_REPROCESSING_ENABLED
  value: {{ .Values.galaxy.reprocessing.enabled | quote }}
- name: {{ .Values.image.name | upper }}_MAX_REPROCESS_RETRIES
  value: {{ .Values.galaxy.reprocessing.maxRetries| quote }}
- name: {{ .Values.image.name | upper }}_MAX_UNBRIDGED_MESSAGE_AGE
  value: {{ .Values.galaxy.reprocessing.maxUnbridgedMessageAgeMs | quote }}
- name: {{ .Values.image.name | upper }}_REPROCESS_INTERVAL
  value: {{ .Values.galaxy.reprocessing.reprocessIntervalMs | quote }}
- name: {{ .Values.image.name | upper }}_CACHE_SERVICE_DNS
  value: {{ .Values.galaxy.cache.serviceDns }}
- name: {{ .Values.common.team | upper }}_TRACING_DEBUGENABLED
  value: {{ .Values.commonHorizon.tracing.debugEnabled | quote }}
- name: VICTORIALOG_ENABLED
  value: {{ .Values.commonHorizon.victorialog.enabled | quote }}
- name: VICTORIALOG_COLLECTOR_URL
  value: {{ .Values.commonHorizon.victorialog.collectorUrl | quote }}
- name: VICTORIALOG_CLIENT_ID
  value: {{ .Values.commonHorizon.victorialog.clientId | quote }}
- name: VICTORIALOG_BATCH_SIZE
  value: {{ .Values.commonHorizon.victorialog.batchSize | quote }}
- name: VICTORIALOG_OBSERVATION_FLUSH_INTERVAL
  value: {{ .Values.commonHorizon.victorialog.observationFlushInterval | quote }}
- name: VICTORIALOG_COUNT_EVENTS_INTERVAL
  value: {{ .Values.commonHorizon.victorialog.countEventsInterval | quote }}
- name: {{ .Values.image.name | upper }}_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: JAEGER_COLLECTOR_URL
  value: {{ .Values.commonHorizon.tracing.jaegerCollectorBaseUrl | quote }}
- name: ZIPKIN_SAMPLER_PROBABILITY
  value: {{ .Values.commonHorizon.tracing.samplerProbability | quote }}
{{- end -}}
