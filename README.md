# kubjavaex
Example Tomcat based app with AppDynamics Java agent installed.

## This example shows how to add an AppDynamics Java agent to a Java Kubernetes container

This example uses the standard tomcat:8.0 image

Inside Docker, the command to run this would be:

docker run -it --rm -p 8888:8080 tomcat:8.0

Servlet sample pages can be browsed from: http://localhost:8888/examples/servlets/

This example uses the following features:
1. AppAgent included from docker file
2. Uses kubernetes API to set unique_host_id to be equal to the Node ID (This will then match the Node ID used with the Machine Agent)
3. Uses environment variables defined in the .yaml file to start the application

Todo items:
1. Use Kubernetes configmaps for controller-info.xml http://kubernetes.io/docs/user-guide/configmap/
2. Use Kubernetes secrets to store access key or API Key http://kubernetes.io/docs/user-guide/secrets/
3. Use Kubernetes volumes for agent binaries
--1. Create volumes for log files

## Steps to get this running

### Create Docker Image

Clone this repository, and create a docker image.
