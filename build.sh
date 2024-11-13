#!/bin/bash
set -e
echo "Generating anchor.stl, this can take a couple of minutes..."
openscad -D \$fn=50 -o anchor.stl anchor.scad
echo "Done!"
