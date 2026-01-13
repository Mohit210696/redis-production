#!/usr/bin/env python3

import json
import subprocess
import sys

def terraform_output():
    try:
        result = subprocess.check_output(
            ["terraform", "output", "-json"],
            cwd="../terraform"
        )
        return json.loads(result)
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)

tf = terraform_output()

bastion_ip = tf["bastion_private_ip"]["value"]
redis_ips = tf["redis_private_ips"]["value"]

inventory = {
    "all": {
        "children": ["bastion", "redis"]
    },
    "bastion": {
        "hosts": ["bastion-1"]
    },
    "redis": {
        "hosts": []
    },
    "_meta": {
        "hostvars": {
            "bastion-1": {
                "ansible_host": bastion_ip,
                "ansible_user": "ubuntu"
            }
        }
    }
}

for i, ip in enumerate(redis_ips, start=1):
    hostname = f"redis-{i}"
    inventory["redis"]["hosts"].append(hostname)
    inventory["_meta"]["hostvars"][hostname] = {
        "ansible_host": ip,
        "ansible_user": "ubuntu",
        "ansible_ssh_common_args": (
            "-o StrictHostKeyChecking=no "
            "-o UserKnownHostsFile=/dev/null "
            "-o ProxyCommand=\"ssh "
            "-i /home/ubuntu/.ssh/redis.0788.pem "
            "-o StrictHostKeyChecking=no "
            "-o UserKnownHostsFile=/dev/null "
            "-W %h:%p ubuntu@{}\"".format(bastion_ip)
        )
    }

print(json.dumps(inventory, indent=2))

