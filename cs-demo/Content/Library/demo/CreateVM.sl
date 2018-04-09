namespace: demo
flow:
  name: CreateVM
  inputs:
    - host: 10.0.46.10
    - username: "Capa1\\1285-capa1user"
    - password:
        default: Automation123
        sensitive: true
    - datacenter: Capa1 Datacenter
    - image: Ubuntu
    - folder: Students/MP
    - prefix_list: '1-,2-,3-'
  workflow:
    - uuid:
        do:
          io.cloudslang.demo.uuid:
            - input_0: null
        publish:
          - uuid: '${"mp-"+uuid}'
        navigate:
          - SUCCESS: substring
    - substring:
        do:
          io.cloudslang.base.strings.substring:
            - origin_string: '${uuid}'
            - end_index: '11'
        publish:
          - id: '${new_string}'
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: on_failure
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm:
            - host: '${host}'
            - user: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_source_identifier: name
            - vm_source: '${image}'
            - datacenter: '${datacenter}'
            - vm_name: '${id}'
            - vm_folder: '${folder}'
            - mark_as_template: 'false'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      uuid:
        x: 198
        y: 61
      substring:
        x: 352
        y: 65
      clone_vm:
        x: 494
        y: 71
        navigate:
          ebaacb78-fc2b-71a9-6e9d-4c6a671e5d69:
            targetId: 21d35588-8c7a-d27d-5bc4-bbb052c492f5
            port: SUCCESS
    results:
      SUCCESS:
        21d35588-8c7a-d27d-5bc4-bbb052c492f5:
          x: 667
          y: 73
