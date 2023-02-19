#!/bin/bash

set -e


cache_dir=$HOME/.cache/name-generator

#APIs
male_name_url="https://www.randomlists.com/data/names-male.json"
female_name_url="https://www.randomlists.com/data/names-female.json"
last_name_url="https://www.randomlists.com/data/names-surnames.json"

#jsons
male_name_path="$cache_dir/male_name.json"
female_name_path="$cache_dir/female_name.json"
last_name_path="$cache_dir/last_name.json"

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
if [ -f $male_name_path ] && [ -f $female_name_path ] && [ -f $last_name_path ];then
    echo -e "\n${green}Name cache already exists procedding${reset}"
else
    echo -e "\n${purple}Caching name lists"
    curl -o $male_name_path $male_name_url
    curl -o $female_name_path $female_name_url
    curl -o $last_name_path $last_name_url
    echo -e "${green}Caching successfull${reset}"
fi

