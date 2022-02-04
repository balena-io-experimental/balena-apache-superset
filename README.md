# Apache Superset on balena

## Description

This project makes it easy to deploy Apache Superset on a balena device.
It also allows establishing an SSH tunnel to a bastion host in order to
access databases that are only accessible from within a local network.

## Getting Started

You can one-click-deploy this project to balena using the button below:

[![deploy button](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/balena-io-playground/balena-apache-superset&defaultDeviceType=genericx86-64-ext)

### Environment Variables

Apache Superset requires some information to create an initial admin user account.  These information are set
using environment variables 

| Name               | Purpose                                                                                 |
| ------------------ | --------------------------------------------------------------------------------------- |
| `ADMIN_USERNAME`   | **Required**. The admin username. More users can be added later.                        |
| `ADMIN_PASSWORD`   | **Required**. The password of the admin user.                                           |
| `ADMIN_EMAIL`      | **Required**. The email address of the admin user.                                      |
| `ADMIN_FIRSTNAME`  | The first name of the admin user. Defaults to ``.                                       |
| `ADMIN_LASTNAME`   | The last name of the admin user. Defaults to ``.                                        |
| `SSH_FORWARD_HOST` | The address where the port will be forwarded to.                                        |
| `SSH_FORWARD_PORT` | The port that would be forwarded to the target address.                                 |
| `SSH_HOST`         | The address of the bastion host.                                                        |
| `SSH_PORT`         | The SSH port of the bastion host.  Defaults to `22`.                                    |
| `SSH_KEY`          | The SSH key in encoded in base64 format.                                                |
|                    | The key will be used to establish the SSH tunnel. The key should not have a passphrase. |
| `SSH_USER`         | The username that will be used for establishing an SSH tunnel                           |

### SSH Port Forwarding

SSH port forwarding will be established if the following environment variables are set:
- `SSH_FORWARD_HOST`
- `SSH_FORWARD_PORT`
- `SSH_HOST`
- `SSH_KEY`
- `SSH_USER`

All of these environment variables should be provided for an SSH tunnel to be established.

The forwarded port can be accessed from Superset using the address `127.0.0.1`.
