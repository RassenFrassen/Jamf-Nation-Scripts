#!/bin/sh
####################################################################################################
#
# Copyright (c) 2010, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################
#
# SUPPORT FOR THIS PROGRAM
#
#       This program is distributed "as is" by JAMF Software, LLC's Resource Kit team. For more
#       information or support for the Resource Kit, please utilize the following resources:
#
#               http://list.jamfsoftware.com/mailman/listinfo/resourcekit
#
#               http://www.jamfsoftware.com/support/resource-kit
#
#       Please reference our SLA for information regarding support of this application:
#
#               http://www.jamfsoftware.com/support/resource-kit-sla
#
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	disableAirport.sh -- Disable the airport drivers.
#
# SYNOPSIS
#	sudo disableAirport.sh
#	sudo disableAirport.sh <targetVolume> <computerName> <currentUsername>
#
# DESCRIPTION
#	This script disables the airport drivers, thereby disabling all functionality of the airport.
#	After running this script, the airport drivers will be moved to:
#
#		/Library/Application Support/JAMF/DisabledExtensions/
#
#	This way, the airport could be re-enabled in the future.  After running this script, the machine
#	will need to be rebooted for the settings to take effect if the script was run against a booted
#	target volume.
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.2
#
#	- Created by Nick Amundsen on August 6th, 2008
#	- Modified by Nick Amundsen on June 11th, 2009
#	- Modified by Nick Amundsen on January 21st, 2010
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUE FOR "targetVolume" IS SET HERE
targetVolume=""


# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 1 AND, IF SO, ASSIGN TO "USERNAME"
if [ "$1" != "" ] && [ "$targetVolume" == "" ];then
    targetVolume=$1
fi

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

OS=`/usr/bin/defaults read /System/Library/CoreServices/SystemVersion ProductVersion | awk '{print substr($1,1,4)}'`

echo "Disabling the Airport Drivers on target volume $targetVolume..."

if [ -d "$targetVolume/Library/Application Support/JAMF/DisabledExtensions/" ]; then
	if [[ "$OS" < "10.6" ]]; then
		#This extension doesn't exist in 10.6.
		/bin/mv "$targetVolume/System/Library/Extensions/AppleAir"* "$targetVolume/Library/Application Support/JAMF/DisabledExtensions/"
	fi
	/bin/mv "$targetVolume/System/Library/Extensions/IO80211Family"* "$targetVolume/Library/Application Support/JAMF/DisabledExtensions/"
else
	/bin/mkdir -p "$targetVolume/Library/Application Support/JAMF/DisabledExtensions/"
	/bin/mv "$targetVolume/System/Library/Extensions/IO80211Family"* "$targetVolume/Library/Application Support/JAMF/DisabledExtensions/"
	if [[ "$OS" < "10.6" ]]; then
		#This extension doesn't exist in 10.6.
		/bin/mv "$targetVolume/System/Library/Extensions/AppleAir"* "$targetVolume/Library/Application Support/JAMF/DisabledExtensions/"
	fi
fi

	