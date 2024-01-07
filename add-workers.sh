#!/bin/bash

# File where worker nodes will be added
WORKERS_FILE="workers"

# Check if the workers file exists, if not create it
if [ ! -f "$WORKERS_FILE" ]; then
    echo "# list of workers to be used in deployment" > "$WORKERS_FILE"
fi

# Function to add a worker to the file
add_worker() {
    echo "Adding worker: $1"
    echo "$1" >> "$WORKERS_FILE"
}

# Prompt user to enter worker details
while true; do
    read -p "Enter worker node IP or hostname (or 'done' to finish): " worker
    if [ "$worker" = "done" ]; then
        break
    fi
    add_worker "$worker"
done

echo "Worker nodes have been added to $WORKERS_FILE."
