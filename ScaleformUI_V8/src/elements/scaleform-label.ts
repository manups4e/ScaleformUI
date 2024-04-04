export class ScaleformLabel {
    private readonly _label: string;

    constructor(label: string) {
        this._label = label;
    }

    get Label(): string {
        return this._label;
    }

    equals(obj: Object): boolean {
        if (!(obj instanceof ScaleformLabel)) {
            return false;
        }
        const otherLabel = obj as ScaleformLabel;
        return this.Label === otherLabel.Label;
    }
}

function implicitOperator(label: string): ScaleformLabel {
    return new ScaleformLabel(label);
}

function operatorEquals(a: ScaleformLabel, b: ScaleformLabel): boolean {
    return a.equals(b);
}

function operatorNotEquals(a: ScaleformLabel, b: ScaleformLabel): boolean {
    return !operatorEquals(a, b);
}