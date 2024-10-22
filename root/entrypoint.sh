#!/bin/bash

# Function to update the user's UID and GID
update_user_ids() {
    local user=updogg
    local current_uid=$(id -u $user)
    local current_gid=$(id -g $user)

    # Update UID if the passed UID is different
    if [ "$UID" != "$current_uid" ]; then
        usermod -u $UID $user
        echo "Changed UID of $user from $current_uid to $UID"
    fi

    # Update GID if the passed GID is different
    if [ "$GID" != "$current_gid" ]; then
        groupmod -g $GID $user
        usermod -g $GID $user
        echo "Changed GID of $user from $current_gid to $GID"
    fi
}

# Function to execute a script from /config if it exists, or fallback to default
execute_script() {
    local script_path=$1
    local default_path=$2
    local as_user=$3

    if [ -f "$script_path" ]; then
        echo "Executing overridden script: $script_path"
        if [ "$as_user" == "yes" ]; then
            sudo -E -u updogg /bin/bash "$script_path"
        else
            /bin/bash "$script_path"
        fi
    elif [ -f "$default_path" ]; then
        echo "Executing default script: $default_path"
        if [ "$as_user" == "yes" ]; then
            sudo -E -u updogg /bin/bash "$default_path"
        else
            /bin/bash "$default_path"
        fi
    fi
}

# Source environment variables from /config/.env if it exists
if [ -f /config/.env ]; then
    echo "Sourcing environment variables from /config/.env"
    set -o allexport
    source /config/.env
    set +o allexport
fi

# Execute preroot script (from /config or /root) before switching to less permissive user
execute_script /config/preroot.sh /root/preroot.sh no

# Check if UID and GID are provided via environment variables
if [ "$UID" != "69" ] || [ "$GID" != "69" ]; then
    echo "Updating UID and GID for updogg..."
    update_user_ids
fi

# Execute postroot script (from /config or /root) as root before running the app
execute_script /config/postroot.sh /root/postroot.sh no

# Pre-application script (from /config or /app) as the 'updogg' user
execute_script /config/preapp.sh /app/preapp.sh yes

if [ -f /app/app.sh ]; then
    exec sudo -E -u updogg /bin/bash /app/app.sh
else
    echo "No app.sh found in /app or /config directory."
fi

# Post-application script (from /config or /app) as the 'updogg' user
execute_script /config/postapp.sh /app/postapp.sh yes
