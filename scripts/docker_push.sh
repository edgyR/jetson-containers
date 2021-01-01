#!/usr/bin/env bash

# check the parameters
if [ ${#1} -lt 1 ] || [ ${#2} -lt 1 ]
then
  echo "You need to specify two paramters:"
  echo "1. what to push - 'pytorch', 'tensorflow', 'ml' or 'all';"
  echo "2. where to push it - '<registry-url>/<account>'."
  echo ""
  echo "Example: './scripts/docker_push.sh pytorch docker.io/edgyr'"
  echo "There are no defaults. You need to be logged into the"
  echo "destination registry with push access."
  exit -20
fi

CONTAINERS=$1
DESTINATION=$2

source scripts/l4t_version.sh

push_retag() 
{
	local src_tag=$1
	local dst_tag=$2
	
	sudo docker rmi $DESTINATION/$dst_tag
	sudo docker tag $src_tag $DESTINATION/$dst_tag
	
	echo "pushing container $src_tag => $DESTINATION/$dst_tag"
	sudo docker push $DESTINATION/$dst_tag
	echo "done pushing $DESTINATION/$dst_tag"
}

push() 
{
	push_retag $1 $1
}

if [[ "$CONTAINERS" == "pytorch" || "$CONTAINERS" == "all" ]]; then
	#push "l4t-pytorch:r$L4T_VERSION-pth1.2-py3"
	#push "l4t-pytorch:r$L4T_VERSION-pth1.3-py3"
	#push "l4t-pytorch:r$L4T_VERSION-pth1.4-py3"
	#push "l4t-pytorch:r$L4T_VERSION-pth1.5-py3"
	push "l4t-pytorch:r$L4T_VERSION-pth1.6-py3"
	push "l4t-pytorch:r$L4T_VERSION-pth1.7-py3"
fi

if [[ "$CONTAINERS" == "tensorflow" || "$CONTAINERS" == "all" ]]; then
	push "l4t-tensorflow:r$L4T_VERSION-tf1.15-py3"
	push "l4t-tensorflow:r$L4T_VERSION-tf2.3-py3"
fi

if [[ "$CONTAINERS" == "ml" || "$CONTAINERS" == "all" ]]; then
	push "l4t-ml:r$L4T_VERSION-py3"
fi
