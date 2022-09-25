#!/bin/bash

echo "ENV environment variable: $ENV"
if [[ $ENV == "dev" ]]
    then
        echo "Generating QA environement file."
        echo "export const getEnvironment = () => 'qa'" > src/environment.js
elif [[ $ENV == "staging" ]]
    then
        echo "Generating Staging environement file."
        echo "export const getEnvironment = () => 'staging'" > src/environment.js
    else
         echo "Generating Production environement file."
        echo "export const getEnvironment = () => 'production'" > src/environment.js
fi
