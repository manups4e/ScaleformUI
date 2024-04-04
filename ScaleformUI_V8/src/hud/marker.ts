import {MarkerType} from "../elements/marker";
import {Vector3} from "../math/vector3";
import {Rgba} from "../math/rgba";

export interface MarkerConfiguration  {
    type?: MarkerType
    position: Vector3
    scale?: Vector3
    direction?: Vector3
    rotation?: Vector3
    distance?: number
    color: Rgba
    placeOnGround?: boolean
    bobUpAndDown?: boolean
    rotate: boolean
    faceCamera: boolean
    height: number
    checkZ?: boolean
}

type MarkerEventHandlerSig = (cx: Marker, action: "IN" | "OUT") => void

export class Marker {
    private eventHandlers: ["IN" | "OUT" | "BOTH", MarkerEventHandlerSig][] = []
    constructor(private readonly config: MarkerConfiguration) {}

    private isInMkr = false

    public draw() {
        const ped = PlayerPedId()
        const coords = Vector3.fromArr(GetEntityCoords(ped, true))
        if (this.isInDrawRange(ped, coords) && this.config.placeOnGround && this.config.position.z !== this.config.height + 0.1) {
            const [success, height] = GetGroundZFor_3dCoord(...this.config.position.toArr(), false)
            if (success) {
                this.config.position = this.config.position.cloneWith("z", height + 0.03)
            }
        }
        DrawMarker(this.config.type ?? MarkerType.UpsideDownCone,
            ...this.config.position.toArr(),
            ...(this.config.direction || Vector3.zero()).toArr(),
            ...(this.config.rotation || Vector3.zero()).toArr(),
            ...(this.config.scale || Vector3.create(1)).toArr(),
            ...this.config.color.toArr(),
            !!this.config.bobUpAndDown,
            this.config.faceCamera,
            2,
            this.config.rotate,
            null as unknown as string, null as unknown as string, false
            )
        if (this.config.checkZ) {
            this.updateIsInMarkerState(coords.isInsideSphere(this.config.position, this.config.scale || Vector3.create(1)))
        } else {
            const dsquared = coords.distanceSquared(this.config.position)
            const scale = this.config.scale|| Vector3.create(1)
            this.updateIsInMarkerState((dsquared <= (scale.x / 2) ** 2) || (dsquared <= (scale.y / 2) ** 2))
        }
    }

    public isInDrawRange(_optPed?: number, _optCoords?: Vector3) {
        const ped = _optPed ?? PlayerPedId()
        const coords = _optCoords ?? Vector3.fromArr(GetEntityCoords(ped, true))
        return (this.config.checkZ ? coords.distance(this.config.position) : coords.distanceNoZ(this.config.position)) <= (this.config.distance ?? 250)
    }

    /**
     * Can set any value of the marker config using the key and value
     * @param key
     * @param value
     */
    public setConfigValue<T extends keyof MarkerConfiguration>(key: T, value: MarkerConfiguration[T]) {
        this.config[key] = value
    }

    public isPlayerInside() {
        return this.isInMkr
    }

    private getHandlersForMarkerState(state: boolean): [MarkerEventHandlerSig[], "IN" | "OUT"] {
        const cAction = state ? "IN" : "OUT"
        return [this.eventHandlers.filter(([onAction]) => [cAction, "BOTH"].includes(onAction)).map(x => x[1]), cAction]
    }

    private updateIsInMarkerState(state: boolean) {
        if (this.isInMkr !== state) {
            const [handlers, action] = this.getHandlersForMarkerState(state)
            this.isInMkr = state //set this before calling the listeners so if the handlers access the instance, they will get up to date info
            handlers.forEach(func => func(this, action))
        } else {
            this.isInMkr = state
        }
    }

    /**
     * The provided callback will get called when the player enters the marker
     * Returns a cleanup function that will remove the listener when called.
     * @param handler
     */
    public onEnter(handler: MarkerEventHandlerSig) {
        return this.registerEventHandler("IN", handler)
    }
    /**
     * The provided callback will get called when the player leaves the marker.
     * Returns a cleanup function that will remove the listener when called.
     * @param handler
     */
    public onLeave(handler: MarkerEventHandlerSig) {
        return this.registerEventHandler("OUT", handler)
    }

    /**
     * The provided callback will get called when the player leaves or enters the marker.
     * Returns a cleanup function that will remove the listener when called.
     * @param handler
     */
    public onEnterOrLeave(handler: MarkerEventHandlerSig) {
        return this.registerEventHandler("BOTH", handler)
    }

    private registerEventHandler(forType: "IN" | "OUT" | "BOTH", handler: MarkerEventHandlerSig) {
        const ix =  this.eventHandlers.push([forType, handler])
        return () => {
            delete this.eventHandlers[ix]
        }
    }

    /**
     * Returns a promise that will resolve when the player enters the marker.
     * If the player is already inside, the promise will instantly resolve.
     */
    public nextEnter(): Promise<true> {
        return new Promise(resolve => {
            if (this.isPlayerInside()) return resolve(true)
            const cleanup = this.onEnter(() => {
                resolve(true)
                cleanup()
            })
        })
    }

    /**
     * Returns a promise that will resolve when the player leaves the marker.
     * Unlike `nextEnter()` this **WILL NOT** resolve if the player is already outside of the marker.
     */
    public nextLeave(): Promise<true> {
        return new Promise(resolve => {
            const cleanup = this.onLeave(() => {
                resolve(true)
                cleanup()
            })
        })
    }

    /**
     * Returns a promise that will resolve when the player leaves or enters this promise. The resolved value will indicate what happened.
     */
    public enterOrLeave(): Promise<"IN" | "OUT"> {
        return new Promise(resolve => {
            const cleanup = this.onEnterOrLeave((_, newState) => {
                resolve(newState)
                cleanup()
            })
        })
    }

}