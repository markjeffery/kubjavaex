#!/bin/sh
set -e

# temporary directory for script-related files
tmpdir='/tmp/script'
mkdir -p $tmpdir
export tmpdir

# name of application (matches exactly) TODO: Take this from configpath
application=${APPDYNAMICS_AGENT_APPLICATION_NAME}
# name of node (matches exactly) TODO: Take this from configpath
target_node_name=${HOSTNAME}
# user@account:password TODO: Take this from secret
userstring='user1@customer1:welcome'
# controller host TODO: Take this from configpath
controller_host=${APPDYNAMICS_CONTROLLER_HOST_NAME}
# controller port TODO: Take this from configpath
controller_port=${APPDYNAMICS_CONTROLLER_PORT}

# get applications from controller as XML
applications=$(mktemp $tmpdir/applications-XXXXXXXXXX)
curl -s --user "$userstring" \
     "http://${controller_host}:${controller_port}/controller/rest/applications" \
     > "$applications"

# filter lines with application id
ids=$(mktemp $tmpdir/ids-XXXXXXXXX)
<"$applications" grep '^\s*<id>' | \
    sed -e 's#^\s*<id>\(.*\)</id>#\1#' \
        > "$ids"

# filter lines with application name
names=$(mktemp $tmpdir/names-XXXXXXXXX)
<"$applications" grep -i '^\s*<name>' | \
    sed -e 's#^\s*<name>\(.*\)</name>#\1#' \
        > "$names"

# get offset of application name
offset="$(grep -iFxn $application $names | cut -f1 -d:)"

if [ -z "$offset" ]; then
    echo "no application named '$application'"
    exit 1
fi
if [ "$(echo $offset | wc -l)" -gt 1 ]; then
    echo "$offset has multiple lines, multiple applications matched"
    exit 1
fi

# get nth line of ids, index of application
index=$(sed -e "${offset}q;d" $ids)

# fetch all nodes from application
nodes=$(mktemp $tmpdir/nodes-XXXXXXXXX)
curl -s --user "$userstring" \
     "http://${controller_host}:${controller_port}/controller/rest/applications/${index}/nodes" \
     > "$nodes"

# get node names
node_names=$(mktemp $tmpdir/node_names-XXXXXXXXX)
<"$nodes" grep '^\s*<name>' | \
    sed -e 's#^\s*<name>\(.*\)</name>#\1#' \
        > "$node_names"

# get node ids
node_ids=$(mktemp $tmpdir/node_ids-XXXXXXXXX)
<"$nodes" grep '^\s*<id>' | \
    sed -e 's#^\s*<id>\(.*\)</id>#\1#' \
        > "$node_ids"

# get the node_offset
# Mark Jeffery - remove -x as I seem to be getting -0 appended to node name
node_offset="$(grep -Fn $target_node_name $node_names | cut -f1 -d:)"

if [ -z "$node_offset" ]; then
    echo "$target_node_name does not match any nodenames"
    exit 1
fi
if [ "$(echo $node_offset | wc -l)" -gt 1 ]; then
    echo "$target_node_name matches more than one node."
    exit 1
fi

node_index=$(sed -e "${node_offset}q;d" $node_ids)

case "$1" in
    getId)
        echo $node_index
        ;;
    unregister)
        curl -s --user "$userstring" \
            --data '' \
            "http://${controller_host}:${controller_port}/controller/rest/mark-nodes-historical?application-component-node-ids=$node_index"
        curl -s --user "$userstring" \
            --data '' \
            "http://${controller_host}:${controller_port}/controller/rest/applications/${index}/events\?severity=INFO&summary=Node $node_names removed&eventtype=CUSTOM&customeventtype=kubernetes&node=$node_names&tier=${APPDYNAMICS_AGENT_TIER_NAME}"
        ;;
    *)
        echo "usage: $(basename $0) getId | unregister"
esac

