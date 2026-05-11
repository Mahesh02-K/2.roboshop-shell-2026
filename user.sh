#!/bin/bash

source ./common.sh
root_verification
app_name=user

app_setup
nodejs_setup
systemd_setup
print_time