# persiankitty
persiankitty demo

## Steps for github actions (random notes)

- When creating pull request do tests (docker build, infra-test)
- When merge to master create new release / tag (fix = +0.0.1, feature = +0.1, major = +1 )
- When new tag build docker image with same docker tag and push to packages

## Tagging new version

Build stage is without github tag docker image tag is `SHA_code` and `scan`.

When merging to master a tag for github is created / updated. By default it's updated as `patch` when the tag needs to be updated at a specific version use the `#minor`, `#major` or `#patch` in the commit message for the PR.

Based on this new github tag a package / docker-image will be created with the same tag.


az container create --resource-group Persian-kitty --name mycontainer \
    --image nginx:alpine --dns-name-label myapplication-staging


az container create --resource-group Persian-kitty --name persiankitty030 --image ghcr.io/adelerhof/persiankitty:0.3.0 --dns-name-label persiankitty --ports 80

az container show --resource-group Persian-kitty --name persiankitty030 --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" --out table

az container logs --resource-group Persian-kitty --name persiankitty030

az container delete --name persiankitty030 --resource-group Persian-kitty

az container list --resource-group Persian-kitty --output table

FROM ghcr.io/adelerhof/persiankitty:0.3.0

##

az container create --resource-group Persian-kitty --name hellowirld --image mcr.microsoft.com/azuredocs/aci-helloworld --dns-name-label hw7333 --ports 80
mcr.microsoft.com/azuredocs/aci-helloworld

https://docs.microsoft.com/en-us/azure/container-instances/container-instances-quickstart