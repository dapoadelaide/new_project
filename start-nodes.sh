---

- name: start-nodes.yml
  hosts: all

  vars:

    task_name: "start-nodes"
    task_zip: "websphere_scripts.tar"
    tmp_dir: "tmp"
    mainScript_name: "start-nodes.sh"
    mainScript_localpath: "home/padelaide"
    mainScript_remotepath: "tmp/{{ task_name }}"
    logFile: "/tmp/{{ task_name }}.reportOut"
    mailScript_name: "mailScript.sh"
    mailScript_basename: "mailScript"
        
    # inputCommands: "testing inputCommands:cd /tmp; ls -ltr /tmp:whoami:ls -ltr /var:testing inputCommands:cd /tmp; ls -ltr /tmp:whoami:ls -ltr /var"
    mailAddr: "testing@padela.com testing@padela.com testing@padela.com testing@padela.com a@a.com b@b.com"
  
  tasks:

   - name: Copy /{{ mainScript_localpath }}/{{ task_zip }} over to remote target server
     ansible.builtin.copy:
       src: /{{ mainScript_localpath }}/{{ task_zip }}
       dest: /{{ mainScript_remotepath }}/
       owner: root
       group: root
       mode: u+rwx

   - name: Untar /{{ mainScript_remotepath }}/{{ task_zip }} on the remote target server
     ansible.builtin.shell: tar xvf /{{ mainScript_remotepath }}/{{ task_zip }}
     args:
       chdir: /{{ mainScript_remotepath }}
     
   - name: Run /{{ mainScript_remotepath }}/{{ mainScript_name }} script on the remote target servers
     ansible.builtin.shell: /{{ mainScript_remotepath }}/{{ mainScript_name }} > {{ logFile }}
     args:
       executable: /bin/bash
       
   - name: Run /{{ mainScript_remotepath }}/{{ mailScript_name }} script on the remote target servers
     ansible.builtin.shell: /{{ mainScript_remotepath }}/{{ mailScript_name }} "{{ mailAddr }} {{ logFile }}"  >  /{{ tmp_dir }}/{{ mailScript_basename }}.{{ task_name }}.reportOut
     args:
       executable: /bin/bash    
