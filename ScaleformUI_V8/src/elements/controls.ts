export class Controls {
    public static NecessaryControlsKeyboard = [
        201, 195, 196, 187, 188, 189, 190, 202, 217, 242, 241, 239, 240, 237, 238,
        31, 30, 21, 22, 23, 75, 71, 72, 59, 89, 9, 8, 90, 76,
    ]
    public static NecessaryControlsGamePad = [
        201, 195, 196, 187, 188, 189, 190, 202, 217, 242, 241, 239, 240, 237, 238,
        31, 30, 21, 22, 23, 75, 71, 72, 59, 89, 9, 8, 90, 76, 2, 1, 25, 24, 71, 72,
        59, 31, 30, 75,
    ]

    public static toggleAll(toggle: boolean) {
        if (toggle) {
            EnableAllControlActions(0)
            EnableAllControlActions(1)
            EnableAllControlActions(2)
        } else {
            DisableAllControlActions(2);
            (IsUsingKeyboard(2) ? this.NecessaryControlsKeyboard : this.NecessaryControlsGamePad)
                .forEach(ctrl => EnableControlAction(0, ctrl, true))
        }
    }
}
