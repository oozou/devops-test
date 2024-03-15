{{- define "app.pod" -}}
{{- $fullName := include "app.fullname" . }}
serviceAccountName: {{ template "app.serviceAccountName" . }}
automountServiceAccountToken: {{ .Values.serviceAccount.autoMount }}
{{- if .Values.securityContext }}
securityContext:
  {{- toYaml .Values.securityContext | nindent 2 }}
{{- end }}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
containers:
  - name: {{ $fullName }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.image.imagePullPolicy | default "IfNotPresent" }}
    {{- if .Values.container.command }}
    command:
      {{- range .Values.container.command }}
      - {{ . }}
      {{- end }}
    {{- end}}
    {{- with .Values.container.containerSecurityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.ports }}
    ports:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if .Values.container.envs }}
    env:
      {{- range $key, $value := .Values.container.envs }}
      - name: {{ $key }}
        valueFrom:
          configMapKeyRef:
            name: {{ $fullName }}
            key: {{ $key }}
      {{- end }}
    {{- end }}
    envFrom:
    {{- if .Values.container.envFromConfigMap }}
      - configMapRef:
          name: {{ .Values.container.envFromConfigMap }}
    {{- end }}
    {{- with .Values.container.livenessProbe }}
    livenessProbe:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.readinessProbe }}
    readinessProbe:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.container.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if .Values.container.lifecycleHooks }}
    lifecycle: {{ tpl (.Values.container.lifecycleHooks | toYaml) . | nindent 6 }}
    {{- end }}
    volumeMounts:
      {{- range .Values.extraReadOnlyFiles }}
      - name: {{ .volumeName }}
        mountPath: {{ .mountPath }}
        readOnly: true
      {{- end }}
      {{- if .Values.volumeMounts }}
        {{- toYaml .Values.volumeMounts | nindent 6 }}
      {{- end }}
  {{- with .Values.extraContainers }}
    {{- tpl . $ | nindent 2 }}
  {{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.affinity }}
affinity:
  {{- include "common.tplvalues.render" (dict "value" .Values.affinity "context" $) | nindent 2 }}
{{- else }}
affinity:
  podAffinity:
    {{- include "common.affinities.pods" (dict "type" .Values.podAffinityPreset "context" $) | nindent 4 }}
  podAntiAffinity:
    {{- include "common.affinities.pods" (dict "type" .Values.podAntiAffinityPreset "context" $) | nindent 4 }}
  nodeAffinity:
    {{- include "common.affinities.nodes" (dict "type" .Values.nodeAffinityPreset.type "key" .Values.nodeAffinityPreset.key "values" .Values.nodeAffinityPreset.values) | nindent 4 }}
{{- end }}
{{- with .Values.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
{{- end }}
volumes:
{{- range .Values.extraReadOnlyFiles }}
  - name: {{ .volumeName }}
    secret:
      secretName: {{ $fullName }}-{{ .volumeName }}
{{- end }}
{{- with .Values.volumes }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
