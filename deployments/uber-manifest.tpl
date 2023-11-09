---
name: Images updates for all Alfresco supported versions of Helm charts and Docker compose

{{- define "quay_auth" }}
      username: {{ requiredEnv "QUAY_USERNAME" }}
      password: {{ requiredEnv "QUAY_PASSWORD" }}
{{- end }}

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

sources:
  {{- range .matrix }}
  {{- $id := .id -}}
  {{- if index . "adminApp" }}
  adminAppTag_{{ $id }}:
    name: >-
      Alfresco admin application tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-control-center
      {{ template "quay_auth" }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "adminApp" "version" }}{{ index . "adminApp" "pattern" }}$
  {{- end }}
  {{- if index . "adw" }}
  adwTag_{{ $id }}:
    name: Alfresco Digital Workspace tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-digital-workspace
      {{ template "quay_auth" }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "adw" "version" }}{{ index . "adw" "pattern" }}$
  {{- end }}
  {{- if index . "aca" }}
  acaTag_{{ $id }}:
    name: Alfresco Content App tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-content-app
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "aca" "version" }}{{ index . "aca" "pattern" }}$
  {{- end }}
  {{- if index . "acs" }}
  {{ $repo_image := index . "acs" "image" | default "quay.io/alfresco/alfresco-content-repository" }}
  repositoryTag_{{ $id }}:
    name: ACS repository tag
    kind: dockerimage
    spec:
      image: {{ $repo_image }}
      {{ if eq (printf "%.8s" $repo_image) "quay.io/" }}
      {{ template "quay_auth" }}
      {{ end }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "acs" "version" }}{{ index . "acs" "pattern" }}$
  {{- end }}
  {{- if index . "search-enterprise" }}
  searchEnterpriseTag_{{ $id }}:
    name: Search Enterprise tag
    kind: gittag
    scmid: searchEnterprise
    spec:
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "search-enterprise" "version" }}{{ index . "search-enterprise" "pattern" }}$
  {{ end }}
  {{- if index . "search" }}
  {{ $search_image := index . "search" "image" | default "quay.io/alfresco/search-services" }}
  searchTag_{{ $id }}:
    name: Alfresco Search Services
    kind: dockerimage
    spec:
      image: {{ $search_image }}
      {{ if eq (printf "%.8s" $search_image) "quay.io/" }}
      {{ template "quay_auth" }}
      {{ end }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "search" "version" }}{{ index . "search" "pattern" }}$
  {{- end }}
  {{- if index . "share" }}
  {{ $share_image := index . "share" "image" | default "quay.io/alfresco/alfresco-share" }}
  shareTag_{{ $id }}:
    name: Share repository tag
    kind: dockerimage
    spec:
      image: {{ $share_image }}
      {{ if eq (printf "%.8s" $share_image) "quay.io/" }}
      {{ template "quay_auth" }}
      {{ end }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "share" "version" }}{{ index . "share" "pattern" }}$
  {{- end }}
  {{- if index . "sync" }}
  syncTag_{{ $id }}:
    name: Sync Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/service-sync
      {{ template "quay_auth" }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "sync" "version" }}{{ index . "sync" "pattern" }}$
  {{- end }}
  {{- if index . "onedrive" }}
  onedriveTag_{{ $id }}:
    name: Onedrive (OOI) Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-ooi-service
      {{ template "quay_auth" }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "onedrive" "version" }}{{ index . "onedrive" "pattern" }}$
  {{- end }}
  {{- if index . "msteams" }}
  msteamsTag_{{ $id }}:
    name: MS Teams Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-ms-teams-service
      {{ template "quay_auth" }}
      versionFilter:
        kind: regex
        pattern: >-
          ^{{ index . "msteams" "version" }}{{ index . "msteams" "pattern" }}$
  {{- end }}
  {{- if index . "intelligence" }}
  intelligenceTag_{{ $id }}:
    name: Intelligence Service image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-ai-docker-engine
      {{ template "quay_auth" }}
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "intelligence" "version" }}
  {{- end }}
  {{- if index . "trouter" }}
  trouterTag_{{ $id }}:
    name: Alfresco Transform Router image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-transform-router
      {{ template "quay_auth" }}
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "trouter" "version" }}
  {{- end }}
  {{- if index . "sfs" }}
  sfsTag_{{ $id }}:
    name: Alfresco Shared Filestore image tag
    kind: dockerimage
    spec:
      image: quay.io/alfresco/alfresco-shared-file-store
      {{ template "quay_auth" }}
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "sfs" "version" }}
  {{- end }}
  {{- if index . "tengine-aio" }}
  tengine-aioTag_{{ $id }}:
    name: Alfresco All-In-One Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-transform-core-aio
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "tengine-aio" "version" }}
  {{- end }}
  {{- if index . "tengine-misc" }}
  tengine-miscTag_{{ $id }}:
    name: Alfresco misc Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-transform-misc
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "tengine-misc" "version" }}
  {{- end }}
  {{- if index . "tengine-im" }}
  tengine-imTag_{{ $id }}:
    name: Alfresco ImageMagick Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-imagemagick
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "tengine-im" "version" }}
  {{- end }}
  {{- if index . "tengine-lo" }}
  tengine-loTag_{{ $id }}:
    name: Alfresco LibreOffice Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-libreoffice
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "tengine-lo" "version" }}
  {{- end }}
  {{- if index . "tengine-pdf" }}
  tengine-pdfTag_{{ $id }}:
    name: Alfresco PDF Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-pdf-renderer
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "tengine-pdf" "version" }}
  {{- end }}
  {{- if index . "tengine-tika" }}
  tengine-tikaTag_{{ $id }}:
    name: Alfresco tika Transform Engine image tag
    kind: dockerimage
    spec:
      image: alfresco/alfresco-tika
      versionFilter:
        kind: semver
        pattern: >-
          {{ index . "tengine-tika" "version" }}
  {{- end }}
  {{- end }}


targets:
  {{- range .matrix }}
  {{- $id := .id -}}
  {{- if index . "adminApp" }}
  {{- if and .adminApp.compose_key .adminApp.compose_target }}
  adminAppCompose_{{ $id }}:
    name: Alfresco Control Center
    kind: yaml
    sourceid: adminAppTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-control-center:"
    spec:
      file: {{ .adminApp.compose_target }}
      key: >-
        {{ .adminApp.compose_key }}
  {{- end }}
  {{- if and .adminApp.helm_key .adminApp.helm_target }}
  adminAppValues_{{ $id }}:
    name: Helm chart default values file
    kind: yaml
    sourceid: adminAppTag_{{ $id }}
    spec:
      file: {{ .adminApp.helm_target }}
      key: >-
        {{ .adminApp.helm_key }}
  {{- end }}
  {{- end }}
  {{- if index . "adw" }}
  adwCompose_{{ $id }}:
    name: ADW image tag
    kind: yaml
    sourceid: adwTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/alfresco-digital-workspace:"
    spec:
      file: {{ .adw.compose_target }}
      key: >-
        {{ .adw.compose_key }}
  adwValues_{{ $id }}:
    name: ADW image tag
    kind: yaml
    sourceid: adwTag_{{ $id }}
    spec:
      file: {{ .adw.helm_target }}
      key: >-
        {{ .adw.helm_key }}
  {{- end }}
  {{- if index . "aca" }}
  acaCompose_{{ $id }}:
    name: ACA image tag
    kind: yaml
    sourceid: acaTag_{{ $id }}
    transformers:
      - addprefix: "alfresco/alfresco-content-app:"
    spec:
      file: {{ .aca.compose_target }}
      key: >-
        {{ .aca.compose_key }}
  {{- end }}
  {{- if index . "acs" }}
  {{- if and .acs.compose_key .acs.compose_target }}
  repositoryCompose_{{ $id }}:
    name: Repo image tag
    kind: yaml
    sourceid: repositoryTag_{{ $id }}
    transformers:
      - addprefix: "{{ $repo_image }}:"
    spec:
      file: {{ .acs.compose_target }}
      key: >-
        {{ .acs.compose_key }}
  {{- end }}
  repositoryValues_{{ $id }}:
    name: Repo image tag
    kind: yaml
    sourceid: repositoryTag_{{ $id }}
    spec:
      file: {{ .acs.helm_target }}
      key: >-
        {{ .acs.helm_key }}
  {{- if index . "acs" "helm_update_appVersion" }}
  repositoryAppVersion_{{ $id }}:
    name: Repo appVersion in Chart.yaml
    kind: yaml
    sourceid: repositoryTag_{{ $id }}
    spec:
      file: {{ osDir .acs.helm_target }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- if index . "search" }}
  {{- if and .search.compose_key .search.compose_target }}
  searchCompose_{{ $id }}:
    name: search image tag
    kind: yaml
    sourceid: searchTag_{{ $id }}
    transformers:
      - addprefix: "{{ $search_image }}:"
    spec:
      file: {{ .search.compose_target }}
      key: >-
        {{ .search.compose_key }}
  {{- end }}
  {{- $target_search_helm := .search.helm_target}}
  {{- if and $target_search_helm .search.helm_key }}
  searchValues_{{ $id }}:
    name: search image tag
    kind: yaml
    sourceid: searchTag_{{ $id }}
    spec:
      file: {{ $target_search_helm }}
      key: >-
        {{ .search.helm_key }}
  {{- end }}
  {{- range $key, $path := .search.helm_keys }}
  searchValues{{ $key }}_{{ $id }}:
    name: search image tag
    kind: yaml
    sourceid: searchTag_{{ $id }}
    spec:
      file: {{ $target_search_helm }}
      key: >-
        {{ $path }}
  {{- end }}
  {{- if index . "search" "helm_update_appVersion" }}
  searchAppVersion_{{ $id }}:
    name: Search appVersion in Chart.yaml
    kind: yaml
    sourceid: searchTag_{{ $id }}
    spec:
      file: {{ osDir $target_search_helm }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- if index . "search-enterprise" }}
  {{- $target_searchEntCompose := index . "search-enterprise" "compose_target" }}
  {{- if $target_searchEntCompose }}
  {{- range $index, $key := index . "search-enterprise" "compose_keys" }}
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
  {{- if index . "search-enterprise" "helm_target" }}
  {{- $target_searchEnt := index . "search-enterprise" "helm_target" }}
  searchEnterpriseReindexingValues_{{ $id }}:
    name: Search Enterprise image tag
    kind: yaml
    sourceid: searchEnterpriseTag_{{ $id }}
    spec:
      file: {{ $target_searchEnt }}
      key: {{ index . "search-enterprise" "helm_keys" "Reindexing" }}
  {{- range $key, $value := index . "search-enterprise" "helm_keys" "Liveindexing" }}
  searchEnterprise{{ $key }}Values_{{ $id }}:
    name: Search Enterprise image tag
    kind: yaml
    sourceid: searchEnterpriseTag_{{ $id }}
    spec:
      file: {{ $target_searchEnt }}
      key: {{ $value }}
  {{- end }}
  {{- if index . "search-enterprise" "helm_update_appVersion" }}
  searchEnterpriseAppVersion_{{ $id }}:
    name: Search Enterprise appVersion in Chart.yaml
    kind: yaml
    sourceid: searchEnterpriseTag_{{ $id }}
    spec:
      file: {{ osDir $target_searchEnt }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- end }}
  {{- if index . "share" }}
  {{- if and .share.compose_key .share.compose_target }}
  shareCompose_{{ $id }}:
    name: Share image tag
    kind: yaml
    sourceid: shareTag_{{ $id }}
    transformers:
      - addprefix: "{{ $share_image }}:"
    spec:
      file: {{ .share.compose_target }}
      key: >-
        {{ .share.compose_key }}
  {{- end }}
  shareValues_{{ $id }}:
    name: Share image tag
    kind: yaml
    sourceid: shareTag_{{ $id }}
    spec:
      file: {{ .share.helm_target }}
      key: >-
        {{ .share.helm_key }}
  {{- if index . "share" "helm_update_appVersion" }}
  shareAppVersion_{{ $id }}:
    name: Share appVersion in Chart.yaml
    kind: yaml
    sourceid: shareTag_{{ $id }}
    spec:
      file: {{ osDir .share.helm_target }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- if index . "onedrive" }}
  onedriveValues_{{ $id }}:
    name: Onedrive image tag
    kind: yaml
    sourceid: onedriveTag_{{ $id }}
    spec:
      file: {{ .onedrive.helm_target }}
      key: >-
        {{ .onedrive.helm_key }}
  {{- if index . "onedrive" "helm_update_appVersion" }}
  onedriveAppVersion_{{ $id }}:
    name: Onedrive appVersion in Chart.yaml
    kind: yaml
    sourceid: onedriveTag_{{ $id }}
    spec:
      file: {{ osDir .onedrive.helm_target }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- if index . "msteams" }}
  msteamsValues_{{ $id }}:
    name: MS Teams image tag
    kind: yaml
    sourceid: msteamsTag_{{ $id }}
    spec:
      file: {{ .msteams.helm_target }}
      key: >-
        {{ .msteams.helm_key }}
  {{- if index . "msteams" "helm_update_appVersion" }}
  msteamsAppVersion_{{ $id }}:
    name: MS Teams appVersion in Chart.yaml
    kind: yaml
    sourceid: msteamsTag_{{ $id }}
    spec:
      file: {{ osDir .msteams.helm_target }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- if index . "intelligence" }}
  intelligenceValues_{{ $id }}:
    name: Alfresco Intelligence image tag
    kind: yaml
    sourceid: intelligenceTag_{{ $id }}
    spec:
      file: {{ .intelligence.helm_target }}
      key: >-
        {{ .intelligence.helm_key }}
  {{- if index . "intelligence" "helm_update_appVersion" }}
  intelligenceAppVersion_{{ $id }}:
    name: Alfresco Intelligence appVersion in Chart.yaml
    kind: yaml
    sourceid: intelligenceTag_{{ $id }}
    spec:
      file: {{ osDir .intelligence.helm_target }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- if index . "trouter" }}
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
  {{- end }}
  trouterValues_{{ $id }}:
    name: Alfresco Transform Router image tag
    kind: yaml
    sourceid: trouterTag_{{ $id }}
    spec:
      file: {{ .trouter.helm_target }}
      key: >-
        {{ .trouter.helm_key }}
  {{- if index . "trouter" "helm_update_appVersion" }}
  trouterAppVersion_{{ $id }}:
    name: Alfresco Transform Router appVersion in Chart.yaml
    kind: yaml
    sourceid: trouterTag_{{ $id }}
    spec:
      file: {{ osDir .trouter.helm_target }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- if index . "sfs" }}
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
  {{- end }}
  sfsValues_{{ $id }}:
    name: Alfresco Shared Filestore image tag
    kind: yaml
    sourceid: sfsTag_{{ $id }}
    spec:
      file: {{ .sfs.helm_target }}
      key: >-
        {{ .sfs.helm_key }}
  {{- end }}
  {{- if index . "tengine-aio" }}
  tengine-aioCompose_{{ $id }}:
    name: Alfresco All-In-One Transform Engine image tag
    kind: yaml
    sourceid: tengine-aioTag_{{ $id }}
    transformers:
      - addprefix: "alfresco/alfresco-transform-core-aio:"
    spec:
      file: {{ index . "tengine-aio" "compose_target" }}
      key: >-
        {{ index . "tengine-aio" "compose_key" }}
  {{- end }}
  {{- if index . "tengine-misc" }}
  tengine-miscValues_{{ $id }}:
    name: Alfresco misc Transform Engine image tag
    kind: yaml
    sourceid: tengine-miscTag_{{ $id }}
    spec:
      file: {{ index . "tengine-misc" "helm_target" }}
      key: >-
        {{ index . "tengine-misc" "helm_key" }}
  {{- end }}
  {{- if index . "tengine-im" }}
  tengine-imValues_{{ $id }}:
    name: Alfresco ImageMagick Transform Engine image tag
    kind: yaml
    sourceid: tengine-imTag_{{ $id }}
    spec:
      file: {{ index . "tengine-im" "helm_target" }}
      key: >-
        {{ index . "tengine-im" "helm_key" }}
  {{- end }}
  {{- if index . "tengine-lo" }}
  tengine-loValues_{{ $id }}:
    name: Alfresco LibreOffice Transform Engine image tag
    kind: yaml
    sourceid: tengine-loTag_{{ $id }}
    spec:
      file: {{ index . "tengine-lo" "helm_target" }}
      key: >-
        {{ index . "tengine-lo" "helm_key" }}
  {{- end }}
  {{- if index . "tengine-pdf" }}
  tengine-pdfValues_{{ $id }}:
    name: Alfresco PDF Transform Engine image tag
    kind: yaml
    sourceid: tengine-pdfTag_{{ $id }}
    spec:
      file: {{ index . "tengine-pdf" "helm_target" }}
      key: >-
        {{ index . "tengine-pdf" "helm_key" }}
  {{- end }}
  {{- if index . "tengine-tika" }}
  tengine-tikaValues_{{ $id }}:
    name: Alfresco tika Transform Engine image tag
    kind: yaml
    sourceid: tengine-tikaTag_{{ $id }}
    spec:
      file: {{ index . "tengine-tika" "helm_target" }}
      key: >-
        {{ index . "tengine-tika" "helm_key" }}
  {{- end }}
  {{- if index . "sync" }}
  {{- if and .sync.compose_target .search.compose_key }}
  syncCompose_{{ $id }}:
    name: Sync image tag
    kind: yaml
    sourceid: syncTag_{{ $id }}
    transformers:
      - addprefix: "quay.io/alfresco/service-sync:"
    spec:
      file: {{ .sync.compose_target }}
      key: >-
        {{ .sync.compose_key }}
  {{- end }}
  syncValues_{{ $id }}:
    name: Sync image tag
    kind: yaml
    sourceid: syncTag_{{ $id }}
    spec:
      file: {{ .sync.helm_target }}
      key: >-
        {{ .sync.helm_key }}
  {{- if index . "sync" "helm_update_appVersion" }}
  syncAppVersion_{{ $id }}:
    name: Sync appVersion in Chart.yaml
    kind: yaml
    sourceid: syncTag_{{ $id }}
    spec:
      file: {{ osDir .sync.helm_target }}/Chart.yaml
      key: .appVersion
  {{- end }}
  {{- end }}
  {{- end }}
