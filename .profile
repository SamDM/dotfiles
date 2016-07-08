# If there is anything that sources the `.xprofile` file the code here will log what
# it was.
#
# i3 does not seem to source this file
LOG=$(mktemp -t .profile_LOG.XXXXXXXXXX)
echo "-----" >>$LOG
echo "Caller: $0" >>$LOG
echo "DESKTOP_SESSION: $DESKTOP_SESSION" >>$LOG
echo "GDMSESSION: $GDMSESSION" >>$LOG
