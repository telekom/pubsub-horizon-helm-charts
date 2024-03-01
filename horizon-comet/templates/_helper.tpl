{{- define "horizon.comet.labels" -}}
app: {{ .Release.Name }}-comet
app.kubernetes.io/name: horizon-comet
app.kubernetes.io/instance: {{ .Release.Name }}-comet-app
app.kubernetes.io/component: comet
app.kubernetes.io/part-of: horizon
developer.telekom.de/pubsub/horizon/cache-context: callback
{{- end -}}

{{- define "horizon.comet.selector" -}}
app.kubernetes.io/instance: {{ .Release.Name }}-comet-app
{{- end -}}

{{- define "horizon.comet.volumes" -}}
- name: tmp
  emptyDir: {}
{{- end -}}

{{- define "horizon.comet.volumeMounts" -}}
- mountPath: /tmp
  name: tmp
{{- end -}}

{{- define "horizon.comet.image" -}}
{{- $imageName := "comet" -}}
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

{{- define "horizon.comet.envs" -}}
- name: SPRING_PROFILES_ACTIVE
  value: "prod"
- name: LOG_LEVEL
  value: {{ .Values.commonHorizon.logLevel | quote }}
- name: HORIZON_LOG_LEVEL
  value: {{ .Values.commonHorizon.horizonLogLevel | quote }}
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
- name: IRIS_TOKEN_ENDPOINT
  value: {{ .Values.comet.iris.tokenEndpoint | quote }}
- name: IRIS_CLIENT_ID
  value: {{ .Values.comet.iris.clientId | quote }}
- name: IRIS_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-comet-iris
      key: clientSecret
- name: {{ .Values.image.name | upper }}_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_GROUP_ID
  value: {{ .Values.comet.kafka.consumingGroupId | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_PARTITION_COUNT
  value: {{ .Values.comet.kafka.consumingPartitionCount | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_CONSUMER_THREADPOOL_SIZE
  value: {{ .Values.comet.kafka.consumerThreadpoolSize | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_CONSUMER_QUEUE_CAPACITY
  value: {{ .Values.comet.kafka.consumerQueueCapacity | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_MAX_POLL_RECORDS
  value: {{ .Values.comet.kafka.maxPollRecords | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: {{ .Values.image.name | upper }}_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: {{ .Values.image.name | upper }}_MAX_TIMEOUT
  value: {{ .Values.comet.callback.maxTimeout | quote }}
- name: {{ .Values.image.name | upper }}_MAX_RETRIES
  value: {{ .Values.comet.callback.maxRetries | quote }}
- name: {{ .Values.image.name | upper }}_INITIAL_BACKOFF_INTERVAL_MS
  value: {{ .Values.comet.callback.initialBackoffIntervalMs | quote }}
- name: {{ .Values.image.name | upper }}_MAX_BACKOFF_INTERVAL_MS
  value: {{ .Values.comet.callback.maxBackoffIntervalMs | quote }}
- name: {{ .Values.image.name | upper }}_BACKOFF_MULTIPLIER
  value: {{ .Values.comet.callback.backoffMultiplier | quote }}
- name: {{ .Values.image.name | upper }}_MAX_CONNECTIONS
  value: {{ .Values.comet.callback.maxConnections | quote }}
- name: {{ .Values.image.name | upper }}_SUCCESSFUL_STATUS_CODES
  value: {{ .Values.comet.callback.successfulStatusCodes | quote }}
- name: {{ .Values.image.name | upper }}_REDELIVERY_STATUS_CODES
  value: {{ .Values.comet.callback.redeliveryStatusCodes | quote }}
- name: {{ .Values.image.name | upper }}_REDELIVERY_THREADPOOL_SIZE
  value: {{ .Values.comet.callback.redeliveryThreadpoolSize | quote }}
- name: {{ .Values.image.name | upper }}_REDELIVERY_QUEUE_CAPACITY
  value: {{ .Values.comet.callback.redeliveryQueueCapacity | quote }}
- name: {{ .Values.image.name | upper }}_RETRIEVE_TOKEN_CONNECT_TIMEOUT
  value: {{ .Values.comet.security.retrieveTokenConnectTimeout | quote }}
- name: {{ .Values.image.name | upper }}_RETRIEVE_TOKEN_READ_TIMEOUT
  value:  {{ .Values.comet.security.retrieveTokenReadTimeout | quote }}
- name: {{ .Values.image.name | upper }}_CACHE_SERVICE_DNS
  value: {{ .Values.comet.cache.serviceDNS | quote }}
- name: {{ .Values.image.name | upper }}_CACHE_DE_DUPLICATION_ENABLED
  value: {{ .Values.comet.cache.deDuplication.enabled | quote }}
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
