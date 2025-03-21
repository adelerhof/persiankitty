#!/bin/bash

# set -x
#############################################################
# CREDENTIALS_FILE should contain the following variables:  #
# GH_TOKEN= token for github                                #
# HOMEDIR_GIT= locaction where repos will be cloned         #
#############################################################

# Set some variables
CREDENTIALS_FILE="${HOME}/adelerhof.eu/variables/credentials.gpg"
REPO_LIST='git@github.com:adelerhof/kitty.git'

# Evaluate the content of credentials.gpg for usernames, passwords & tokens
eval "$(gpg -d ${CREDENTIALS_FILE} 2>/dev/null)"

function checkout_code {

[ -d $HOMEDIR_GIT ] || /bin/mkdir -p $HOMEDIR_GIT
pushd ${HOMEDIR_GIT}
# Loop over the repos of appfactory
for I in ${REPO_LIST}
do
	# Determine the directory of the cloned repo
	DIR=$(echo $I |cut -d\/ -f 2- | sed 's/.git$//')
	echo "${I} ${DIR}"

	# Check or the directory exists and is not a sybolic link
	if [ -d ${DIR} -a  ! -h ${DIR} ]
	then
		# Update the contect of the directory
		pushd ${DIR}
		git checkout ${ENVIRONMENT}
		git pull
		git submodule sync --recursive
		git submodule foreach git checkout master
		git submodule foreach git pull origin master
		popd
	else
		# Delete the symbolid link (when it's there) and make a fresh clone
	    rm -f ${DIR}
		git clone --recursive $I
	fi
	echo
done
popd
}

function build_image {

  TAG=$(date +%Y%m%d%H%M%S)
  # Build the Docker image date
  docker build . --file Dockerfile --tag ghcr.io/adelerhof/kitty:${TAG}
  docker build . --file Dockerfile --tag ghcr.io/adelerhof/kitty:latest
  # docker build . --file Dockerfile --tag harbor.adelerhof.eu/kitty/kitty:${TAG}
  # docker build . --file Dockerfile --tag harbor.adelerhof.eu/kitty/kitty:latest

}

function push_image {

  # Push the Docker image date
  docker push ghcr.io/adelerhof/kitty:${TAG}
  docker push ghcr.io/adelerhof/kitty:latest
  # docker push harbor.adelerhof.eu/kitty/kitty:${TAG}
  # docker push harbor.adelerhof.eu/kitty/kitty:latest

}

function cleanup {

  # Remove the Docker images locally
  docker rmi -f ghcr.io/adelerhof/kitty:${TAG}
  docker rmi -f ghcr.io/adelerhof/kitty:latest
  # docker rmi -f harbor.adelerhof.eu/kitty/kitty:${TAG}
  # docker rmi -f harbor.adelerhof.eu/kitty/kitty:latest

}

function scan_code {

  SECURE_API_TOKEN=$SECURE_API_TOKEN $HOMEDIR_GIT/sysdig/sysdig-cli-scanner --apiurl $SYSDIG_API_URL ghcr.io/adelerhof/kitty:${TAG}

}

function deploy_prd {

	ENVIRONMENT=main

	checkout_code
	build_image
	push_image
  scan_code
	# cleanup

}

# Script options
case $1 in
        deploy_prd)
        $1
        ;;
        *)
       echo $"Usage : $0 {deploy_prd}"
       exit 1
       ;;
esac
