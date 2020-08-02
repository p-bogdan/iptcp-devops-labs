# Install Stackdriver logging agent
#!/bin/bash
cd /tmp
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
sudo bash install-logging-agent.sh

# Install or update needed software
apt-get update

apt-get install -yq git supervisor virtualenv python3-virtualenv wget python3-pip libffi-dev libssl-dev

pip3 install --upgrade pip virtualenv

# Account to own server process
useradd -m -d /home/pythonapp pythonapp

#Install the proxy client on your local machine
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy

#Make the proxy executable: bookshelf-app-template
chmod +x cloud_sql_proxy

#Copy credentials inside a vm

export DEVSHELL_PROJECT_ID=`gcloud config get-value project`
export connection_name=`gcloud sql instances list --format='value(connectionName)' --filter=europe-west1`
export instance_name=`gcloud sql instances list --format='value(name)' --filter=europe-west1`

#Connect cloud sql proxy to the instance

./tmp/cloud_sql_proxy -instances=$connection_name=tcp:3306 &

# Fetch source codez
export HOME=/root

sudo git clone -b steps https://github.com/ciscoios/getting-started-python.git /opt/app

sed -i "s/^PROJECT_ID .*$/PROJECT_ID = '$DEVSHELL_PROJECT_ID'/" /opt/app/7-gce/config.py
#Setup CLOUDSQL_PASSWORD
sed -i "s/^CLOUDSQL_PASSWORD .*$/CLOUDSQL_PASSWORD = 'devops2020'/" /opt/app/7-gce/config.py
#Setup CLOUDSQL_CONNECTION_NAME
sed -i "s/^CLOUDSQL_CONNECTION_NAME .*$/CLOUDSQL_CONNECTION_NAME = '$connection_name'/" /opt/app/7-gce/config.py
#Setup CLOUD_SQL_DATABASE
#sed -i "s/^CLOUDSQL_DATABASE .*$/CLOUDSQL_DATABASE = 'bookshelf'/" /opt/app/7-gce/config.py

#Setup CLOUD_STORAGE_BUCKET
sed -i "s/^CLOUD_STORAGE_BUCKET .*$/CLOUD_STORAGE_BUCKET = 'gcp-lab-training-bucket'/" /opt/app/7-gce/config.py

#Setup data backend
sed -i "s/^DATA_BACKEND .*$/DATA_BACKEND = 'cloudsql'/" /opt/app/7-gce/config.py

# Python environment setup

sudo virtualenv -p python3 /opt/app/7-gce/env

. /opt/app/7-gce/env/bin/activate

pip3 install -r /opt/app/7-gce/requirements.txt

#Initialize application tables in database
python3 /opt/app/7-gce/bookshelf/model_cloudsql.py

# Set ownership to newly created account
sudo chown -R pythonapp:pythonapp /opt/app

sudo cat >/etc/supervisor/conf.d/python-app.conf << EOF
[program:pythonapp]
directory=/opt/app/7-gce
command=/opt/app/7-gce/env/bin/honcho start -f /opt/app/7-gce/procfile worker bookshelf
autostart=true
autorestart=true
user=pythonapp
# Environment variables ensure that the application runs inside of the
# configured virtualenv.
environment=VIRTUAL_ENV="/opt/app/7-gce/env",PATH="/opt/app/7-gce/env/bin",\
    HOME="/home/pythonapp",USER="pythonapp"
stdout_logfile=syslog
stderr_logfile=syslog
EOF

sudo supervisorctl reread
sudo supervisorctl update
