{{- define "horizon.polaris.envs" -}}
{{- $customEnv := dict -}}
{{- range $key, $val := .Values.customEnv }}
  {{- $upper := upper (printf "%v_%v" (include "horizon.polaris.name" $) $key) -}}
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
- name: POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: IRIS_TOKEN_ENDPOINT
  value: {{ .Values.polaris.iris.tokenEndpoint | toString | quote }}
- name: IRIS_CLIENT_ID
  value: {{ .Values.polaris.iris.clientId | toString | quote }}
- name: IRIS_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "horizon.polaris.fullname" . }}
      key: clientSecret
- name: POLARIS_KAFKA_BROKERS
  value: {{ .Values.commonHorizon.kafka.brokers | quote }}
- name: POLARIS_KAFKA_GROUP_ID
  value: {{ .Values.commonHorizon.kafka.groupId | quote }}
- name: POLARIS_KAFKA_ACKS
  value: {{ .Values.commonHorizon.kafka.acks | default 1 | quote }}
- name: POLARIS_KAFKA_LINGER_MS
  value: {{ .Values.commonHorizon.kafka.lingerMs | default 5 | quote }}
- name: POLARIS_KAFKA_COMPRESSION_ENABLED
  value: {{ .Values.commonHorizon.kafka.compression.enabled | default false | quote }}
- name: POLARIS_KAFKA_COMPRESSION_TYPE
  value: {{ .Values.commonHorizon.kafka.compression.type | default "snappy" }}
- name: POLARIS_MAX_TIMEOUT
  value: {{ .Values.polaris.maxTimeout | quote }}
- name: POLARIS_MAX_CONNECTIONS
  value: {{ .Values.polaris.maxConnections | quote }}
- name: POLARIS_INFORMER_NAMESPACE
  value: {{ .Values.commonHorizon.informer.namespace | quote }}
- name: POLARIS_PODS_INFORMER_NAMESPACE
  value: {{ .Values.polaris.informer.pods.namespace | quote }}
- name: POLARIS_APP_NAME
  value: {{ .Release.Name | quote }}
- name: POLARIS_DELIVERING_STATES_OFFSET_MINS
  value: {{ .Values.polaris.offsetMins.deliveringStates | quote }}
- name: POLARIS_SUCCESSFUL_STATUS_CODES
  value: {{ .Values.polaris.request.successfulStatusCodes | quote }}
- name: POLARIS_POLLING_INTERVAL_MS
  value: {{ .Values.polaris.polling.intervalMs | quote }}
- name: POLARIS_POLLING_BATCH_SIZE
  value: {{ .Values.polaris.polling.batchSize | quote }}
- name: POLARIS_PICKING_TIMEOUT_MS
  value: {{ .Values.polaris.picking.timeoutMs | quote }}
- name: POLARIS_REQUEST_COOLDOWN_RESET_MINS
  value: {{ .Values.polaris.request.cooldownResetMins | quote }}
- name: POLARIS_REQUEST_THREADPOOL_SIZE
  value: {{ .Values.polaris.request.scheduledThreadpool.size | quote }}
- name: POLARIS_REQUEST_DELAY_MINS
  value: {{ .Values.polaris.request.delayMins | quote }}
- name: POLARIS_SUBCHECK_THREADPOOL_MAX_SIZE
  value: {{ .Values.polaris.subscriptionCheck.threadpool.maxSize | quote }}
- name: POLARIS_SUBCHECK_THREADPOOL_CORE_SIZE
  value: {{ .Values.polaris.subscriptionCheck.threadpool.coreSize | quote }}
- name: POLARIS_SUBCHECK_THREADPOOL_QUEUE_CAPACITY
  value: {{ .Values.polaris.subscriptionCheck.threadpool.queueCapacity | quote }}
- name: POLARIS_REPUBLISH_THREADPOOL_MAX_SIZE
  value: {{ .Values.polaris.republish.threadpool.maxSize | quote }}
- name: POLARIS_REPUBLISH_THREADPOOL_CORE_SIZE
  value: {{ .Values.polaris.republish.threadpool.coreSize | quote }}
- name: POLARIS_REPUBLISH_THREADPOOL_QUEUE_CAPACITY
  value: {{ .Values.polaris.republish.threadpool.queueCapacity | quote }}
- name: POLARIS_REPUBLISH_BATCH_SIZE
  value: {{ .Values.polaris.republish.batchSize | quote }}
- name: POLARIS_REPUBLISHING_TIMEOUT_MS
  value: {{ .Values.polaris.republish.timeoutMs | quote }}
- name: HORIZON_MONGO_CLIENTID
  value: {{ .Values.polaris.mongo.clientId | quote }}
- name: HORIZON_MONGO_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "horizon.polaris.fullname" . }}
      key: mongoUrl
- name: HORIZON_CACHE_KUBERNETESSERVICEDNS
  value: {{ .Values.polaris.cache.serviceDNS | quote }}
{{- template "horizon.renderEnv" $customEnv -}}
{{- end -}}


