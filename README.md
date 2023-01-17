# Orthanc on Azure

The template repository deploys all the required Azure services to run the Orthanc DICOM viewer on Azure.

This uses a base Orthanc Docker image from the Osimis team, which is then customized with environment variables to connect to the backend Azure resources.

![](img/screenshot.png)


## Terraform Steps

Coming soon...


## Docker Build Steps

The Docker image will be built with environment variables and will need to be pushed to the Azure Container Registry.

### Build Dockerfile

```sh
docker build -t <CONTAINERREGISTRY>.azurecr.io/orthanc-viewer-001:latest .
```

### Run Locally
```sh
docker run --name orthanc-viewer-001 -p 8042:8042 <CONTAINERREGISTRY>.azurecr.io/orthanc-viewer-001:latest
```


### Push Image to Azure Container Registry

```sh
az login
az acr login --name <CONTAINERREGISTRY>

docker push <CONTAINERREGISTRY>.azurecr.io/orthanc-viewer-001:latest
```

You will need to restart the Web App in Azure so that it can pull the newly pushed image.


