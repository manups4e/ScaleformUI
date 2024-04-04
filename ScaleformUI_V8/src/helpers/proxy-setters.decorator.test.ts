import {ProxySetters} from "./proxy-setters.decorator";

@ProxySetters<TestClass>("proxyMethod")
class TestClass {
    public accessor value: number = 8
    public proxyCallCounter = 0
    public proxyMethod() {
        this.proxyCallCounter++
    }

    public nonSetterMethod() {

    }
}
describe("ProxySetter decorator test", () => {
    it("should proxy a setter, but not a getter", () => {
        const testClass = new TestClass()
        testClass.value = 10
        const value = testClass.value
        testClass.nonSetterMethod()
        expect(testClass.proxyCallCounter).toEqual(1)
        expect(testClass.value).toEqual(10)
    })
})