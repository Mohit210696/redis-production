#!/usr/bin/env python3
import json
import subprocess

tf_output = subprocess.check_output(
    ["terraform", "output", "-json"],
    cwd="../terraform"
)

data = json.loads(tf_output)

redis_ips = data["redis_private_ips"]["value"]
bastion_ip = data["bastion_private_ip"]["value"]

inventory = {
    "all": {
        "children": ["redis", "bastion"]
    },
    "redis": {
        "hosts": []
    },
    "bastion": {
        "hosts": ["bastion"]
    },
    "_meta": {
        "hostvars": {
            "bastion": {
                "ansible_host": bastion_ip,
                "ansible_user": "ubuntu",
            }
        }
    }
}

for i, ip in enumerate(redis_ips, start=1):
    host = f"redis-{i}"
    inventory["redis"]["hosts"].append(host)
    inventory["_meta"]["hostvars"][host] = {
        "ansible_host": ip,
        "ansible_user": "ubuntu",
        "ansible_ssh_common_args": (
            f"-o ProxyCommand=\"ssh -W %h:%p ubuntu@{bastion_ip}\""
        )
    }

print(json.dumps(inventory, indent=2))

