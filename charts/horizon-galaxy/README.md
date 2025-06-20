<!--
Copyright 2024 Deutsche Telekom IT GmbH

SPDX-License-Identifier: Apache-2.0
-->
# Horizon-Galaxy Helm chart

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) 

Helm chart for deploying Horizon's [Galaxy](https://github.com/telekom/pubsub-horizon-galaxy) component.


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling | object | `{"enabled":false,"maxReplicas":8,"minReplicas":2,"targetCPUUtilizationPercentage":80}` | Horizontal Pod Autoscaler configuration. |
| commonHorizon.defaultEnvironment | string | `"default"` | Sets the default environment. |
| commonHorizon.informer | object | `{"namespace":"default"}` | Specifies namespace for the informer that watches the custom resources. |
| commonHorizon.issuerUrl | string | `"https://keycloak.example.domain.com/auth/realms/example"` | Sets the issuerUrl that is used for authentication. |
| commonHorizon.jmxRemote | object | `{"enabled":false}` | Enables or disables JMX remote configuration. |
| commonHorizon.kafka | object | `{"acks":1,"brokers":"kafka:9092","compression":{"enabled":true,"type":"snappy"},"groupId":"galaxy","lingerMs":5}` | Specifies Kafka broker details for common Horizon settings, including broker addresses, groupId, linger time, acknowledgment settings, and compression options. |
| commonHorizon.logLevel | string | `"WARN"` | Sets the log level for general logging. |
| commonHorizon.publishingTimeoutMs | int | `45000` | Sets the timeout duration (in milliseconds) for the publishing process. |
| commonHorizon.tracing | object | `{"debugEnabled":false,"jaegerCollectorBaseUrl":"http://localhost:14268","samplerProbability":"1.0"}` | Configures tracing settings, including debug mode, Jaeger collector base URL, and sampler probability. |
| customEnv | object | `{}` | Custom environment variables |
| fullnameOverride | string | `""` |  |
| galaxy.backoffMultiplier | float | `2` | BackoffMultiplier: Specifies the backoff multiplier used for exponential backoff in retry operations. |
| galaxy.cache | object | `{"serviceDns":"cache"}` | Cache configuration: Define cache service DNS. |
| galaxy.coreThreadpoolSize | int | `5` | CoreThreadPoolSize: Specifies the core size of the thread pool. |
| galaxy.initialBackoffInterval | int | `100` | Initial BackOffInterval: Specifies the initial backoff interval in milliseconds for retry operations. |
| galaxy.kafka | object | `{"consumingGroupId":"galaxy","consumingPartitionCount":16,"consumingTopic":"published"}` | Kafka configuration for "galaxy" component: Specifies Kafka consumer settings for the "galaxy" component, such as consumingTopic, consumingGroupId and consumingPartitionCount. |
| galaxy.maxBackoffInterval | int | `30000` | MaxBackOffInterval: Specifies the maximum backoff interval in milliseconds for retry operations. |
| galaxy.maxRetries | int | `10` | MaxRetries: Specifies the maximum number of retries allowed for operations. |
| galaxy.maxThreadpoolSize | int | `100` | MaxThreadpoolSize: Specifies the maximum size of the thread pool. |
| galaxy.maxTimeout | int | `100000` | MaxTimeout:  Specifies the maximum timeout value in milliseconds for operations. |
| galaxy.reprocessing | object | `{"enabled":true,"maxRetries":10,"maxUnbridgedMessageAgeMs":180000,"reprocessIntervalMs":300000}` | Reprocessing: Configuration for reprocessing of messages. |
| galaxy.reseekInterval | string | `"3600000"` | ReseekInterval: Specifies the reseek interval in milliseconds. |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"example.devops.company.de/internal/example/horizon/develop","tag":"develop"}` | Specifies the image details such as repository, tag, and pull policy. |
| imagePullSecrets | list | `[]` | List of pull secrets that are required for pulling the the container images. |
| ingress | object | `{"annotations":{"kubernetes.io/ingress.class":"nginx","kubernetes.io/tls-acme":"true","nginx.ingress.kubernetes.io/backend-protocol":"HTTP","nginx.ingress.kubernetes.io/force-ssl-redirect":"true"},"className":"","enabled":true,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}` | Specifies whether ingress is enabled, sets the hostname(s) and Ingress annotations. |
| lifecycle | string | `nil` |  |
| livenessProbe | object | `{"failureThreshold":8,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":20,"periodSeconds":10}` | Kubernetes Liveness Probe configuration. |
| monitoring | object | `{"serviceMonitor":{"enabled":true,"selector":"selector","targetLabels":["ei.telekom.de/cluster","ei.telekom.de/namespace","ei.telekom.de/product","ei.telekom.de/team","ei.telekom.de/environment","app"]}}` | ServiceMonitor configuration. |
| nameOverride | string | `"galaxy"` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | Specifies the annotationsfor the pod. |
| podLabels | object | `{}` | Specifies the labels for the pod. |
| podSecurityContext | object | `{"fsGroup":1000,"supplementalGroups":[1000]}` | Security context set for the pod. |
| readinessProbe | object | `{"failureThreshold":8,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":20,"periodSeconds":10}` | Kubernetes Readiness Probe configuration. |
| replicaCount | int | `1` | Sets the number of replicas for the deployment. |
| resources | object | `{"limits":{"cpu":1,"memory":"500Mi"},"requests":{"cpu":"50m","memory":"200Mi"}}` | Resource limits and requests. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context set for the container. |
| service | object | `{"labels":{"ei.telekom.de/cluster":"AWS-Integration","ei.telekom.de/environment":"integration","ei.telekom.de/product":"horizon","ei.telekom.de/team":"pandora"},"port":"http","type":"ClusterIP"}` | Specifies the service type and port as well as the labels for the service. |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | RBAC (Role-Based Access Control) specific configuration. |
| startupProbe | object | `{"failureThreshold":75,"httpGet":{"path":"/actuator/health","port":"actuator"},"initialDelaySeconds":0,"periodSeconds":1}` | Kubernetes Startup Probe configuration. |
| tolerations | list | `[]` |  |
| volumeMounts[0].mountPath | string | `"/tmp"` |  |
| volumeMounts[0].name | string | `"tmp"` |  |
| volumes[0].emptyDir | object | `{}` |  |
| volumes[0].name | string | `"tmp"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)