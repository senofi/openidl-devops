resource "awx_job_template" "baseconfig" {
  name           = "baseconfig"
  job_type       = "run"
  inventory_id   = data.awx_inventory.default.id
  project_id     = awx_project.default.id
  playbook       = "master-configure-system.yml"
  become_enabled = true
}