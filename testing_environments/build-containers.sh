# Creates docker containers for each supported Linux distribution

if [ -z "$1" ]
  then
    echo "Argument should be path to local repo."
    exit 1
fi

if [ $2='--no-cache' ]; then
    arg_no_cache='--no-cache'
else
    arg_no_cache=''
fi

# Exit script if environment variables are unset
if [[ -z "${MSSQL_CLI_SERVER}" || -z "${MSSQL_CLI_DATABASE}" || \
    -z "${MSSQL_CLI_USER}" || -z "${MSSQL_CLI_PASSWORD}" ]]; then
    echo "Environment variables need to be set for server, database, user, and password."
    exit 1
fi

local_repo=$1

for dir in $local_repo/Linux/*; do
    dist_name=${dir##*/}
    tag_name=mssqlcli:$dist_name

    echo "BUILDING CONTAINER FOR: $dist_name\n"
    
    # build container
    docker build \
        --build-arg MSSQL_CLI_SERVER=${MSSQL_CLI_SERVER} \
        --build-arg MSSQL_CLI_DATABASE=${MSSQL_CLI_DATABASE} \
        --build-arg MSSQL_CLI_USER=${MSSQL_CLI_USER} \
        --build-arg MSSQL_CLI_PASSWORD=${MSSQL_CLI_PASSWORD} \
        -t $tag_name -f $dir/Dockerfile . $arg_no_cache

    echo "\n\n"
done
