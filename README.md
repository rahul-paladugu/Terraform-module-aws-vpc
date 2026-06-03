# terraform-aws-vpc

A production-grade Terraform module for creating a full 3-tier AWS VPC (public / private / database) with optional high-availability NAT Gateways and VPC Flow Logs.

Designed to be reused across multiple projects and environments with a single variable file.

---

## Features

- **3-tier subnet model** — public (ALB/bastion), private (application), database (isolated)
- **Flexible NAT** — single NAT (cost-optimised) or one-per-AZ (HA for production)
- **NAT-optional** — set `enable_nat_gateway = false` for fully private / Transit Gateway networks
- **Database isolation** — database tier has no outbound internet route by default
- **DNS** — `enable_dns_hostnames` and `enable_dns_support` configurable
- **VPC Flow Logs** — CloudWatch or S3 destination, configurable retention
- **Consistent tagging** — `common_tags` merged with per-resource `Name` and `Tier` tags
- **Backwards-compatible outputs** — deprecated aliases maintained for existing callers

---

## Usage

### Production (per-AZ NAT, flow logs)

```hcl
module "vpc" {
  source = "git::https://github.com/rahul-paladugu/Terraform-module-aws-vpc.git?ref=v1.0.0"

  project     = "roboshop"
  environment = "prod"

  cidr_block            = "10.10.0.0/16"
  public_subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs  = ["10.10.11.0/24", "10.10.12.0/24"]
  database_subnet_cidrs = ["10.10.21.0/24", "10.10.22.0/24"]
  az_names              = ["us-east-1a", "us-east-1b"]

  enable_nat_gateway  = true
  single_nat_gateway  = false   # one NAT per AZ

  enable_flow_logs           = true
  flow_logs_destination_type = "cloud-watch-logs"
  flow_logs_retention_days   = 90

  common_tags = {
    Owner      = "platform-team"
    CostCenter = "engineering"
  }
}
```

### Staging (single shared NAT, no flow logs)

```hcl
module "vpc" {
  source = "git::https://github.com/rahul-paladugu/Terraform-module-aws-vpc.git?ref=v1.0.0"

  project     = "roboshop"
  environment = "staging"

  cidr_block            = "10.20.0.0/16"
  public_subnet_cidrs   = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnet_cidrs  = ["10.20.11.0/24", "10.20.12.0/24"]
  database_subnet_cidrs = ["10.20.21.0/24", "10.20.22.0/24"]
  az_names              = ["us-east-1a", "us-east-1b"]

  single_nat_gateway = true
}
```

### Fully private (no NAT)

```hcl
module "vpc" {
  source = "git::https://github.com/rahul-paladugu/Terraform-module-aws-vpc.git?ref=v1.0.0"

  project     = "payments"
  environment = "prod"

  cidr_block            = "10.30.0.0/16"
  public_subnet_cidrs   = ["10.30.1.0/24", "10.30.2.0/24"]
  private_subnet_cidrs  = ["10.30.11.0/24", "10.30.12.0/24"]
  database_subnet_cidrs = ["10.30.21.0/24", "10.30.22.0/24"]
  az_names              = ["us-east-1a", "us-east-1b"]

  enable_nat_gateway = false
}
```

---

## Requirements

| Name      | Version         |
|-----------|-----------------|
| terraform | >= 1.5.0        |
| aws       | >= 5.0, < 7.0   |

---

## Inputs

### Required

| Name | Type | Description |
|------|------|-------------|
| `project` | `string` | Project name (lowercase alphanumeric + hyphens) |
| `environment` | `string` | Environment name (lowercase alphanumeric + hyphens) |
| `cidr_block` | `string` | VPC CIDR block |
| `public_subnet_cidrs` | `list(string)` | Public subnet CIDRs (one per AZ) |
| `private_subnet_cidrs` | `list(string)` | Private subnet CIDRs (one per AZ) |
| `database_subnet_cidrs` | `list(string)` | Database subnet CIDRs (one per AZ) |
| `az_names` | `list(string)` | AZ names (minimum 2) |

### Optional — NAT

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enable_nat_gateway` | `bool` | `true` | Create NAT Gateway(s) |
| `single_nat_gateway` | `bool` | `true` | One shared NAT vs one per AZ |

### Optional — DNS

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enable_dns_hostnames` | `bool` | `true` | Enable DNS hostname resolution |
| `enable_dns_support` | `bool` | `true` | Enable Amazon-provided DNS |

### Optional — Flow Logs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enable_flow_logs` | `bool` | `false` | Enable VPC Flow Logs |
| `flow_logs_destination_type` | `string` | `"cloud-watch-logs"` | `cloud-watch-logs` or `s3` |
| `flow_logs_retention_days` | `number` | `30` | CloudWatch log retention |
| `flow_logs_s3_bucket_arn` | `string` | `""` | S3 bucket ARN (S3 mode only) |

### Optional — Behaviour

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `map_public_ip_on_launch` | `bool` | `true` | Auto-assign public IPs in public subnets |
| `database_subnet_route_to_nat` | `bool` | `false` | Route DB subnets through NAT |
| `common_tags` | `map(string)` | `{}` | Tags merged onto every resource |

---

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `vpc_arn` | VPC ARN |
| `vpc_cidr_block` | VPC CIDR |
| `igw_id` | Internet Gateway ID |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `database_subnet_ids` | List of database subnet IDs |
| `public_subnets_by_az` | Map of AZ → public subnet ID |
| `private_subnets_by_az` | Map of AZ → private subnet ID |
| `database_subnets_by_az` | Map of AZ → database subnet ID |
| `nat_gateway_ids` | List of NAT Gateway IDs |
| `nat_gateway_public_ips` | List of NAT public IPs |
| `public_route_table_id` | Public route table ID |
| `private_route_table_ids` | List of private route table IDs |
| `database_route_table_ids` | List of database route table IDs |
| `flow_log_id` | Flow Log resource ID |

---

## Architecture

```
                         Internet
                            │
                    ┌───────▼────────┐
                    │ Internet GW    │
                    └───────┬────────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                                   │
  ┌───────▼───────┐                   ┌───────▼───────┐
  │  Public       │                   │  Public       │
  │  us-east-1a   │                   │  us-east-1b   │
  │  ALB / Bastion│                   │  ALB / Bastion│
  └───────┬───────┘                   └───────┬───────┘
          │ (NAT GW)                          │ (NAT GW)
  ┌───────▼───────┐                   ┌───────▼───────┐
  │  Private      │                   │  Private      │
  │  us-east-1a   │                   │  us-east-1b   │
  │  App servers  │                   │  App servers  │
  └───────┬───────┘                   └───────┬───────┘
          │                                   │
  ┌───────▼───────┐                   ┌───────▼───────┐
  │  Database     │                   │  Database     │
  │  us-east-1a   │                   │  us-east-1b   │
  │  Isolated     │                   │  Isolated     │
  └───────────────┘                   └───────────────┘
```

---

## NAT Gateway modes

| `enable_nat_gateway` | `single_nat_gateway` | Result | Suitable for |
|----------------------|----------------------|--------|--------------|
| `false` | — | No NAT | Private VPCs, Transit GW |
| `true` | `true` | 1 shared NAT | Dev / Staging (lower cost) |
| `true` | `false` | 1 NAT per AZ | Production (HA) |

---

## Examples

- [complete](./examples/complete) — Production HA with flow logs
- [minimal](./examples/minimal) — Single NAT, no flow logs
- [no-nat](./examples/no-nat) — Fully private VPC

---

## Versioning

This module follows [Semantic Versioning](https://semver.org/). Always pin to a tag:

```hcl
source = "git::https://github.com/rahul-paladugu/Terraform-module-aws-vpc.git?ref=v1.0.0"
```

Never reference a branch — branches move and will break your infrastructure on the next `terraform init -upgrade`.

---

## Contributing

1. Fork → branch `feat/<name>` or `fix/<name>`
2. Run `terraform fmt -recursive` and `terraform validate` in the root and all `examples/`
3. Update `CHANGELOG.md` with the change
4. Open a PR — include a `terraform plan` output from the `complete` example

---

## License

Apache 2.0
