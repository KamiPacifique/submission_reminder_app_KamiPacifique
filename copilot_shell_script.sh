#!/bin/bash

# asking the assignment name
read -p "Entering the assignment name: " assignment

# looking for the root directory
dir=$(find . -maxdepth 1 -type d -name "submission_reminder_*" | head -n 1)

# error handling
if [[ ! -d "$dir" ]]; then
    echo -e " Can't find the "submission_reminder_*" "
    exit 1
fi

# Updating assignment in config.env
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$assignment\"/" "$dir/config/config.env"

echo "Updating NEW ASSIGNMENT to \"$assignment\" in config.env"

# Running startup.sh 
echo " Reminder check for the new assignment"
(cd "$dir" && bash startup.sh)

