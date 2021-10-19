{{- define "crawler-bot.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end -}}