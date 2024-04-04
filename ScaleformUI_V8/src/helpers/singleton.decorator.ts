import {namedClassExtension} from "./collections";
const iocContainer = new Map<string, any>()
// Ghetto singleton decorator
export const Singleton = (target: any): any => namedClassExtension(target.name, class extends target {
    constructor(...args: any[]) {
        if (iocContainer.has(target.name)) {
            return iocContainer.get(target.name)
        }
        super(...args);
        iocContainer.set(target.name, this)
    }
})