// Not fully typesafe due to the discrepant returns of natives
export const waitUntilReturns = <T extends (...args: any) => any>(
    dofunc: Function,
    checker: () => any,
    untilReturns: Awaited<ReturnType<T>> | Awaited<ReturnType<T>>[],
    checkTo: number
) => new Promise(async (res) => {
        await dofunc();
        const untilReturnsArray = Array.isArray(untilReturns) ? untilReturns : [untilReturns]
        const tick = setInterval(async () => {
            const cres = await checker();
            if (untilReturnsArray.includes(cres)) {
                res(cres);
                clearInterval(tick);
                return;
            }
        }, checkTo)
    })

export const noop = () => {}

export const loadPedHeadshot = async (ped: number) => {
    const handle = RegisterPedheadshot(PlayerPedId())
    await waitUntilReturns(noop, () => IsPedheadshotValid(handle) && IsPedheadshotReady(handle), [true, 1], 0)
    return handle
}

export const Delay = (ms: number) => new Promise(res => setTimeout(res, ms))