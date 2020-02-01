## Provision AWS infrastructure on layers

This code helps to provision the cloud infrastructure organized on layers using terraform.

Terraform still has some limitations in regard with module dependencies when contructing resources graphs, so a good strategy is to use a glue automation like the one implemented with *GNU/make* as herein.

At the moment only a network later was worth to be demoed here with one VPC that can be configured through variables.

A complex application deployment can be automated for instance into multiple layers like:
* network (vpc1, vpc2, ..., peering, dns)
* middleware (db instances, cache)
* backend (processing instances, queue, cache, auth)
* frontend (cloudfront, application load balancers)

In any layer on glue side (makefile in this case) you can use `terraform output` command in order to get configuration data from a below layer.
For instance ```terraform output vpc_id``` run in network folder will output the VPC id from the network layer and we can programatically configure resources in an upper layer.


### How to provision the infrastructure

You can run the following commands are relevant:

```make all # provisions the entire infrastructure```

```make cleanup # destroys everything```

```make network # into network folder```


**Important note:** In top level makefile you must setup the destruction of the infra layers in the reverse order of provisioning them.

### Special notes:

1. This code is based on the work of the guys at fpco from here:
https://github.com/fpco/terraform-aws-foundation which I recommend viewing as it's useful. I needed something very quick to provision a decent VPC and some other infrastructure above.
2. What I did extra was to create a superior VPC implementation, fix some bugs, and test the deployment manually.
3. On future I/or anyone else who might need, you can create one big VPC module encapsulating everything network related in order to add more isolation and flexibility to provision multiple VPCs in one or multiple regions.
