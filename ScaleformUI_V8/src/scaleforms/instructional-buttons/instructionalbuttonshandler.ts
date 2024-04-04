import { Scaleform } from "scaleforms/scaleform";
import { InstructionalButton, PadCheck } from "./instructionalbutton";
import { Delay, noop, waitUntilReturns } from "helpers/loaders";
import { ScaleformUI } from "scaleforms/scaleformui/main";

export enum LoadingSpinnerType {
    Clockwise1 = 1,
    Clockwise2,
    Clockwise3,
    SocialClubSaving,
    RegularClockwise
}

export class InstructionalButtonsHandler {
    _sc: Scaleform;
    public UseMouseButtons: boolean;
    _isUsingKeyboard: boolean;
    _changed: boolean = true;
    savingTimer: number = 0;
    private _isSaving: boolean = false;
    public ControlButtons: InstructionalButton[] = []
    private keyboardButtons: InstructionalButton[] = []
    private gamepadButtons: InstructionalButton[] = []

    constructor() {
        this.ControlButtons = [];
        this.Load();
    }

    public get IsSaving(): boolean { return this._isSaving; }

    async Load() {
        if (this._sc) return
        this._sc = Scaleform.request("instructional_buttons")
        const start = GetGameTimer()
        const to = 1000
        await waitUntilReturns(noop, () => this._sc!.isLoaded && GetGameTimer() - start < to, true, 0)
        let [w, h] = GetActiveScreenResolution();
        this._sc!.callFunction("SET_DISPLAY_CONFIG", 1280, 720, 0.05, 0.95, 0.05, 0.95, true, false, false, w, h)
    }

    public SetInstructionalButtons(buttons: InstructionalButton[]) {
        this.ControlButtons = buttons;
        this._changed = true;
    }

    public AddInstructionalButton(button: InstructionalButton) {
        this.ControlButtons.push(button);
        this._changed = true;
    }

    public RemoveInstructionalButton(button: InstructionalButton) {
        if (this.ControlButtons.includes(button)) {
            this.ControlButtons.splice(this.ControlButtons.indexOf(button), 1);
        }
        this._changed = true;
    }
    public RemoveInstructionalButton(idx: number) {
        if (this.ControlButtons.length >= idx) {
            this.RemoveInstructionalButton(this.ControlButtons[idx]);
        }
        this._changed = true;
    }
    public RemoveInstructionalButtons(buttons: InstructionalButton[]) {
        buttons.forEach((x: InstructionalButton) => {
            this.RemoveInstructionalButton(x);
        });
        this._changed = true;
    }
    public ClearButtonList() {
        if (this.ControlButtons.length > 0) {
            this.ControlButtons.length = 0;
        }
        this._changed = true;
        this._sc.callFunction("CLEAR_ALL")
        this._sc.callFunction("CLEAR_RENDER")
    }
    public async AddSavingText(spinnerType: LoadingSpinnerType, text: string, time: number) {
        this._isSaving = true;
        this._changed = true;
        this.savingTimer = GetGameTimer();
        this.showLoadingPrompt(spinnerType, text);
        if (time != undefined && time > 0) {
            while (GetGameTimer() - this.savingTimer <= time) await Delay(100);
            RemoveLoadingPrompt();
        }
        this._isSaving = false;

    }

    private showLoadingPrompt(spinnerType: LoadingSpinnerType, text: string) {
        if (IsLoadingPromptBeingDisplayed()) {
            RemoveLoadingPrompt();
        }

        if (text == undefined) {
            BeginTextCommandBusyString("");
        } else {
            BeginTextCommandBusyString("STRING");
            AddTextComponentSubstringPlayerName(text);
        }
        EndTextCommandBusyString(spinnerType);
    }

    public HideSavingText() {
        if (this._isSaving) {
            if (IsLoadingPromptBeingDisplayed()) {
                RemoveLoadingPrompt();
            }
            this._isSaving = false;
        }
    }

    updateButtons() {
        if (!this._changed) return;
        this.keyboardButtons.length = 0;
        this.gamepadButtons.length = 0;

        this._sc.callFunction("SET_DATA_SLOT_EMPTY");
        this._sc.callFunction("TOGGLE_MOUSE_BUTTONS", this.UseMouseButtons);
        let count = 0;

        for (let i = 0; i < this.ControlButtons.length; i++) {
            let button = this.ControlButtons[i];
            if (button.IsUsingController) {
                if (button.PadCheck == PadCheck.Keyboard) {
                    continue;
                }
                this.gamepadButtons.push(button);
                if (ScaleformUI.Scaleforms.Warning.IsShowing || ScaleformUI.Scaleforms.Warning.IsShowingWithButtons)
                    this._sc.callFunction("SET_DATA_SLOT", count, button.GetButtonId(), button.Text, 0, -1);
                else
                    this._sc.callFunction("SET_DATA_SLOT", count, button.GetButtonId(), button.Text);
            }
            else {
                if (button.PadCheck == PadCheck.Controller) {
                    continue;
                }
                this.keyboardButtons.push(button);
                if (this.UseMouseButtons)
                    this._sc.callFunction("SET_DATA_SLOT", count, button.GetButtonId(), button.Text, 1, button.KeyboardButton);
                else {
                    if (ScaleformUI.Scaleforms.Warning.IsShowing || ScaleformUI.Scaleforms.Warning.IsShowingWithButtons)
                        this._sc.callFunction("SET_DATA_SLOT", count, button.GetButtonId(), button.Text, 0, -1);
                    else
                        this._sc.callFunction("SET_DATA_SLOT", count, button.GetButtonId(), button.Text);

                }

            }
            count++;
        }
        this._sc.callFunction("DRAW_INSTRUCTIONAL_BUTTONS", -1);
        this._changed = false;

    }

    Draw() {
        SetScriptGfxDrawBehindPausemenu(true);
        this._sc.render2d();
    }

    Update() {
        if (this.ControlButtons.length == 0) return;
        if (!this._sc) this.Load();
        if (IsUsingKeyboard(2)) {
            if (!this._isUsingKeyboard) {
                this._isUsingKeyboard = true;
                this._changed = true;
            }
        } else {
            if (this._isUsingKeyboard) {
                this._isUsingKeyboard = false;
                this._changed = true;
            }
        }
        this.updateButtons();

        if (!ScaleformUI.Scaleforms.Warning.IsShowing || ScaleformUI.Scaleforms.Warning.IsShowingWithButtons)
            this.Draw();

        this.keyboardButtons.forEach((button: InstructionalButton) => {
            if (this.IsControlJustPressed(button.KeyboardButton, button.PadCheck) || (button.KeyboardButtons != null && button.KeyboardButtons.some(x => this.IsControlJustPressed(x, button.PadCheck))))
                button.InvokeEvent(button);
        })
        this.gamepadButtons.forEach((button: InstructionalButton) => {
            if (this.IsControlJustPressed(button.GamepadButton, button.PadCheck) || (button.GamepadButtons != null && button.GamepadButtons.some(x => this.IsControlJustPressed(x, button.PadCheck))))
                button.InvokeEvent(button);
        })
        if (this.UseMouseButtons)
            ShowCursorThisFrame();
        HideHudComponentThisFrame(6);
        HideHudComponentThisFrame(7);
        HideHudComponentThisFrame(9);
    }

    public IsControlJustPressed(control: number, keyboardOnly: PadCheck): boolean {
        return IsControlJustPressed(2, control) && (keyboardOnly == PadCheck.Keyboard ? IsUsingKeyboard(2) : keyboardOnly != PadCheck.Controller || !IsUsingKeyboard(2));
    }

    public ForceUpdate() { this._changed = true }

}