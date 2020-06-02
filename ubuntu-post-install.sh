#!/bin/bash
####################################################################
#
# Description:
#   I switch and use different linux distributions often enough
#	that I'm tired of manually getting it all configured afterward.
#
####################################################################
tabs 4
clear

TITLE="Automation is the best, and so are hyenas."

function main {
	echo_message header "Starting 'main' function"
	MAIN=$(eval `resize` && whiptail \
		--notags \
		--title "$TITLE" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Quit" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		'system_update'         'Perform system updates.' \
		'install_favs'          'Install applications.' \
		'install_favs_dev'      'Install development tools.' \
		'install_favs_utils'    'Install utilities.' \
		'install_gnome'         'Install GNOME software.' \
		'install_codecs'        'Install multimedia codecs.' \
		'install_fonts'         'Install additional fonts.' \
		'install_snap_apps'     'Install Snap applications.' \
		'install_flatpak_apps'  'Install Flatpak applications.' \
		'install_thirdparty'    'Install third-party applications.' \
		'setup_dotfiles'        'Configure dotfiles.' \
		'system_configure'      'Configure the system.' \
		'system_cleanup'        'Cleanup the system.' \
		3>&1 1>&2 2>&3)
	if [ $? = 0 ]; then
		echo_message header "Starting '$MAIN'..."
		$MAIN
	else
		quit
	fi
}

function quit {
	echo_message header "Starting 'quit' function"
	echo_message title "Exiting $TITLE..."
	if (whiptail --title "Quit" --yesno "Did you accidentally press quit, or did you mean it?" 8 56) then
		echo_message welcome 'Thanks for using!'
		exit 99
	else
		main
	fi
}

function import_functions {
	DIR="functions"
	for FUNCTION in $(dirname "$0")/$DIR/*; do
		if [[ -d $FUNCTION ]]; then
			continue
		elif [[ $FUNCTION == *.md ]]; then
			continue
		elif [[ -f $FUNCTION ]]; then
			. $FUNCTION
		fi
	done
}

import_functions
echo_message welcome "$TITLE"
system_checks
while :
do
	main
done