locals {
  tags = merge(var.tags, {
    Module = basename(path.module)
  })
}
