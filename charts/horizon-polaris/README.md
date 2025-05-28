<!--
Copyright 2024 Deutsche Telekom IT GmbH

SPDX-License-Identifier: Apache-2.0
-->
# Horizon-Polaris Helm chart

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) 

Helm chart for deploying Horizon's [Polaris](https://github.com/telekom/pubsub-horizon-polaris) component.


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":8,"minReplicas":2,"targetCPUUtilizationPercentage":80}` | Horizontal Pod Autoscaler configuration. |
| commonHorizon.defaultEnvironment | string | `"default"` | Sets the default environment. |
| commonHorizon.informer | object | `{"namespace":"default"}` | Specifies namespace for the informer that watches the custom resources. |
| commonHorizon.issuerUrl | string | `"https://keycloak.example.domain.com/auth/realms/example"` | Sets the issuerUrl that is used for authentication. |
| commonHorizon.jmxRemote | object | `{"enabled":false}` | Enables or disables JMX remote configuration. |
| commonHorizon.kafka | object | `{"acks":1,"brokers":"kafka:9092","compression":{"enabled":true,"type":"snappy"},"groupId":"polaris","lingerMs":5}` | Specifies Kafka broker details for common Horizon settings, including broker addresses, groupId, linger time, acknowledgment settings, and compression options. |
| commonHorizon.logLevel | string | `"WARN"` | Sets the log level for general logging. |
| commonHorizon.publishingTimeoutMs | int | `45000` | Sets the timeout duration (in milliseconds) for the publishing process. |
| commonHorizon.tracing | object | `{"debugEnabled":false,"jaegerCollectorBaseUrl":"http://localhost:14268","samplerProbability":"1.0"}` | Configures tracing settings, including debug mode, Jaeger collector base URL, and sampler probability. |
| customEnv | object | `{}` | Custom environment variables |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"example.devops.company.de/internal/example/horizon/develop","tag":"develop"}` | Specifies the image details such as repository, tag, and pull policy. |
| imagePullSecrets | list | `[]` | List of pull secrets that are required for pulling the the container images. |
| ingress | object | `{"annotations":{"kubernetes.io/ingress.class":"nginx","kubernetes.io/tls-acme":"true","nginx.ingress.kubernetes.io/backend-protocol":"HTTP","nginx.ingress.kubernetes.io/force-ssl-redirect":"true"},"className":"","enabled":true,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}` | Specifies whether ingress is enabled, sets the hostname(s) and Ingress annotations. |
| lifecycle | string | `nil` |  |
| livenessProbe | object | `{"failureThreshold":8,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":20,"periodSeconds":10}` | Kubernetes Liveness Probe configuration. |
| monitoring | object | `{"serviceMonitor":{"enabled":true,"selector":"selector","targetLabels":["developer.telekom.de/cluster","developer.telekom.de/namespace","developer.telekom.de/product","developer.telekom.de/subproduct","developer.telekom.de/team","developer.telekom.de/environment","app"]}}` | ServiceMonitor configuration. |
| nameOverride | string | `"polaris"` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | Specifies the annotationsfor the pod. |
| podLabels | object | `{}` | Specifies the labels for the pod. |
| podSecurityContext | object | `{"fsGroup":1000,"supplementalGroups":[1000]}` | Security context set for the pod. |
| polaris.cache | object | `{"serviceDNS":"cache"}` | Cache configuration: Define cache service DNS. |
| polaris.informer | object | `{"pods":{"namespace":"default"}}` | Informer namespace: Configuration for the informer, including default namespace. |
| polaris.iris | object | `{"clientId":"clientId","clientSecret":"secret","tokenEndpoint":"irisUrl"}` | Iris configuration: Authentication details for Iris, including the token endpoint, clientId, and client secret. |
| polaris.maxConnections | int | `100` | Max connections: Maximum allowed connections. |
| polaris.maxTimeout | int | `30000` | Max timeout: Maximum timeout duration. |
| polaris.mongo | object | `{"clientId":"polaris","url":"mongodbUrl"}` | Mongo configuration: Set clientId and mongo URL for mongo configuration. |
| polaris.offsetMins | object | `{"deliveringStates":15}` | OffsetMins: Offset duration to adjust the time before considering states as delivered. |
| polaris.picking | object | `{"timeoutMs":5000}` | Picking: Timeout duration for the picking process. |
| polaris.polling | object | `{"batchSize":10,"intervalMs":30000}` | Polling: Configuration for polling mechanism. |
| polaris.republish | object | `{"batchSize":100,"threadpool":{"coreSize":50,"maxSize":50,"queueCapacity":50},"timeoutMs":5000}` | Republish: Configuration for republishing mechanism. |
| polaris.request | object | `{"cooldownResetMins":90,"delayMins":5,"scheduledThreadpool":{"size":50},"successfulStatusCodes":"200,201,202,204"}` | Request: Configuration related to handling requests. |
| polaris.subscriptionCheck | object | `{"threadpool":{"coreSize":50,"maxSize":50,"queueCapacity":50}}` | SubscriptionCheck: Configuration related to subscription checking. |
| readinessProbe | object | `{"failureThreshold":8,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":20,"periodSeconds":10}` | Kubernetes Readiness Probe configuration. |
| replicaCount | int | `1` | Sets the number of replicas for the deployment. |
| resources | object | `{"limits":{"cpu":1,"memory":"1Gi"},"requests":{"cpu":"50m","memory":"200Mi"}}` | Resource limits and requests. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context set for the container. |
| service | object | `{"labels":{"developer.telekom.de/cluster":"AWS-Integration","developer.telekom.de/environment":"integration","developer.telekom.de/expose-on-statuspage":"true","developer.telekom.de/namespace":"integration","developer.telekom.de/product":"horizon","developer.telekom.de/subproduct":"polaris","developer.telekom.de/team":"pandora"},"port":"http","type":"ClusterIP"}` | Specifies the service type and port as well as the labels for the service. |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | RBAC (Role-Based Access Control) specific configuration. |
| startupProbe | object | `{"failureThreshold":75,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":0,"periodSeconds":1}` | Kubernetes Startup Probe configuration. |
| strategy | object | `{}` | Sets the deployment strategy for the deployment. |
| tolerations | list | `[]` |  |
| volumeMounts[0].mountPath | string | `"/tmp"` |  |
| volumeMounts[0].name | string | `"tmp"` |  |
| volumes[0].emptyDir | object | `{}` |  |
| volumes[0].name | string | `"tmp"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)