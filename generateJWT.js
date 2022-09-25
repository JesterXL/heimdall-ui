import AWS from 'aws-sdk'
import fs from 'fs'
import jwt from 'jsonwebtoken'

export const getNewJWT = () =>
    console.log("Generating new JWT...") ||
    new AWS.SecretsManager({ region: process?.env?.AWS_REGION || 'us-east-1'})
    .getSecretValue({
        SecretId: "heimdall-qa",
        VersionStage: 'AWSCURRENT'
    })
    .promise()
    .then(
        result => {
            return Promise.resolve(result?.SecretString)
        }
    )
    .then(
        secret =>
            jwt.sign(
                {
                    data: 'this is an token for local UI development',
                }, 
                secret, 
                { expiresIn: '1d' }
            )
    )
    .then(
        token =>
            `export const getLocalToken = () => '${token}'`
    )
    .then(
        tokenString =>
            fs.writeFileSync("./src/token.js", tokenString, { flag: 'w' })
    )
    .then(
        () =>
            `Successfully wrote /src/token.js with a RAPID JWT token that will last for 1 day.\n`
    )
    .catch(
        error => {
            `Failed to generate new JWT, reason: ${error?.message}\n`
            return Promise.reject(error)
        }
    )

if (process.argv[1].split('/')[process.argv[1].split('/').length - 1] === import.meta.url.split('/')[import.meta.url.split('/').length - 1]) {
    getNewJWT()
    .then(console.log)
    .catch(console.error)
}
