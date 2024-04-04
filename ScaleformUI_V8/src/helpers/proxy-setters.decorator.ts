type MethodKeys<T> = {
    [K in keyof T]: T[K] extends (...args: any[]) => any ? K : never;
}[keyof T];
/**
 * Internal decorator that proxies calls to setters with a passed method
 * @param proxyMethod
 * @param after
 * @constructor
 */
export const ProxySetters = <T extends InstanceType<any>>(proxyMethod: MethodKeys<T>, after = true) => (target: any): any => {
    const props = Object.getOwnPropertyNames(target.prototype)
    props.forEach(method => {
        const descriptor = Object.getOwnPropertyDescriptor(target.prototype, method);
        if (descriptor && typeof descriptor.set === "function") {
            const originalSetter = descriptor.set;
            if (after) {
                descriptor.set = function(value: any) {
                    originalSetter.apply(this, [value]);
                    (this as unknown as T)[proxyMethod](method)
                };
            } else {
                descriptor.set = function(value: any) {
                    (this as unknown as T)[proxyMethod](method)
                    return originalSetter.apply(this, [value]);
                };
            }

            Object.defineProperty(target.prototype, method, descriptor);
        }
    })
}