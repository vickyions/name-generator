#!/bin/bash

set -e


cache_dir=$HOME/.cache/name-generator

#APIs
male_names_url="https://www.randomlists.com/data/names-male.json"
female_names_url="https://www.randomlists.com/data/names-female.json"
last_names_url="https://www.randomlists.com/data/names-surnames.json"

#jsons
male_names_path="$cache_dir/male_names"
female_names_path="$cache_dir/female_names"
last_names_path="$cache_dir/last_names"

#color codes
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
reset='\033[0m'


if [ ! -d cache_dir ];
then
    echo -e "\nCache directory ${yellow}$cache_dir ${red}doesn't exists${reset}"
    echo "Creating the directory $cache_dir"
    mkdir -p $cache_dir
    echo -e "${green}Directory successfully created${reset}"
    # if [ $? -ne 0 ]; then
    #     echo "Error: while creating directory $cache_dir"
    #     cat /tmp/name-generator-error.log
    #     exit 1
    # fi
else
    echo -e "\nCache directory $cache_dir already exists using cached data"
fi

#Caching the names
if [ -f $male_names_path ] && [ -f $female_names_path ] && [ -f $last_names_path ];then
    echo -e "\n${green}Name cache already exists procedding${reset}"
else
    echo -e "\n${purple}Caching name lists"
    curl $male_names_url | jq -r '.data | .[]' > $male_names_path
    curl $female_names_url | jq -r '.data | .[]' > $female_names_path
    curl $last_names_url | jq -r '.data | .[]' > $last_names_path
    echo -e "${green}Caching successfull${reset}"
fi

name_gen() {
    if [[ $1 -eq 1 ]];then
        first_name=$(shuf -n 1 $male_names_path)
    elif [[ $1 -eq 2 ]];then
        first_name=$(shuf -n 1 $female_names_path)
    else
        echo -e "${red}Input valid gender number${reset}"
        return 0
    fi

    last_name=$(shuf -n 1 $last_names_path)
    
    # clear_previous_line 1
    echo -en "\e[1A\e[K"
    echo -en "\e[1A\e[K"
    echo -e "${yellow}$first_name $last_name${reset}"
    return 0
}

# clear_previous_line () {
#     i=$1
#     while [[ $i -gt 0 ]];do
#         echo -en "\e[1A\e[K"
#         ((i=i-1))
#     done
# }

usr_input=1
while [[ usr_input -ne 0 ]];do
    echo -e "${blue}Male - 1 ${purple}female - 2 ${red}exit - 0:${reset}"
    read -r usr_input
    if [[ usr_input -eq 0 ]];then 
        exit 0 
    fi
    
    name_gen $usr_input
done
