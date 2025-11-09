#!/bin/bash

ANCHOR="UserManagedRules" # anchor name
PF="sudo pfctl"           # pfctl command
REF="$TMPDIR/pfmange_pf_ref" # file to save pf ref token 'pfctl -sR' (see pfctl -E/-X options)

usage() {
  cat <<EOF
  COMMANDS:
    status, enable, disable - check status, turn on/off
    sh(show) - show rules stats
    ls(list) - list rules with numbers
    add <rule>, ins(insert) <rule>, del(delete) <rule number(s)>
    clear - clear all rules

  RULES SYNTAX (simplified):
    (block/pass) [in/out] quick [on int] [inet/inet6] [proto tcp/udp/...]
        [from src_addr [port src_port]] [to dst_addr [port dst_port]]
  RULE EXAMPLES:
    block out quick proto tcp to 10.1.1.0/24 port 80:90
    block in quick proto tcp from { 10.1.1.2, !192.168.0.1 } port 80
    block in quick proto udp from any port { 123 80 443 }
EOF
}

# show rules with stats
show() {
  echo
  $PF -a $ANCHOR -vsr 2>/dev/null
}

# show pf and anchor status
status() {
  echo
  $PF 2>/dev/null -s info | grep -i enabled || echo "PF is DISABLED: run 'pfmanage.sh enable'"
  $PF 2>/dev/null -sr | grep -qFw "anchor \"$ANCHOR\"" || echo "ANCHOR DISABLED: run 'pfmanage.sh enable'"
}

# get list of rules in anchor
get_rules() {
  $PF 2>/dev/null -a $ANCHOR -sr
}

# set rules to anchor
set_rules() {
  echo -e "$*" | $PF 2>/dev/null -a $ANCHOR -f - && echo "Rules updated" || echo "Failed to update rules"
}

# add anchor to main ruleset and start pf
enable() {
  if [ -f $REF ] && $PF 2>/dev/null -sR | grep -q "$(cat $REF)"; then
    echo "Already enabled. If something went wrong, then run 'pfmanage.sh disable && pfmanage.sh enable'"
  else
    echo "anchor $ANCHOR" | cat /etc/pf.conf - | $PF 2>&1 -Ef - |
      sed -rn "s/^Token : ([0-9]+)$/\1/p" >|"$REF" || echo "Failed to enable pf"
  fi
}

# remove anchor from main ruleset
disable() {
  cat /etc/pf.conf | $PF 2>/dev/null -f - || echo "Failed to restore main ruleset"
  if [ -f $REF ]; then
    $PF 2>/dev/null -X "$(cat $REF)"
    rm $REF
  fi
}

# delete all rules in anchor
clear() {
  $PF 2>/dev/null -a "$ANCHOR" -Fr && echo "Rules cleared" || echo "Failed to clear anchor rules"
}

# print rules with numbers
list() {
  echo
  i=0
  while IFS=$'\n' read -r line; do
    i=$((i + 1))
    echo "$i $line"
  done < <(get_rules)
}

# add rule to the bottom
add() {
  ruleset=""
  while IFS=$'\n' read -r line; do
    ruleset+="$line\n"
  done < <(get_rules)
  ruleset+="$*"
  set_rules "$ruleset"
}

# add rule to the top
insert() {
  ruleset="$*"
  while IFS=$'\n' read -r line; do
    ruleset+="\n$line"
  done < <(get_rules)
  set_rules "$ruleset"
}

# delete rule(s)
delete() {
  ruleset=""
  i=0
  while IFS=$'\n' read -r line; do
    skip=0
    i=$((i + 1))
    for d in "$@"; do
      if [ "$d" -eq $i ]; then
        skip=1
        break
      fi
    done
    [ $skip -eq 1 ] && continue
    ruleset+="$line\n"
  done < <(get_rules)
  set_rules "$ruleset"
}

case $1 in
status)
  status
  list
  ;;
enable | disable | clear)
  $1
  status
  ;;
add)
  $1 "${*:2}"
  status
  list
  ;;
ins | insert)
  insert "${*:2}"
  status
  list
  ;;
del | delete)
  delete "${*:2}"
  status
  list
  ;;
show | sh)
  status
  show
  ;;
list | ls)
  status
  list
  ;;
*)
  usage
  ;;
esac
