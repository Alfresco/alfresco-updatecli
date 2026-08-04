# Repository guidance

This repository is the shared source of truth for **which Alfresco component versions are supported per ACS release line**, expressed as an [updatecli](https://www.updatecli.io/) manifest. Downstream deployment repos (e.g. `acs-deployment`, docker-compose installers) consume these files to automatically open PRs that bump image tags in their own compose/Helm files.

## Layout

- `deployments/uber-manifest.tpl` — Go-templated updatecli manifest. It is generic: it iterates over `.matrix` and, for each release line, emits updatecli `sources` (discover the latest matching version) and `targets` (write that version into a downstream file).
- `deployments/values/supported-matrix.yaml` — the version matrix consumed by the template. This is the file that changes most often.

## How the two files fit together

The matrix defines release lines (`next`, `current`, `25.N`, `23.N`, `community`), each with a short `id` (`next`, `current`, `25n`, `23n`, `com`) and a set of components with version constraints. Every source/target the template generates is suffixed with the line's `id` (e.g. `repositoryTag_current`, `shareValues_25n`), so the same component across different lines never collides.

`versionFilterKind` selects how a component's `version` is interpreted:
- `semver` — the `version` is a semver constraint (`~26`, `>=5.0.0-0`, `~5.3`).
- `regex` (the template default when unset) — `version` + the component's `pattern` are concatenated into `^<version><pattern>$`. The `patterns:` anchors at the top of the matrix (`ga`, `ga_with_hotfixes`, `ga_activemq`, …) are the reusable regex fragments.
- `regex/semver` — a semver constraint plus a `regex` to pre-filter tags (used by `acs`/`share` in `next` to ignore milestone tags like `-Mx`).

The matrix leans heavily on YAML anchors/aliases (`&name` / `*name`) to share a spec across release lines. When you change a shared spec, you change every line that aliases it — check the alias references before editing.

**Important:** the template's `targets` reference keys that are deliberately *not* present in this repo's matrix — `compose_target`, `compose_key`, `helm_target`, `helm_key`, `helm_keys`, `compose_keys`, `helm_update_appVersion`. Those are supplied by the **consuming** repo's own values file, which is merged on top of `supported-matrix.yaml` at run time. In this repo the matrix only declares version discovery (`sources`); target blocks stay inert because those keys are absent. Do not add them here.

## Registry auth and SCMs

Most images live on `quay.io` and the template injects `QUAY_USERNAME`/`QUAY_PASSWORD` — it does this only when the image string starts with `quay.io/` (community images on `docker.io` need no auth, so a component overriding `image:` to a docker.io path skips auth automatically). Search Enterprise's source (`searchEnterpriseTag_*`) polls the `quay.io/alfresco/alfresco-elasticsearch-reindexing` image tags the same way — that image and the `search-enterprise` compose/Helm target images (`quay.io/alfresco/alfresco-elasticsearch-{reindexing,live-indexing,...}`) are all built and pushed with the same tag in the same CI release job of `Alfresco/alfresco-elasticsearch-connector`, so any one of them is a valid stand-in for version discovery. CIC Connector is the remaining exception: it is resolved from **git tags** of `Alfresco/alfresco-cic-connector` via the `cicConnector` GitHub SCM, which needs `UPDATECLI_GITHUB_TOKEN`.

## Validating changes

There is no build. CI runs pre-commit only. Before committing:

```
pre-commit run --all-files
```

This checks YAML validity plus the dependabot and GitHub-workflow JSON schemas. Because the matrix relies on anchors and the manifest is a Go template, a YAML edit that parses can still be logically wrong — reason through which release-line `id`s and which aliases an edit touches.

To exercise the manifest end-to-end you need updatecli, the env vars above, and a downstream values file supplying the target keys; that normally happens in the consuming repo's pipeline, not here.

## Editing the matrix

Adding or updating a component means editing `supported-matrix.yaml` and, if it is a brand-new component, adding matching `sources`/`targets` blocks to `uber-manifest.tpl`. Keep the component key identical across the matrix and the template (`index . "search-enterprise"` in the template maps to the `search-enterprise:` matrix key — hyphenated keys are accessed with `index`, dotted-name keys with `.foo`).
