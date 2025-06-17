#!/bin/bash
read -p "Please enter your name: " name
dir="submission_reminder_$name"

mkdir -p  ./$dir
mkdir -p  ./$dir/app ./$dir/modules ./$dir/assets ./$dir/config

#inputing content of file named reminder.sh
cat  > "$dir/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#inputing content of file named  function.sh
cat  > "$dir/modules/functions.sh" <<'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

#inputing content of the file named submissions.txt
cat  > "$dir/assets/submissions.txt" <<'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kalisa, Shell Navigation, submitted
Kenzo, Git, not submitted
Rene, Shell Navigation, not submitted
Lilian, Shell Basics, not submitted
EOF
#inputng content of file named config.env
cat  > "$dir/config/config.env" <<'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
#creating statup.sh
cat  > "$dir/startup.sh" <<'EOF'
#!/bin/bash

./app/reminder.sh
EOF

#Make scripts executable
find "$dir" -type f -name "*.sh" -exec chmod +x {} \;

echo "Environment created successfully  '$dir'." 
