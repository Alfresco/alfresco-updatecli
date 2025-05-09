{{- define "manifest_name" }}
{{- default "Alfresco components' Updatecli manifest" .name }}
{{- end }}
{{- define "quay_auth" }}
      username: {{ requiredEnv "QUAY_USERNAME" }}
      password: {{ requiredEnv "QUAY_PASSWORD" }}
{{- end }}
{{- define "common_version_filter" }}
      {{- $vfk := .versionFilterKind | default "regex" }}
      versionFilter:
        kind: {{ $vfk }}
        pattern: >-
          {{- if eq $vfk "regex" }}
          ^{{ .version }}{{ .pattern }}$
          {{- else }}
          {{ .version }}
          {{- end }}
        {{- if and (eq $vfk "regex/semver") .regex }}
        regex: {{ .regex }}
        {{- end }}
{{- end }}
---
name: {{ template "manifest_name" . }}

scms:
  searchEnterprise:
    name: Alfresco Elasticsearch connector
    kind: github
    spec:
      owner: Alfresco
      repository: alfresco-elasticsearch-connector
      branch: master
      username: alfresco-build
      token: {{ requiredEnv "UPDATECLI_GITHUB_TOKEN" }}
      directory: /tmp/updatecli/searchEnterprise

{{- $default_repo_image := "quay.io/alfresco/alfresco-content-repository" }}
{{- $default_search_image := "quay.io/alfresco/search-services" }}
{{- $default_share_image := "quay.io/alfresco/alfresco-share" }}
{{- $default_activemq_image := "quay.io/alfresco/alfresco-activemq" }}

sources:
  {{- range .matrix }}
  {{- if .id }}
  {{- $id := .id -}}
  {{- with .adminApp }}
  adminAppTag_{{ $id }}:
    name: >-
      Alfresco admin application tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-control-center
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .adw }}
  adwTag_{{ $id }}:
    name: Alfresco Digital Workspace tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-digital-workspace
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .activemq }}
  {{ $activemq_image := .image | default $default_activemq_image }}
  activemqTag_{{ $id }}:
    name: Alfresco ActiveMQ tag
    kind: dockerimage
    spec:
      image: {{ $activemq_image }}
      {{ if eq (printf "%.8s" $activemq_image) "quay.io/" }}
      {{ template "quay_auth" }}
      {{ end }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .aca }}
  acaTag_{{ $id }}:
    name: Alfresco Content App tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-content-app
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .acs }}
  {{- $repo_image := .image | default $default_repo_image }}
  repositoryTag_{{ $id }}:
    name: ACS repository tag
    kind: dockerimage
    spec:
      image: {{ $repo_image }}
      {{ if eq (printf "%.8s" $repo_image) "quay.io/" }}
      {{ template "quay_auth" }}
      {{ end }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{ with index . "insight-zeppelin" }}
  insightZeppelinTag_{{ $id }}:
    name: Alfresco Insight Zeppelin
    kind: dockerimage
    spec:
      image: quay.io/alfresco/insight-zeppelin
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "search-enterprise" }}
  searchEnterpriseTag_{{ $id }}:
    name: Search Enterprise tag
    kind: gittag
    scmid: searchEnterprise
    spec:
      {{ template "common_version_filter" . }}
  {{ end }}
  {{- with .search }}
  {{ $search_image := .image | default $default_search_image }}
  searchTag_{{ $id }}:
    name: Alfresco Search Services
    kind: dockerimage
    spec:
      image: {{ $search_image }}
      {{ if eq (printf "%.8s" $search_image) "quay.io/" }}
      {{ template "quay_auth" }}
      {{ end }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .share }}
  {{ $share_image := .image | default $default_share_image }}
  shareTag_{{ $id }}:
    name: Share repository tag
    kind: dockerimage
    spec:
      image: {{ $share_image }}
      {{ if eq (printf "%.8s" $share_image) "quay.io/" }}
      {{ template "quay_auth" }}
      {{ end }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .sync }}
  syncTag_{{ $id }}:
    name: Sync Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/service-sync
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .onedrive }}
  onedriveTag_{{ $id }}:
    name: Onedrive (OOI) Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-ooi-service
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .msteams }}
  msteamsTag_{{ $id }}:
    name: MS Teams Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-ms-teams-service
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .intelligence }}
  intelligenceTag_{{ $id }}:
    name: Intelligence Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-ai-docker-engine
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .trouter }}
  trouterTag_{{ $id }}:
    name: Alfresco Transform Router image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-transform-router
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .sfs }}
  sfsTag_{{ $id }}:
    name: Alfresco Shared Filestore image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-shared-file-store
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "tengine-aio" }}
  tengine-aioTag_{{ $id }}:
    name: Alfresco All-In-One Transform Engine image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-transform-core-aio
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "tengine-misc" }}
  tengine-miscTag_{{ $id }}:
    name: Alfresco misc Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-transform-misc
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "tengine-im" }}
  tengine-imTag_{{ $id }}:
    name: Alfresco ImageMagick Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-imagemagick
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "tengine-lo" }}
  tengine-loTag_{{ $id }}:
    name: Alfresco LibreOffice Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-libreoffice
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "tengine-pdf" }}
  tengine-pdfTag_{{ $id }}:
    name: Alfresco PDF Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-pdf-renderer
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "tengine-tika" }}
  tengine-tikaTag_{{ $id }}:
    name: Alfresco tika Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-tika
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with .activiti}}
  activitiTag_{{ $id }}:
    name: Alfresco Activiti image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-process-services
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "activiti-admin"}}
  activitiAdminTag_{{ $id }}:
    name: Alfresco Activiti Admin image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-process-services-admin
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- with index . "audit-storage"}}
  auditStorageTag_{{ $id }}:
    name: Alfresco Repository Audit component image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-audit-storage
      {{ template "quay_auth" }}
      {{ template "common_version_filter" . }}
  {{- end }}
  {{- end }}
  {{- end }}


targets:
  {{- range .matrix }}
  {{- $id := .id -}}
  {{- with .adminApp }}
  {{- if and .compose_key .compose_target }}
  adminAppCompose_{{ $id }}:
    name: Alfresco Control Center
    kind: yaml
    sourceid: adminAppTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-control-center:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  adminAppValues_{{ $id }}:
    name: Helm chart default values file
    kind: yaml
    sourceid: adminAppTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with .adw }}
  {{- if and .compose_key .compose_target }}
  adwCompose_{{ $id }}:
    name: ADW image tag
    kind: yaml
    sourceid: adwTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-digital-workspace:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  adwValues_{{ $id }}:
    name: ADW image tag
    kind: yaml
    sourceid: adwTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with .aca }}
  {{- if and .compose_key .compose_target }}
  acaCompose_{{ $id }}:
    name: ACA image tag
    kind: yaml
    sourceid: acaTag_{{ $id }}
    transformers:
      - addprefix: "alfresco/alfresco-content-app:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  acaValues_{{ $id }}:
    name: ACA image tag
    kind: yaml
    sourceid: acaTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with .acs }}
  {{- if and .compose_key .compose_target }}
  repositoryCompose_{{ $id }}:
    name: Repo image tag
    kind: yaml
    sourceid: repositoryTag_{{ $id }}
    transformers:
      - addprefix: "{{ .image | default $default_repo_image }}:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  repositoryValues_{{ $id }}:
    name: Repo image tag
    kind: yaml
    sourceid: repositoryTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  repositoryAppVersion_{{ $id }}:
    name: Repo appVersion in Chart.yaml
    kind: yaml
    sourceid: repositoryTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with index . "insight-zeppelin" }}
  {{ $target_insight_zeppelin_helm := .helm_target }}
  {{- if $target_insight_zeppelin_helm }}
  insightZeppelinValues_{{ $id }}:
    name: Alfresco Insight Zeppelin image tag
    kind: yaml
    sourceid: insightZeppelinTag_{{ $id }}
    spec:
      file: {{ $target_insight_zeppelin_helm }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  insightZeppelinAppVersion_{{ $id }}:
    name: Alfresco Insight Zeppelin appVersion in Chart.yaml
    kind: yaml
    sourceid: insightZeppelinTag_{{ $id }}
    spec:
      file: {{ osDir $target_insight_zeppelin_helm }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with .search }}
  {{- if and .compose_key .compose_target }}
  searchCompose_{{ $id }}:
    name: search image tag
    kind: yaml
    sourceid: searchTag_{{ $id }}
    transformers:
      - addprefix: "{{ .image | default $default_search_image }}:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- $target_search_helm := .helm_target}}
  {{- if and .helm_keys $target_search_helm }}
  {{- range $key, $path := .helm_keys }}
  searchValues{{ $key }}_{{ $id }}:
    name: search image tag
    kind: yaml
    sourceid: searchTag_{{ $id }}
    spec:
      file: {{ $target_search_helm }}
      key: >-
        {{ $path }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  searchAppVersion_{{ $id }}:
    name: Search appVersion in Chart.yaml
    kind: yaml
    sourceid: searchTag_{{ $id }}
    spec:
      file: {{ osDir $target_search_helm }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- end }}
  {{- with .activemq }}
  {{- if and .compose_key .compose_target }}
  activemqCompose_{{ $id }}:
    name: activemq image tag
    kind: yaml
    sourceid: activemqTag_{{ $id }}
    transformers:
      - addprefix: "{{ .image | default $default_activemq_image }}:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_target .helm_key }}
  activemqValues_{{ $id }}:
    name: activemq image tag
    kind: yaml
    sourceid: activemqTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  activemqAppVersion_{{ $id }}:
    name: Search appVersion in Chart.yaml
    kind: yaml
    sourceid: activemqTag_{{ $id }}
    transformers:
      - trimsuffix: "-jre17-rockylinux8"
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with index . "search-enterprise" }}
  {{- if and .compose_keys .compose_target }}
  {{- $target_searchEntCompose := .compose_target }}
  {{- range $index, $key := .compose_keys }}
  searchEnterprise{{ $index }}Compose_{{ $id }}:
    name: Search Enterprise image tag
    kind: yaml
    sourceid: searchEnterpriseTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-elasticsearch-{{ $index }}:"
    spec:
      file: {{ $target_searchEntCompose }}
      key: {{ $key }}
  {{- end }}
  {{- end }}
  {{- if and .helm_keys .helm_target }}
  {{- $target_searchEnt := .helm_target }}
  searchEnterpriseReindexingValues_{{ $id }}:
    name: Search Enterprise image tag
    kind: yaml
    sourceid: searchEnterpriseTag_{{ $id }}
    spec:
      file: {{ $target_searchEnt }}
      key: {{ .helm_keys.Reindexing }}
  {{- range $key, $value := .helm_keys.Liveindexing }}
  searchEnterprise{{ $key }}Values_{{ $id }}:
    name: Search Enterprise image tag
    kind: yaml
    sourceid: searchEnterpriseTag_{{ $id }}
    spec:
      file: {{ $target_searchEnt }}
      key: {{ $value }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  searchEnterpriseAppVersion_{{ $id }}:
    name: Search Enterprise appVersion in Chart.yaml
    kind: yaml
    sourceid: searchEnterpriseTag_{{ $id }}
    spec:
      file: {{ osDir $target_searchEnt }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- end }}
  {{- with .share }}
  {{- if and .compose_key .compose_target }}
  shareCompose_{{ $id }}:
    name: Share image tag
    kind: yaml
    sourceid: shareTag_{{ $id }}
    transformers:
      - addprefix: "{{ .image | default $default_share_image }}:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  shareValues_{{ $id }}:
    name: Share image tag
    kind: yaml
    sourceid: shareTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  shareAppVersion_{{ $id }}:
    name: Share appVersion in Chart.yaml
    kind: yaml
    sourceid: shareTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with .onedrive }}
  {{- if and .helm_key .helm_target }}
  onedriveValues_{{ $id }}:
    name: Onedrive image tag
    kind: yaml
    sourceid: onedriveTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  onedriveAppVersion_{{ $id }}:
    name: Onedrive appVersion in Chart.yaml
    kind: yaml
    sourceid: onedriveTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with .msteams }}
  {{- if and .helm_key .helm_target }}
  msteamsValues_{{ $id }}:
    name: MS Teams image tag
    kind: yaml
    sourceid: msteamsTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  msteamsAppVersion_{{ $id }}:
    name: MS Teams appVersion in Chart.yaml
    kind: yaml
    sourceid: msteamsTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with .intelligence }}
  {{- if and .helm_key .helm_target }}
  intelligenceValues_{{ $id }}:
    name: Alfresco Intelligence image tag
    kind: yaml
    sourceid: intelligenceTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  intelligenceAppVersion_{{ $id }}:
    name: Alfresco Intelligence appVersion in Chart.yaml
    kind: yaml
    sourceid: intelligenceTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with .trouter }}
  {{- if and .compose_key .compose_target }}
  trouterCompose_{{ $id }}:
    name: Alfresco Transform Router image tag
    kind: yaml
    sourceid: trouterTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-transform-router:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  trouterValues_{{ $id }}:
    name: Alfresco Transform Router image tag
    kind: yaml
    sourceid: trouterTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  trouterAppVersion_{{ $id }}:
    name: Alfresco Transform Router appVersion in Chart.yaml
    kind: yaml
    sourceid: trouterTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with .sfs }}
  {{- if and .compose_key .compose_target }}
  sfsCompose_{{ $id }}:
    name: Alfresco Shared Filestore image tag
    kind: yaml
    sourceid: sfsTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-shared-file-store:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  sfsValues_{{ $id }}:
    name: Alfresco Shared Filestore image tag
    kind: yaml
    sourceid: sfsTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with index . "tengine-aio" }}
  {{- if and .compose_key .compose_target }}
  tengine-aioCompose_{{ $id }}:
    name: Alfresco All-In-One Transform Engine image tag
    kind: yaml
    sourceid: tengine-aioTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-transform-core-aio:"
    spec:
      file: {{ .compose_target }}
      key: >-
        {{ .compose_key }}
  {{- end }}
  {{- end }}
  {{- with index . "tengine-misc" }}
  {{- if and .helm_key .helm_target }}
  tengine-miscValues_{{ $id }}:
    name: Alfresco misc Transform Engine image tag
    kind: yaml
    sourceid: tengine-miscTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with index . "tengine-im" }}
  {{- if and .helm_key .helm_target }}
  tengine-imValues_{{ $id }}:
    name: Alfresco ImageMagick Transform Engine image tag
    kind: yaml
    sourceid: tengine-imTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with index . "tengine-lo" }}
  {{- if and .helm_key .helm_target }}
  tengine-loValues_{{ $id }}:
    name: Alfresco LibreOffice Transform Engine image tag
    kind: yaml
    sourceid: tengine-loTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with index . "tengine-pdf" }}
  {{- if and .helm_key .helm_target }}
  tengine-pdfValues_{{ $id }}:
    name: Alfresco PDF Transform Engine image tag
    kind: yaml
    sourceid: tengine-pdfTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with index . "tengine-tika" }}
  {{- if and .helm_key .helm_target }}
  tengine-tikaValues_{{ $id }}:
    name: Alfresco tika Transform Engine image tag
    kind: yaml
    sourceid: tengine-tikaTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- end }}
  {{- with .sync }}
  {{- if and .compose_key .compose_target }}
  syncCompose_{{ $id }}:
    name: Sync image tag
    kind: yaml
    sourceid: syncTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/service-sync:"
    spec:
      file: {{ .compose_target }}
      key: {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  syncValues_{{ $id }}:
    name: Sync image tag
    kind: yaml
    sourceid: syncTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  syncAppVersion_{{ $id }}:
    name: Sync appVersion in Chart.yaml
    kind: yaml
    sourceid: syncTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with .activiti }}
  {{- if and .helm_key .helm_target }}
  activitiValues_{{ $id }}:
    name: Activiti image tag
    kind: yaml
    sourceid: activitiTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- end }}
  {{- if .helm_update_appVersion }}
  activitiAppVersion_{{ $id }}:
    name: Activiti appVersion in Chart.yaml
    kind: yaml
    sourceid: activitiTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- with index . "activiti-admin" }}
  {{- if and .helm_key .helm_target }}
  activitiAdminValues_{{ $id }}:
    name: Activiti Admin image tag
    kind: yaml
    sourceid: activitiAdminTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: >-
        {{ .helm_key }}
  {{- if .helm_update_appVersion }}
  activitiAdminAppVersion_{{ $id }}:
    name: Activiti Admin appVersion in Chart.yaml
    kind: yaml
    sourceid: activitiAdminTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- end }}
  {{- with index . "audit-storage" }}
  {{- if and .compose_key .compose_target }}
  auditStorageCompose_{{ $id }}:
    name: Alfresco Repository Audit Compose target
    kind: yaml
    sourceid: auditStorageTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-audit-storage:"
    spec:
      file: {{ .compose_target }}
      key: {{ .compose_key }}
  {{- end }}
  {{- if and .helm_key .helm_target }}
  auditStorageValues_{{ $id }}:
    name: Alfresco Repository Audit Helm values target
    kind: yaml
    sourceid: auditStorageTag_{{ $id }}
    spec:
      file: {{ .helm_target }}
      key: {{ .helm_key }}
  {{- if .helm_update_appVersion }}
  auditStorageAppVersion_{{ $id }}:
    name: Alfresco Repository Audit Helm Chart target
    kind: yaml
    sourceid: auditStorageTag_{{ $id }}
    spec:
      file: {{ osDir .helm_target }}/Chart.yaml
      key: "$.appVersion"
  {{- end }}
  {{- end }}
  {{- end }}
  {{- end }}
