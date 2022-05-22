#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty

}

badinput2() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty
  question1
}

question1() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG - PGBlitz Installer ~ http://plex.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: DO NOT SELECT LOCAL SYSTEM for a REMOTE SERVER outside of your
network as in using Hetzner, Google GCE, WholeSale Internet & Etc! If you
do you, it will not work and you will have to uninstall it!

[1] Plex Remote System ~ OUTSIDE your LOCAL NETWORK (i.e 3rd Party)
[2] Plex Local System  ~ INSIDE  your LOCAL NETWORK (i.e Home)
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Type a Number | Press [ENTER]: ' typed </dev/tty
  echo ""
  if [ "$typed" == "1" ]; then
    echo remote >/var/plexguide/plex.server && question3
  elif [ "$typed" == "2" ]; then
    echo local >/var/plexguide/plex.server
  elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
    exit
  else badinput2; fi
}

# THIRD QUESTION
question3() {
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Remote Plex Server - Claim the Plex Server
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To Claim the Plex Server, visit https://www.plex.tv/claim/ and input the
code below! You have 5 minutes to do so!

If you are reinstalling plex with existing appdata press enter to skip 
this step as you won't need to claim it again.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Plex Server Claim Number | Press [ENTER]: ' typed </dev/tty
  echo $typed >/var/plexguide/plex.claim && break=on
}

# FUNCTIONS END ##############################################################

question1
mkdir -p /mnt/appdata/plexm
mkdir -p /mnt/appdata/plext
mkdir -p /mnt/appdata/plexe
mkdir -p /mnt/appdata/plexp
mkdir -p /mnt/dvr/TV
mkdir -p /mnt/dvr/Movies
ln -s /mnt/appdata/plexm/ /opt/appdata/plexm
chown -h ubuntu:ubuntu /opt/appdata/plexm
ln -s /mnt/appdata/plext/ /opt/appdata/plext
chown -h ubuntu:ubuntu /opt/appdata/plext
ln -s /mnt/appdata/plexe/ /opt/appdata/plexe
chown -h ubuntu:ubuntu /opt/appdata/plexe
ln -s /mnt/appdata/plexp/ /opt/appdata/plexp
chown -h ubuntu:ubuntu /opt/appdata/
chown -h ubuntu:ubuntu /mnt/dvr/TV
chown -h ubuntu:ubuntu /mnt/dvr/Movies


rclone copy /mnt/unionfs/plexguide/backup/gcp/plexe.tar /tmp/plexe.tar -P
tar -C /opt/appdata/plexe -xvf /tmp/plexe.tar
rm -rf /tmp/plexe.tar
chown -R 1000:1000 /opt/appdata/plexe
chmod -R 775 "/opt/appdata/plexe"
ansible-playbook /opt/communityapps/apps/plex/plexe.yml

rclone copy /mnt/unionfs/plexguide/backup/gcp/plexm.tar /tmp/plexm.tar -P
rclone copy /mnt/unionfs/plexguide/backup/gcp/plext.tar /tmp/plext.tar -P
rclone copy /mnt/unionfs/plexguide/backup/gcp/plexp.tar /tmp/plexp.tar -P

tar -C /opt/appdata/plexm -xvf /tmp/plexm.tar
tar -C /opt/appdata/plext -xvf /tmp/plext.tar
tar -C /opt/appdata/plexp -xvf /tmp/plexp.tar

rm -rf /tmp/plexm.tar
rm -rf /tmp/plext.tar
rm -rf /tmp/plexp.tar

chown -R 1000:1000 /opt/appdata/plexm
chmod -R 775 "/opt/appdata/plexm"
chown -R 1000:1000 /opt/appdata/plext
chmod -R 775 "/opt/appdata/plext"
chown -R 1000:1000 /opt/appdata/plexp
chmod -R 775 "/opt/appdata/plexp"

ansible-playbook /opt/communityapps/apps/plex/plexm.yml
ansible-playbook /opt/communityapps/apps/plex/plext.yml
ansible-playbook /opt/communityapps/apps/plex/plexp.yml