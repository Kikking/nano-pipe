#!/bin/bash
var1="green"
var2="blue"
var3="yellow"

# Parse named arguments
while getopts L:A:C: flag
do
    case "${flag}" in
        L) var1=${OPTARG};;
        A) var2=${OPTARG};;
        C) var3=${OPTARG};;
    esac
done

# Access the variable value
echo "Var3: $var3"
# Access the variable values
echo "Var1: $var1"
echo "Var2: $var2"
echo "Var3: $var3"