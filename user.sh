#!/bin/bash

source ./common.sh
root_verification
app_name=user

nodejs_setup
app_setup
systemd_setup
print_time