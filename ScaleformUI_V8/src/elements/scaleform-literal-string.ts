export class ScaleformLiteralString {
    private readonly _literalString: string;

    constructor(literalString: string) {
        this._literalString = literalString;
    }

    get LiteralString(): string {
        return this._literalString;
    }

    equals(obj: Object): boolean {
        if (!(obj instanceof ScaleformLiteralString)) {
            return false;
        }
        const otherLiteralString = obj as ScaleformLiteralString;
        return this.LiteralString === otherLiteralString.LiteralString;
    }
}

function implicitOperator(literalString: string): ScaleformLiteralString {
    return new ScaleformLiteralString(literalString);
}

function operatorEquals(a: ScaleformLiteralString, b: ScaleformLiteralString): boolean {
    return a.equals(b);
}

function operatorNotEquals(a: ScaleformLiteralString, b: ScaleformLiteralString): boolean {
    return !operatorEquals(a, b);
}