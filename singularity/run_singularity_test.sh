#!/bin/bash

# See also https://www.rocker-project.org/use/singularity/

# Main parameters for the script with default values
PORT=${PORT:-8787}
USER=$(whoami)
PASSWORD=${PASSWORD:-notsafe}
TMPDIR=${TMPDIR:-tmp}
CONTAINER=$CONTAINER  # path to singularity container (will be automatically downloaded

# Set-up temporary paths
RSTUDIO_TMP="${TMPDIR}/$(echo -n $CONDA_PREFIX | md5sum | awk '{print $1}')"
mkdir -p $RSTUDIO_TMP/{run,var-lib-rstudio-server,local-share-rstudio}

echo "Starting rstudio service on port $PORT ..."
echo "Home is $HOME"
echo "Conda prefix is $CONDA_PREFIX"
echo "R bin is $R_BIN"

singularity shell \
	--bind $RSTUDIO_TMP/run:/run \
	--bind $RSTUDIO_TMP/var-lib-rstudio-server:/var/lib/rstudio-server \
	--bind /sys/fs/cgroup/:/sys/fs/cgroup/:ro \
	--bind database.conf:/etc/rstudio/database.conf \
	--bind rsession.conf:/etc/rstudio/rsession.conf \
	--bind $RSTUDIO_TMP/local-share-rstudio:/home/rstudio/.local/share/rstudio \
	--bind ${CONDA_PREFIX}:${CONDA_PREFIX} \
	--bind $HOME/.config/rstudio:/home/rstudio/.config/rstudio \
        `# add additional bind mount required for your use-case` \
	--bind /data/:/data/ \
	--env PASSWORD=$PASSWORD \
	--env PORT=$PORT \
	--env USER=$USER \
	$CONTAINER \



