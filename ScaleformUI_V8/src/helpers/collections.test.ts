import {isOneOfEnum} from "./collections";

describe("collections test", () => {
    it("should check if value is a certain enum value", () => {
        enum Test {
            A,
            B,
            C
        }
        const actual = isOneOfEnum(Test.A, [Test.A, Test.C])
        expect(actual).toBeTruthy()
    })
})