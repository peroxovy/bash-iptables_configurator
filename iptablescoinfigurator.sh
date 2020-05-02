#!bin/bash

#All rights reserved - @peroxovy || Piotr Mazur
#Git - github.com/peroxovy
#This script is made to simplify iptables configuration.
#It operates on several functions

command="iptables -t ";

menu() {

clear

echo "-- Iptables configurator --"
echo "[ 1 ] - Start configurate "
echo "[ 2 ] - Check file command.txt with current configuration "
echo "[ 3 ] - About script"
echo "[ 0 ] - Exit"

read opt;

case $opt in
    1) tables               ;;
    2) read_file            ;;
    3) info                 ;;
    0) exit                 ;;
    *) echo "INVALID OPTION";;
esac

}

info(){

clear
echo "Author: Piotr Mazur"
echo "All rights reserved / copyright"
echo "This bash script creates a simple iptables configuration.";
echo "After choosing a specific options, you can choose which iptables table you want to configure";
echo "Every chosen option is appended to variable, then after all it is stored in specific text file";
echo "Created commands can be simply used to create a firewall."

echo "Click enter to return to menu";

read continue

menu

}

tables(){

clear

echo "-- Choose on which table you want to operate --"
echo "[ 1 ] - FILTER"
echo "[ 2 ] - NAT"
echo "[ 3 ] - MANGLE"

read opt

tbl="";


case $opt in
    1) tbl="FILTER"; command="$command $tbl"               ;;
    2) tbl="NAT"; command="$command $tbl"                  ;;
    3) tbl="MANGLE"; command="$command $tbl"               ;;
    *) echo "INVALID OPTION";;
esac

actions "$opt"

}

actions(){

local tbl=$1;

echo "-- Choose specific action--"
echo "[ 1 ] - Set the default policy for the specified chain.[ -P ]"
echo "[ 2 ] - List all of the rules in the chain. [ -L chain ]"
echo "[ 3 ] - List all of the rules in the table. [ -L ]"
echo "[ 4 ] - Add new rule. [ -A ]"
echo "[ 5 ] - Insert new rule into a chain. [ -I]"
echo "[ 6 ] - Delete a rule in a particular chain. [ -D ]"
echo "[ 7 ] - Clear chain rules. [ -F chain]"
echo "[ 8 ] - Clear table rules. [ -F ]"

read action

if [ $action -eq 3 ]
then
    table_rule_list "$tbl";
elif [ $action -eq 5 ] 
then
    insert_rule "$tbl";
elif [ $action -eq 8 ] 
then
    table_clear_rules "$tbl";
else
    chains "$tbl" "$action";
fi
}

table_rule_list(){
command="$command -L";

echo "Current command: "$command;
file_append "$command";
main
}

insert_rule(){
command="$command -I";

echo "Current command: "$command;
file_append "$command";
main
}

table_clear_rules(){
command="$command -F";

echo "Current command: "$command;
file_append "$command";
main
}

chains(){

local tbl=$1;
local action=$2;

case $tbl in
    1) filter_chains "$action" ;;
    2) nat_chains "$action" ;;
    3) mangle_chains "$action" ;;
esac
}

filter_chains(){

local action=$1;

local act="";

case $action in
    1)act="-P";command="$command $act";;
    2)act="-L";command="$command $act";;
    4)act="-A";command="$command $act";;
    5)act="-I";command="$command $act";;
    6)act="-D";command="$command $act";;
    7)act="-F";command="$command $act";;
esac

echo "-- Choose Filter table chain to operate on: --"
echo "[ 1 ] - INPUT"
echo "[ 2 ] - FORWARD"
echo "[ 3 ] - OUTPUT"

read opt

case $opt in
    1) chain="INPUT"; command="$command $chain";;
    2) chain="FORWARD"; command="$command $chain";;
    3) chain="OUTPUT"; command="$command $chain";;
esac

if [ $action -eq 2 ] || [ $action -eq 7 ]
then
    echo "Current command: "$command;
    file_append "$command";
    main
else
    u_Menu "$action"
fi
}

nat_chains(){

local action=$1;

local act="";

case $action in
    1)act="-P";command="$command $act";;
    2)act="-L";command="$command $act";;
    4)act="-A";command="$command $act";;
    5)act="-I";command="$command $act";;
    6)act="-D";command="$command $act";;
    7)act="-F";command="$command $act";;
esac

echo "-- Choose Nat table chain to operate on: --"
echo "[ 1 ] - PREROUTING"
echo "[ 2 ] - POSTROUTING"
echo "[ 3 ] - OUTPUT"

read opt

case $opt in
    1) chain="PREROUTING"; command="$command $chain";;
    2) chain="POSTROUTING"; command="$command $chain";;
    3) chain="OUTPUT"; command="$command $chain";;
esac

if [ $action -eq 2 ] || [ $action -eq 7 ]
then
    echo "Current command: "$command;
    file_append "$command";
    main
else
    u_Menu "$action"
fi
}

mangle_chains(){

local action=$1;

local act="";

case $action in
    1)act="-P";command="$command $act";;
    2)act="-L";command="$command $act";;
    4)act="-A";command="$command $act";;
    5)act="-I";command="$command $act";;
    6)act="-D";command="$command $act";;
    7)act="-F";command="$command $act";;
esac

echo "-- Choose Mangle table chain to operate on: --"
echo "[ 1 ] - INPUT"
echo "[ 2 ] - FORWARD"
echo "[ 3 ] - OUTPUT"
echo "[ 4 ] - PREROUTING"
echo "[ 5 ] - POSTROUTING"

read opt

case $opt in
    1) chain="INPUT"; command="$command $chain";;
    2) chain="FORWARD"; command="$command $chain";;
    3) chain="OUTPUT"; command="$command $chain";;
    4) chain="PREROUTING"; command="$command $chain";;
    5) chain="POSTROUTING"; command="$command $chain";;
esac

if [ $action -eq 2 ] || [ $action -eq 7 ]
then
    echo "Current command: "$command;
    file_append "$command";
    main
else
    u_Menu "$action"
fi
}

u_Menu(){

local action=$1;

case $action in
    1)u_p;;
    4)u_a "$action";;
    6)u_d;;
esac

}

u_p(){
echo "-- Do you want to accept or drop packets: --"
echo "[ 1 ] - Default accept packets - [ACCEPT]"
echo "[ 2 ] - Default drop packets - [DROP]"

read opt;

case $opt in
    1)command="$command ACCEPT";;
    2)command="$command DROP";;
esac

echo "Current command: "$command;
file_append "$command";
}

u_a(){
local del=$1;

if [ $del -eq 6 ]
then
    echo "-- Choose specific option on adding a rule to chain: --"
    echo "[ 1 ] - Add source IP address / netmask [ -s ]"
    echo "[ 2 ] - Add destination IP address / netmask [ -d ]"
    echo "[ 3 ] - Add input interface [ -i ]"
    echo "[ 4 ] - Add protocol [ -p ]"
    echo "[ 5 ] - [-m state --state STAN]"

    read opt;

    case $opt in
        1) command="$command -s"; l_Menu "$opt" "1";;
        2) command="$command -d"; l_Menu "$opt" "1";;
        3) command="$command -i"; l_Menu "$opt" "1";;
        4) command="$command -p"; l_Menu "$opt" "1";;
        5) command="$command -m state --state"; l_Menu "$opt" "1";;
    esac
else
    echo "-- Choose specific option on adding a rule to chain: --"
    echo "[ 1 ] - Add source IP address / netmask [ -s ]"
    echo "[ 2 ] - Add destination IP address / netmask [ -d ]"
    echo "[ 3 ] - Add input interface [ -i ]"
    echo "[ 4 ] - Add output interface [ -o ]"
    echo "[ 5 ] - Add protocol [ -p ]"
    echo "[ 6 ] - [-m state --state STAN]"

    read opt;

    case $opt in
        1) command="$command -s"; l_Menu "$opt" "2";;
        2) command="$command -d"; l_Menu "$opt" "2";;
        3) command="$command -i"; l_Menu "$opt" "2";;
        4) command="$command -o"; l_Menu "$opt" "2";;
        5) command="$command -p"; l_Menu "$opt" "2";;
        6) command="$command -m state --state"; l_Menu "$opt" "2";;
    esac
fi
}

u_d(){

echo "-- Do you want to delete rule by number or more specific:"
echo "[ 1 ] - Delete by number"
echo "[ 2 ] - Delete with options"
read opt;

case $opt in
    1)echo "-- Insert a number of rule you want delete from chain:"; read rule; command="$command $rule"; echo "Current command: "$command; file_append "$command";;
    2)u_a "1" ;;
esac
}


l_Menu(){
local action=$1;
local tmp=$2;

if [ $tmp -eq 1 ]
then
    case $action in
        1)l_s   ;;
        2)l_d   ;;
        3)l_i   ;;
        4)l_p   ;;
        5)l_m   ;;
    esac
else
    case $action in
        1)l_s   ;;
        2)l_d   ;;
        3)l_i   ;;
        4)l_o   ;;
        5)l_p   ;;
        6)l_m   ;;
    esac
fi
}

l_s(){

echo "-- Insert a source IP address or netmask: --"

read data;

command="$command $data";

j_Menu "1"

}

l_d(){

echo "-- Insert a destination IP address or netmask: --"

read data;

command="$command $data";

j_Menu "2"
}

l_i(){
echo "-- Insert a input interface: --"

read data;

command="$command $data";

j_Menu "3"
}

l_o(){
echo "-- Insert a output interface: --"

read data;

command="$command $data";

j_Menu "4"
}

l_p(){
echo "-- Choose protocol: --"
echo "[ 1 ] TCP"
echo "[ 2 ] UDP"
echo "[ 3 ] ICMP"
read data;

case $data in
    1)command="$command TCP";;
    2)command="$command UDP";;
    3)command="$command ICMP";;
esac

echo "-- Choose action: --"
echo "[ 1 ] - Add source port [ --sport PORT ]"
echo "[ 2 ] - Add destination port [ --dport PORT ]"
echo "[ 3 ] - Set packets which initiate ocmmunication [ --syn ]"

read opt;

case $opt in
    1)command="$command --sport"; j_MenuPorts "$opt" "5";;
    2)command="$command --dport"; j_MenuPorts "$opt" "5";;
    3)command="$command --syn";;
esac

echo "Current command: "$command;
file_append "$command";
}

l_m(){

test=-1;
ctr=0;

echo "-- Choose connection state: --"
echo "[ 1 ] - NEW"
echo "[ 2 ] - ESTABLISHED"
echo "[ 3 ] - RELATED"
echo "[ 4 ] - INVALID"

read test;

case $test in
    1)command="$command NEW"; ctr=$ctr+1;;
    2)command="$command ESTABLISHED"; ctr=$ctr+1;;
    3)command="$command RELATED"; ctr=$ctr+1;;
    4)command="$command INVALID" ctr=$ctr+1;;
esac

echo "Current command: "$command;
file_append "$command";
}

j_MenuPorts(){

local opt=$1;
local j=$2;

case $opt in
    1) echo "Enter number of source port:"; read port; command="$command $port"; j_Menu "$j";; 
    2) echo "Enter number of destination port:"; read port; command="$command $port"; j_Menu "$j";;
esac

}


j_Menu(){

j=$1;

echo "-- What do you want to do with packets? --"
echo "[ 1 ] - Accept packets [ -j ACCEPT ]"
echo "[ 2 ] - Drop packets [ -j DROP ]"
echo "[ 3 ] - Discard packets with feedback [ -j REJECT ]"
echo "[ 4 ] - Do a NAT translation [ -j MASQUERADE ]"
if [ $j -eq 5 ]
then
echo "[ 5 ] - Do a PAT translation [ -j SNAT --to-source ADR:PORT ]"
echo "[ 6 ] - Do a NAT translation [ -j DNAT --to-destination ADR:PORT]"
fi

read opt;

case $opt in
    1)command="$command -j ACCEPT";;
    2)command="$command -j DROP";;
    3)command="$command -j REJECT";;
    4)command="$command -j MASQUERADE";;
    5)command="$command -j SNAT --to-source"; echo "--Insert source IP address:--"; read ip; command="$command $ip:"; echo "--Insert port:--"; read pt; command="$command $pt";;
    6)command="$command -j DNAT --to-destination"; echo "--Insert destination IP address:--"; read ip; command="$command $ip:"; echo "--Insert port:--"; read pt; command="$command $pt";;
esac

echo "Current command: "$command;
file_append "$command";
}

file_append(){

com=$1;

echo $com >> command.txt

echo "Configuration was saved to command.txt file"
echo "Click enter to return to main menu"

read continue;

main
}

read_file(){

input="command.txt"

echo "Current commands in file:"
while IFS= read -r line
do
    echo "$line"
done < "$input"
echo "<<< End of file"
echo "Click enter to return to menu"
read continue;
main;
}

main(){
command="iptables -t";
menu
}

main
