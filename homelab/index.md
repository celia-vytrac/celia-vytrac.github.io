# Documentation for my Homelab

## Network Topology

## Server Specifications

#### Physical Hardware

| hostname | server | operating system | CPU | RAM | disks |
| -------- | ------ | ---------------- | --- | --- | ----- |
|  prox01  | HP Proliant DL 380 g8 | proxmox 6.1-1 | 12 core Intel Xeon CPU E5649 @ 2.53GHz x 2 | 16 GB @ XXX hz | 8 x 128 GB SAS raid 50 |

#### proxmox VMs

| hostname | purpose | disk | ram | cores |
| -------- | ------- | ---- | --- | ----- |
| psql01   | postgres server      | 128 GB | 1 GB | 1 |
| ctrl01   | unifi controller     | 16 GB | 512 MB | 1 |
| ids01    | intrusion detection system | 32 GB | 512 MB | 1 |
