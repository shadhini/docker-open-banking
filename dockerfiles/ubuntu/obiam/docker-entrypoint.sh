#!/bin/sh
# ------------------------------------------------------------------------
# Copyright 2019 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

set -e

# volume mounts
config_volume=${WORKING_DIRECTORY}/wso2-config-volume
artifact_volume=${WORKING_DIRECTORY}/wso2-artifact-volume

#directories
WEBAPPS_DIR=${WSO2_SERVER_HOME}/repository/deployment/server/webapps

# check if the WSO2 non-root user home exists
test ! -d ${WORKING_DIRECTORY} && echo "WSO2 Docker non-root user home does not exist" && exit 1

# check if the WSO2 product home exists
test ! -d ${WSO2_SERVER_HOME} && echo "WSO2 Docker product home does not exist" && exit 1

# extract webapps that require overriding configurations
unzip -o ${WEBAPPS_DIR}/consentmgr.war -d ${WEBAPPS_DIR}/consentmgr
unzip -o ${WEBAPPS_DIR}/ob#authenticationendpoint.war -d ${WEBAPPS_DIR}/ob#authenticationendpoint

# copy any configuration changes mounted to config_volume
test -d ${config_volume} && [ "$(ls -A ${config_volume})" ] && cp -RL ${config_volume}/* ${WSO2_SERVER_HOME}/
# copy any artifact changes mounted to artifact_volume
test -d ${artifact_volume} && [ "$(ls -A ${artifact_volume})" ] && cp -RL ${artifact_volume}/* ${WSO2_SERVER_HOME}/

# start WSO2 Carbon server
sh ${WSO2_SERVER_HOME}/bin/wso2server.sh "$@"
