#!/bin/bash

NAME=$1

    echo "$NAME is a MULTI file"
    echo "::::::::::::::FINDING::::::::::::::::"
    find ~/darter/f5_untar/${NAME} -type f -exec mv -t ~/darter/multif5/${NAME} {} +
    echo "::::::::::::::CONVERTING:::::::::::::"
    sleep 10
    pod5 ~/darter/multif5/${NAME} --output /mnt/d/SGNEX/p5/${NAME}.pod5