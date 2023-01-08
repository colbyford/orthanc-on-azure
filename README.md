# Orthanc on Azure

The template repository deploys all the required Azure services to run the Orthanc DICOM viewer on Azure.


This uses a base Orthanc Docker image from the Osimis team, which is then customized with environment variables to connect to the backend Azure resources.


## Docker Build Steps

The Docker image will be built with environment variables and will need to be pushed to the Azure Container Registry.

## Terraform Steps
