# ansible
if which ansible &> /dev/null; then
    alias ansible-roledir="mkdir -p {defaults,files,templates,handlers,tasks} && touch {defaults,handlers,tasks}/main.yml"
    alias ansible-hostvars='ansible -m debug -a "var=hostvars[inventory_hostname]"'
fi