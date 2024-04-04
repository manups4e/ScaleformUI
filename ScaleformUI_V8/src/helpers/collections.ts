export const isOneOfEnum = <T extends number, E extends { [k: string]: T }>(
    icon: E[keyof E],
    possibleValues: E[keyof E][]
): boolean => possibleValues.includes(icon)

export type ClassType<T> = new (...args: any[]) => T;

export const namedClassExtension = <T extends ClassType<any>>(name: string, ctor: T) => {
    Object.defineProperty(ctor, 'name', {
        get: () => name
    });
    try {
        Object.defineProperty(ctor.prototype, 'name', {
            get: () => name
        });
    } catch (err) {}

    return ctor
}