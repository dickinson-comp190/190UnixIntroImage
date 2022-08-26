#!/bin/bash

# Enable root to run gui applications in x.
# This is launched by the xhost.desktop file,
# which is put in place by the Dockerfile.
xhost +si:localuser:root
