# alfresco-updatecli

Shared source of truth for which Alfresco component versions are supported per ACS release line, expressed as an [updatecli](https://www.updatecli.io/) manifest. Downstream deployment repos consume `deployments/uber-manifest.tpl` and `deployments/values/supported-matrix.yaml` to automatically open PRs that bump image tags in their own compose/Helm files.

See `.github/copilot-instructions.md` for how the manifest and matrix fit together and how to edit them.

## Consumers

Repos in the `Alfresco` org known to consume this manifest:

- [acs-deployment](https://github.com/Alfresco/acs-deployment)
- [alfresco-ansible-deployment](https://github.com/Alfresco/alfresco-ansible-deployment)
- [alfresco-helm-charts](https://github.com/Alfresco/alfresco-helm-charts)
- [alfresco-dockerfiles-bakery](https://github.com/Alfresco/alfresco-dockerfiles-bakery)
- [alfresco-process-services-deployment](https://github.com/Alfresco/alfresco-process-services-deployment)
- [flux-alfresco-pipeline](https://github.com/Alfresco/flux-alfresco-pipeline)
