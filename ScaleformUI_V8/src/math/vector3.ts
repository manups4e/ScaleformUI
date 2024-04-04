export interface Vec3 {
    x: number;
    y: number;
    z: number;
}
export type PrimitiveVector3 = [number, number, number]

/**
 * Immutable Vector class, partially done by me and by other authors.
 */
export class Vector3 implements Vec3 {

    public static zero() {
        return new Vector3(0, 0, 0)
    }
    public static create(v1: number | Vec3): Vector3 {
        if (typeof v1 === "number") {
            return new Vector3(v1, v1, v1);
        }
        return new Vector3(v1.x, v1.y, v1.z);
    }

    public static clone(v1: Vec3): Vector3 {
        return Vector3.create(v1);
    }

    public static add(v1: Vec3, v2: number | Vec3): Vector3 {
        if (typeof v2 === "number") {
            return new Vector3(v1.x + v2, v1.y + v2, v1.z + v2);
        }
        return new Vector3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
    }

    public static subtract(v1: Vec3, v2: Vec3): Vector3 {
        return new Vector3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
    }

    public static multiply(v1: Vec3, v2: Vec3 | number): Vector3 {
        if (typeof v2 === "number") {
            return new Vector3(v1.x * v2, v1.y * v2, v1.z * v2);
        }
        return new Vector3(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
    }

    public static divide(v1: Vec3, v2: Vec3 | number): Vector3 {
        if (typeof v2 === "number") {
            return new Vector3(v1.x / v2, v1.y / v2, v1.z / v2);
        }
        return new Vector3(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z);
    }

    public static dotProduct(v1: Vec3, v2: Vec3): number {
        return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
    }

    public static crossProduct(v1: Vec3, v2: Vec3): Vector3 {
        const x = v1.y * v2.z - v1.z * v2.y;
        const y = v1.z * v2.x - v1.z * v2.z;
        const z = v1.x * v2.y - v1.z * v2.x;
        return new Vector3(x, y, z);
    }

    public static normalize(v: Vector3): Vector3 {
        return Vector3.divide(v, v.length);
    }

    constructor(public x: number, public y: number, public z: number) {}

    public static fromInterface(int: Vec3) {
        return new Vector3(int.x, int.y, int.z)
    }

    public clone(): Vector3 {
        return new Vector3(this.x, this.y, this.z);
    }

    /**
     * The product of the Euclidean magnitudes of this and another Vector3.
     *
     * @param v Vector3 to find Euclidean magnitude between.
     * @returns Euclidean magnitude with another vector.
     */
    public distanceSquared(v: Vec3): number {
        const w: Vector3 = this.subtract(v);
        return Vector3.dotProduct(w, w);
    }

    /**
     * The distance between two Vectors.
     *
     * @param v Vector3 to find distance between.
     * @returns Distance between this and another vector.
     */
    public distance(v: Vec3): number {
        return Math.sqrt(this.distanceSquared(v));
    }

    public distanceNoZ(v: Vec3): number {
        const dx = this.x - v.x;
        const dy = this.y - v.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public get normalize(): Vector3 {
        return Vector3.normalize(this);
    }

    public crossProduct(v: Vec3): Vector3 {
        return Vector3.crossProduct(this, v);
    }

    public dotProduct(v: Vec3): number {
        return Vector3.dotProduct(this, v);
    }

    public add(v: number | Vec3): Vector3 {
        return Vector3.add(this, v);
    }

    public subtract(v: Vec3): Vector3 {
        return Vector3.subtract(this, v);
    }

    public multiply(v: number | Vec3): Vector3 {
        return Vector3.multiply(this, v);
    }

    public divide(v: number | Vec3): Vec3 {
        return Vector3.divide(this, v);
    }

    public replace(v: Vec3): void {
        this.x = v.x;
        this.y = v.y;
        this.z = v.z;
    }

    public get length(): number {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
    }

    public static fromArr(arr: number[]) {
        return new Vector3(arr[0], arr[1], arr[2]);
    }

    public static fromArrays(arrs: number[][]) {
        return arrs.map(Vector3.fromArr);
    }
    public toJSON() {
        return `[${this.x}, ${this.y}, ${this.z}]`;
    }
    public toArr(): PrimitiveVector3 {
        return [this.x, this.y, this.z];
    }

    public display() {
        return `X: ${this.x}, Y: ${this.y}, Z: ${this.z}`;
    }

    public toFixed(frac: number) {
        return new Vector3(parseFloat(this.x.toFixed(frac)), parseFloat(this.y.toFixed(frac)), parseFloat(this.z.toFixed(frac)))
    }

    public addX(to: number) {
        return new Vector3(this.x + to, this.y, this.z)
    }
    public addY(to: number) {
        return new Vector3(this.x, this.y + to, this.z)
    }
    public addZ(to: number) {
        return new Vector3(this.x, this.y, this.z + to)
    }

    public toObject(): Vec3 {
        return {x: this.x, y: this.y, z: this.z}
    }

    public cloneWith(angle: "x" | "y" | "z", value: number) {
        return new Vector3(angle === "x" ? value : this.x, angle === "y" ? value : this.y, angle === "z" ? value : this.z)
    }

    public get magnitude() {
        return Math.sqrt(this.dotProduct(this))
    }

    public isInsideSphere(pos: Vector3, scale: Vector3) {
        const dist = this.subtract(pos)
        const rad = scale.magnitude / 2
        return dist.magnitude <= rad
    }
}
