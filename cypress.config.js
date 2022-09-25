import { defineConfig } from 'cypress'

export default defineConfig({
    e2e: {
        setupNodeEvents(on, config) {
            config.retries = {
                runMode: 2,
                openMode: 0
            }
            config.defaultCommandTimeout = 60000
            config.viewportHeight = 900

            return config
        }
    }
})