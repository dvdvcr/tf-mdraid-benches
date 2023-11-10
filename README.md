# what
This tool is intended to benchmark different block device and software raid configurations on ec2 instances.

# why
Discover new ways to meet a workload's iops and reliability requirements while optimizing resource use, *particularly in cases where the provisioned IOPS model has diminshing returns on cost savings*.

# why software raid on EC2?
mdadm has lesser-known options not covered in the example scripts provided. Certain workloads might be able to leverage them for cost, reliability, or performance.

# usage
Adjust the top-level variables.tf file.

benches_access specifies some global settings for the infra and benches_plan lets you specify what instances to spawn, what devices to attach, and what benchmarks to run.

variables.tf and the included scripts under /bin contain some basic examples.

variables.tf assumes there is a keypair configured with a public key that corresponds to a private key refrenced by privkey in the benches_plan. There is no need to add a private key to the keypair.

# benchmark notes
Some of the included examples use dd, hdparm, and fio but a better benchmark might involve running a representative workload and keeping an eye on things like iowait over time.

# future improvements
EFS support

# further reading
* https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm
* https://fio.readthedocs.io/en/latest/fio_doc.html
* https://discord.com/blog/how-discord-supercharges-network-disks-for-extreme-low-latency
