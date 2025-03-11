##? The chomp function removes newlines, 
##? and /32 is added to specify a single IP address in CIDR notation. 
##? The distinct function ensures no duplicate IPs are added.
locals {
  tags = merge(var.tags, {
    Module = basename(path.module)
  })
}
