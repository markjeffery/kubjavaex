# kubjavaex
Example Tomcat based app with AppDynamics Java agent installed.

## This example shows how to add an AppDynamics Java agent to a Java Kubernetes container

This example uses the standard tomcat:8.0 image

Inside Docker, the command to run this would be:

docker run -it --rm -p 8888:8080 tomcat:8.0

Servlet sample pages can be browsed from: http://localhost:8888/examples/servlets/

This example uses the following features:

* AppAgent included from docker file
* Uses kubernetes API to set unique_host_id to be equal to the Node ID (This will then match the Node ID used with the Machine Agent)
* Uses environment variables defined in the .yaml file to start the application

Todo items:

* Use Kubernetes configmaps for controller-info.xml http://kubernetes.io/docs/user-guide/configmap/
* Use Kubernetes secrets to store access key or API Key http://kubernetes.io/docs/user-guide/secrets/
* Use Kubernetes volumes for agent binaries
  * Create volumes for log files

## Steps to get this running

### Download AppServerAgent

From http://download.appdynamics.com, choose Java agent, and download the agent you want.

Create a directory /AppAgent, and extract it inside this directory.

If the extraction was done correctly, then the /AppAgent directory should contain javaagent.jar

### Create Docker Image

Clone this repository, and create a docker image.

For Google Repository:

docker build -t gcr.io/$PROJECT_ID/kubjavaex:latest .

gcloud docker push gcr.io/$PROJECT_ID/kubjavaex:latest

### Enter AppDynamics config into pod_kubjavaex.yaml

Edit pod_kubjavaex.yaml to place config values. Use https://docs.appdynamics.com/display/PRO42/Java+Agent+Configuration+Properties for guidance.
