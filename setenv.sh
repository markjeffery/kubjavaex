export CATALINA_OPTS="$CATALINA_OPTS -javaagent:/AppAgent/javaagent.jar"
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.controller.hostName=$APPDYNAMICS_CONTROLLER_HOST_NAME"
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.controller.port=$APPDYNAMICS_CONTROLLER_PORT"
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.agent.applicationName=$APPDYNAMICS_AGENT_APPLICATION_NAME"
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.agent.tierName=$APPDYNAMICS_AGENT_TIER_NAME"
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.agent.nodeName=$HOSTNAME"
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.agent.accountName=$APPDYNAMICS_AGENT_ACCOUNT_NAME"
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.agent.accountAccessKey=$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY"
# Use kubernetes REST Call to find node name
KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
UNIQUE_HOST_ID=$(curl -sS --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt  -H "Authorization: Bearer $KUBE_TOKEN"       https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/default/pods/$HOSTNAME | grep nodeName | awk -F\" '{print $4}')
export CATALINA_OPTS="$CATALINA_OPTS -Dappdynamics.agent.uniqueHostId=$UNIQUE_HOST_ID"
