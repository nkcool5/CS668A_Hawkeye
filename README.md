# CS668A: Practical Cyber Security For Cyber Practitioners Hawkeye Final Project

Directory Structure:
```
    ├── CS668A_Hawkeye_Group_Project_demo.mp4          # Demo video for final project
    ├── OS-Vulnerability                               # OS-Vulnerability script executes and gives the root access
    ├── README.md                                      # Readme file
    ├── audit_mitre.rules                              # auditd rule mapped with mitre attack matrix
    ├── createUser.py                                  # For SQL injection attack
    ├── presentation.pptx                              # Presentation for final project
    └── systemd1.sh                                    # Malicious script to create persistence as a service in the machine and exfilterate the data from the victim machine
```





> To Setup the entire project please follow the steps mentioned as follows:

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
 5. Plcae the `audit_mitre.rules` file provided in this repository in the directory `/etc/audit/rules.d/` 
 6. Step 3 and 4 helps the victim machine to monitor the security logs.
 
## Setup Attacker Machine (Kali OS)
Open three terminals or use `tmux` to split the terminal in three parts and execute the following commands:
```sh
* Terminal 1:
python3 -m pip install --user uploadserver
# for upload server where attacker collect the data from the victim
python3 -m uploadserver 8002

* Terminal 2:
# For downloading the malware to victim
python3 -m http.server 8001

* Terminal 3:
# for reverse shell from victim
nc.traditional -lvp 8080
```



