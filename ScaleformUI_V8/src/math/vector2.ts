export interface Vec2 {
    x: number;
    y: number;
}
export type PrimitiveVector2 = [number, number]

/**
 * Immutable Vector class, partially done by me and by other authors.
 */
export class Vector2 implements Vec2 {

    public static get zero():Vector2 {
        return new Vector2(0, 0)
    }
    public static create(v1: number | Vec2): Vector2 {
        if (typeof v1 === "number") {
            return new Vector2(v1, v1);
        }
        return new Vector2(v1.x, v1.y);
    }

    public static clone(v1: Vec2): Vector2 {
        return Vector2.create(v1);
    }

    public static add(v1: Vec2, v2: number | Vec2): Vector2 {
        if (typeof v2 === "number") {
            return new Vector2(v1.x + v2, v1.y + v2);
        }
        return new Vector2(v1.x + v2.x, v1.y + v2.y);
    }

    public static subtract(v1: Vec2, v2: Vec2): Vector2 {
        return new Vector2(v1.x - v2.x, v1.y - v2.y);
    }

    public static multiply(v1: Vec2, v2: Vec2 | number): Vector2 {
        if (typeof v2 === "number") {
            return new Vector2(v1.x * v2, v1.y * v2);
        }
        return new Vector2(v1.x * v2.x, v1.y * v2.y);
    }

    public static divide(v1: Vec2, v2: Vec2 | number): Vector2 {
        if (typeof v2 === "number") {
            return new Vector2(v1.x / v2, v1.y / v2);
        }
        return new Vector2(v1.x / v2.x, v1.y / v2.y);
    }

    public static dotProduct(v1: Vec2, v2: Vec2): number {
        return v1.x * v2.x + v1.y * v2.y;
    }

    public static crossProduct(v1: Vec2, v2: Vec2): number {
        return v1.x * v2.y - v1.y * v2.x;

    }

    public static normalize(v: Vector2): Vector2 {
        return Vector2.divide(v, v.length);
    }

    constructor(public x: number, public y: number) { }

    public static fromInterface(int: Vec2) {
        return new Vector2(int.x, int.y)
    }

    public clone(): Vector2 {
        return new Vector2(this.x, this.y);
    }

    /**
     * The product of the Euclidean magnitudes of this and another Vector2.
     *
     * @param v Vector2 to find Euclidean magnitude between.
     * @returns Euclidean magnitude with another vector.
     */
    public distanceSquared(v: Vec2): number {
        const w: Vector2 = this.subtract(v);
        return Vector2.dotProduct(w, w);
    }

    /**
     * The distance between two Vectors.
     *
     * @param v Vector2 to find distance between.
     * @returns Distance between this and another vector.
     */
    public distance(v: Vec2): number {
        return Math.sqrt(this.distanceSquared(v));
    }

    public distanceNoZ(v: Vec2): number {
        const dx = this.x - v.x;
        const dy = this.y - v.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public get normalize(): Vector2 {
        return Vector2.normalize(this);
    }

    public crossProduct(v: Vec2): number {
        return Vector2.crossProduct(this, v);
    }

    public dotProduct(v: Vec2): number {
        return Vector2.dotProduct(this, v);
    }

    public add(v: number | Vec2): Vector2 {
        return Vector2.add(this, v);
    }

    public subtract(v: Vec2): Vector2 {
        return Vector2.subtract(this, v);
    }

    public multiply(v: number | Vec2): Vector2 {
        return Vector2.multiply(this, v);
    }

    public divide(v: number | Vec2): Vec2 {
        return Vector2.divide(this, v);
    }

    public replace(v: Vec2): void {
        this.x = v.x;
        this.y = v.y;
    }

    public get length(): number {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    }

    public static fromArr(arr: number[]) {
        return new Vector2(arr[0], arr[1]);
    }

    public static fromArrays(arrs: number[][]) {
        return arrs.map(Vector2.fromArr);
    }
    public toJSON() {
        return `[${this.x}, ${this.y}]`;
    }
    public toArr(): PrimitiveVector2 {
        return [this.x, this.y];
    }

    public display() {
        return `X: ${this.x}, Y: ${this.y}`;
    }

    public toFixed(frac: number) {
        return new Vector2(parseFloat(this.x.toFixed(frac)), parseFloat(this.y.toFixed(frac)))
    }

    public addX(to: number) {
        return new Vector2(this.x + to, this.y)
    }
    public addY(to: number) {
        return new Vector2(this.x, this.y + to)
    }
    public addZ(to: number) {
        return new Vector2(this.x, this.y)
    }

    public toObject(): Vec2 {
        return { x: this.x, y: this.y }
    }

    public cloneWith(angle: "x" | "y", value: number) {
        return new Vector2(angle === "x" ? value : this.x, angle === "y" ? value : this.y)
    }

    public get magnitude() {
        return Math.sqrt(this.dotProduct(this))
    }

    public isInsideSphere(pos: Vector2, scale: Vector2) {
        const dist = this.subtract(pos)
        const rad = scale.magnitude / 2
        return dist.magnitude <= rad
    }
}
