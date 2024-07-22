---
- name: Run script and check for completion
  hosts: all
  become: yes
  tasks:
    - name: Run the script using bash shell
      shell: /path/to/your/script.sh &
      register: script_job
      async: 3600
      poll: 0

    - name: Wait for 1 minute before starting checks
      pause:
        minutes: 1

    - name: Check if the script has completed
      shell: "pgrep -f /path/to/your/script.sh"
      register: script_status
      retries: 60
      delay: 60
      until: script_status.rc != 0

    - name: Output script completion status
      debug:
        msg: "Script has completed."

