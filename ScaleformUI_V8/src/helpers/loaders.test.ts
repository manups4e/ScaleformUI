import {waitUntilReturns} from "./loaders";

describe("loaders test", () => {
    it("should wait until the function returns true", async () => {
        const doFunc = jest.fn()
        let checkerReturnValue = false
        const checkerFunc = jest.fn(() => checkerReturnValue)
        const promise = waitUntilReturns(doFunc, checkerFunc, true, 100)
        expect(doFunc).toBeCalled()
        setTimeout(() => {
            checkerReturnValue = true
        }, 100 * 10)
        await promise
        expect(checkerFunc).toBeCalledTimes(10)
    })
})