#!/bin/bash

var="this is current shell variable"

echo "running the following shell and: $var"

echo "process id is : $$"

source other.sh

echo "process id is : $$"
echo "running the following shell and: $var"