#!/bin/sh

# Define color names in a list (index-based)
names="Black Red Green Yellow Blue Magenta Cyan White Bright-Black Bright-Red Bright-Green Bright-Yellow Bright-Blue Bright-Magenta Bright-Cyan Bright-White"

# Convert names into a positional parameter list
set -- $names

i=0
while [ $i -lt 8 ]; do
  left_name=$(eval "printf '%s' \"\${$((i + 1))}\"")
  right_name=$(eval "printf '%s' \"\${$((i + 9))}\"")

  printf "\033[38;5;%sm%-15s\033[0m Color %2d    " "$i" "$left_name" "$i"
  printf "\033[38;5;%sm%-15s\033[0m Color %2d\n" "$((i + 8))" "$right_name" "$((i + 8))"

  i=$((i + 1))
done

cat << EOF

        1     4     5     7    30    31    32    33    34    35    36    37  
   1 [1;1m  1;1[m [4;1m  4;1[m [5;1m  5;1[m [7;1m  7;1[m [30;1m 30;1[m [31;1m 31;1[m [32;1m 32;1[m [33;1m 33;1[m [34;1m 34;1[m [35;1m 35;1[m [36;1m 36;1[m [37;1m 37;1[m 
   4 [1;4m  1;4[m [4;4m  4;4[m [5;4m  5;4[m [7;4m  7;4[m [30;4m 30;4[m [31;4m 31;4[m [32;4m 32;4[m [33;4m 33;4[m [34;4m 34;4[m [35;4m 35;4[m [36;4m 36;4[m [37;4m 37;4[m 
   5 [1;5m  1;5[m [4;5m  4;5[m [5;5m  5;5[m [7;5m  7;5[m [30;5m 30;5[m [31;5m 31;5[m [32;5m 32;5[m [33;5m 33;5[m [34;5m 34;5[m [35;5m 35;5[m [36;5m 36;5[m [37;5m 37;5[m 
   7 [1;7m  1;7[m [4;7m  4;7[m [5;7m  5;7[m [7;7m  7;7[m [30;7m 30;7[m [31;7m 31;7[m [32;7m 32;7[m [33;7m 33;7[m [34;7m 34;7[m [35;7m 35;7[m [36;7m 36;7[m [37;7m 37;7[m 
  30 [1;30m 1;30[m [4;30m 4;30[m [5;30m 5;30[m [7;30m 7;30[m [30;30m30;30[m [31;30m31;30[m [32;30m32;30[m [33;30m33;30[m [34;30m34;30[m [35;30m35;30[m [36;30m36;30[m [37;30m37;30[m 
  31 [1;31m 1;31[m [4;31m 4;31[m [5;31m 5;31[m [7;31m 7;31[m [30;31m30;31[m [31;31m31;31[m [32;31m32;31[m [33;31m33;31[m [34;31m34;31[m [35;31m35;31[m [36;31m36;31[m [37;31m37;31[m 
  32 [1;32m 1;32[m [4;32m 4;32[m [5;32m 5;32[m [7;32m 7;32[m [30;32m30;32[m [31;32m31;32[m [32;32m32;32[m [33;32m33;32[m [34;32m34;32[m [35;32m35;32[m [36;32m36;32[m [37;32m37;32[m 
  33 [1;33m 1;33[m [4;33m 4;33[m [5;33m 5;33[m [7;33m 7;33[m [30;33m30;33[m [31;33m31;33[m [32;33m32;33[m [33;33m33;33[m [34;33m34;33[m [35;33m35;33[m [36;33m36;33[m [37;33m37;33[m 
  34 [1;34m 1;34[m [4;34m 4;34[m [5;34m 5;34[m [7;34m 7;34[m [30;34m30;34[m [31;34m31;34[m [32;34m32;34[m [33;34m33;34[m [34;34m34;34[m [35;34m35;34[m [36;34m36;34[m [37;34m37;34[m 
  35 [1;35m 1;35[m [4;35m 4;35[m [5;35m 5;35[m [7;35m 7;35[m [30;35m30;35[m [31;35m31;35[m [32;35m32;35[m [33;35m33;35[m [34;35m34;35[m [35;35m35;35[m [36;35m36;35[m [37;35m37;35[m 
  36 [1;36m 1;36[m [4;36m 4;36[m [5;36m 5;36[m [7;36m 7;36[m [30;36m30;36[m [31;36m31;36[m [32;36m32;36[m [33;36m33;36[m [34;36m34;36[m [35;36m35;36[m [36;36m36;36[m [37;36m37;36[m 
  37 [1;37m 1;37[m [4;37m 4;37[m [5;37m 5;37[m [7;37m 7;37[m [30;37m30;37[m [31;37m31;37[m [32;37m32;37[m [33;37m33;37[m [34;37m34;37[m [35;37m35;37[m [36;37m36;37[m [37;37m37;37[m 
  40 [1;40m 1;40[m [4;40m 4;40[m [5;40m 5;40[m [7;40m 7;40[m [30;40m30;40[m [31;40m31;40[m [32;40m32;40[m [33;40m33;40[m [34;40m34;40[m [35;40m35;40[m [36;40m36;40[m [37;40m37;40[m 
  41 [1;41m 1;41[m [4;41m 4;41[m [5;41m 5;41[m [7;41m 7;41[m [30;41m30;41[m [31;41m31;41[m [32;41m32;41[m [33;41m33;41[m [34;41m34;41[m [35;41m35;41[m [36;41m36;41[m [37;41m37;41[m 
  42 [1;42m 1;42[m [4;42m 4;42[m [5;42m 5;42[m [7;42m 7;42[m [30;42m30;42[m [31;42m31;42[m [32;42m32;42[m [33;42m33;42[m [34;42m34;42[m [35;42m35;42[m [36;42m36;42[m [37;42m37;42[m 
  43 [1;43m 1;43[m [4;43m 4;43[m [5;43m 5;43[m [7;43m 7;43[m [30;43m30;43[m [31;43m31;43[m [32;43m32;43[m [33;43m33;43[m [34;43m34;43[m [35;43m35;43[m [36;43m36;43[m [37;43m37;43[m 
  44 [1;44m 1;44[m [4;44m 4;44[m [5;44m 5;44[m [7;44m 7;44[m [30;44m30;44[m [31;44m31;44[m [32;44m32;44[m [33;44m33;44[m [34;44m34;44[m [35;44m35;44[m [36;44m36;44[m [37;44m37;44[m 
  45 [1;45m 1;45[m [4;45m 4;45[m [5;45m 5;45[m [7;45m 7;45[m [30;45m30;45[m [31;45m31;45[m [32;45m32;45[m [33;45m33;45[m [34;45m34;45[m [35;45m35;45[m [36;45m36;45[m [37;45m37;45[m 
  46 [1;46m 1;46[m [4;46m 4;46[m [5;46m 5;46[m [7;46m 7;46[m [30;46m30;46[m [31;46m31;46[m [32;46m32;46[m [33;46m33;46[m [34;46m34;46[m [35;46m35;46[m [36;46m36;46[m [37;46m37;46[m 
  47 [1;47m 1;47[m [4;47m 4;47[m [5;47m 5;47[m [7;47m 7;47[m [30;47m30;47[m [31;47m31;47[m [32;47m32;47[m [33;47m33;47[m [34;47m34;47[m [35;47m35;47[m [36;47m36;47[m [37;47m37;47[m 

EOF
