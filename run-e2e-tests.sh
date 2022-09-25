# echo "Run e2e tests based on environment..."
# if [[ $ENV == "production" ]]
#     then
#         echo "ENV is production, running only certain tests..."
#         npx cypress run --spec "cypress/e2e/01_ping.spec.js,cypress/e2e/03_stuff.spec.js" --reporter mochawesome --reporter-options "reportDir=cypress/report/mochawesome-report,overwrite=false,html=false,json=true,timestamp=mmddyyyy_HHMMss"
        
#     else
#         echo "ENV is dev, running all e2e tests..."
#         npx cypress run --reporter mochawesome --reporter-options "reportDir=cypress/report/mochawesome-report,overwrite=false,html=false,json=true,timestamp=mmddyyyy_HHMMss"
# fi

echo "ENV is dev, running all e2e tests..."
npx cypress run --reporter mochawesome --reporter-options "reportDir=cypress/report/mochawesome-report,overwrite=false,html=false,json=true,timestamp=mmddyyyy_HHMMss"

