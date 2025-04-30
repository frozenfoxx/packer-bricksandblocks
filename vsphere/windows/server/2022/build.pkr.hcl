//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.

build {
  sources = [
    "source.vsphere-iso.windows-server-standard-desktop"
  ]

  provisioner "ansible" {
    user                   = var.build_username
    inventory_directory    = "${var.root_dir}/ansible/inventory"
    groups                 = ["packer_windows_server2022"]
    playbook_file          = "${var.root_dir}/ansible/playbooks/packer-windows-server2022.yml"
    use_proxy              = false
    ansible_env_vars = [
      "ANSIBLE_CONFIG=${var.root_dir}/ansible/ansible.cfg",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_PYTHON_INTERPRETER=auto_silent" # Silence warning about Python discovery
    ]
    extra_arguments = [
      #"-v",
      "--extra-vars", "ansible_connection=winrm",
      "--extra-vars", "ansible_user='${var.build_username}'",
      "--extra-vars", "ansible_password='${var.build_password}'",
      "--extra-vars", "ansible_port='${var.communicator_port}'",
      "--extra-vars", "base_shell_user_name='${var.build_username}'",
    ]
  }

  post-processor "manifest" {
    output     = local.manifest_output
    strip_path = true
    strip_time = true
    custom_data = {
      build_username           = var.build_username
      build_date               = local.build_date
      build_version            = local.build_version
      common_data_source       = var.common_data_source
      common_vm_version        = var.common_vm_version
      vm_cpu_cores             = var.vm_cpu_cores
      vm_cpu_count             = var.vm_cpu_count
      vm_disk_size             = var.vm_disk_size
      vm_disk_thin_provisioned = var.vm_disk_thin_provisioned
      vm_firmware              = var.vm_firmware
      vm_guest_os_type         = var.vm_guest_os_type
      vm_mem_size              = var.vm_mem_size
      vm_network_card          = var.vm_network_card
      vsphere_cluster          = var.vsphere_cluster
      vsphere_host             = var.vsphere_host
      vsphere_datacenter       = var.vsphere_datacenter
      vsphere_datastore        = var.vsphere_datastore
      vsphere_endpoint         = var.vsphere_endpoint
      vsphere_folder           = var.vsphere_folder
    }
  }

  dynamic "hcp_packer_registry" {
    for_each = var.common_hcp_packer_registry_enabled ? [1] : []
    content {
      bucket_name = local.bucket_name
      description = local.bucket_description
      bucket_labels = {
        "os_family" : var.vm_guest_os_family,
        "os_name" : var.vm_guest_os_name,
        "os_version" : var.vm_guest_os_version,
      }
      build_labels = {
        "build_version" : local.build_version,
        "packer_version" : packer.version,
      }
    }
  }
}
