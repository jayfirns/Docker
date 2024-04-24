#!/bin/bash
#
# Author: John Firnschild
# Written: 3/25/2024
# Version: 0.1.2


# Define the file to write to
output_file="index.md"

# Get the current directory path and convert it into a Markdown list starting from "/Documents"
path_list=$(pwd | awk -F/ -v OFS='/' '{
    for(i=1;i<=NF;i++) {
        if($i=="Documents") {
            print "- " $i;
            prefix="-"
            for(j=i+1;j<=NF;j++) {
                prefix=prefix "  -"
                print prefix, $j;
            }
            exit
        }
    }
}')
# Create the initial part of the Markdown template
cat <<EOT > $output_file

[[Network_Host_Identification]]
[[Noob_Linux_stuff]]
[[oindex]]

# This is the Main Header

### Path from Documents:

$path_list

EOT

# Append the directory contents as a bullet list
ls -1 | awk '{print "- " $0}' >> $output_file

# Append the Obsidian link placeholder and any additional content
cat <<EOT >> $output_file

[[This is an obsidian link placeholder]]
EOT

echo "Template created in $output_file"
