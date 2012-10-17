#!/bin/bash

echo -n "Enter description of changes you made to the project > "
read text

git add .
git commit -m "$text"
git push -u origin master