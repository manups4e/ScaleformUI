export class Rgba {
    public static empty = new Rgba(0, 0, 0, 0);
    public static transparent = new Rgba(0, 0, 0, 0);
    public static black = new Rgba(255, 0, 0, 0);
    public static white = new Rgba(255, 255, 255, 255);
    public static whiteSmoke = new Rgba(255, 245, 245, 245);

    public static fromArgb(a: number, r: number, g: number, b: number): Rgba {
        return new Rgba(a, r, g, b);
    }

    public static fromRgb(r: number, g: number, b: number): Rgba {
        return new Rgba(255, r, g, b);
    }

    public static fromArr([r, g, b, a]: [number, number, number, number]) {
        return new Rgba(r, g, b, a)
    }

    public toArr(): [number, number, number, number] {
        return [this.r, this.g, this.b, this.a]
    }


    constructor(public readonly a = 255,
                public readonly r: number,
                public readonly g: number,
                public readonly b: number) {}
}