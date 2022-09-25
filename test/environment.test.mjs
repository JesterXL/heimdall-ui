import { expect } from "chai"
import { getEnvironment } from "../src/environment.js"

describe("getEnvironment.js", () => {
  it("should give back qa or production", () => {
    const result = getEnvironment()
    console.log("environment result:", result)
    const isQA = result === "qa"
    const isProduction = result === "production"
    const isStage = result === 'staging'
    const isQAOrStageOrProduction = isQA || isStage || isProduction
    expect(isQAOrStageOrProduction).to.equal(true)
  })
})
