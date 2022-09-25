import { getEnvironment } from './environment.js'
import { getLocalToken } from './token.js'

const environment = getEnvironment()
console.log("environment:", environment)

const app = Elm.Main.init({
  flags: {
    environment,
    seed: Math.random() * 10_000,
    localToken: getLocalToken(),
  },
})
