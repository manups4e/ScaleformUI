import { UIMenuItem } from "menus/UIMenu/items/uimenuitem";
import { InstructionalButtonSelectedEventBuilder, InstructionalButtonSelectedEvent } from '../../menus/UIMenu/emitters/emitters';

export enum PadCheck {
    Any = 0,
    Keyboard = 1,
    Controller = 2
}

export enum InputGroup {
    UNUSED = -1,
    INPUTGROUP_MOVE = 0,
    INPUTGROUP_LOOK = 1,
    INPUTGROUP_WHEEL = 2,
    INPUTGROUP_CELLPHONE_NAVIGATE = 3,
    INPUTGROUP_CELLPHONE_NAVIGATE_UD = 4,
    INPUTGROUP_CELLPHONE_NAVIGATE_LR = 5,
    INPUTGROUP_FRONTEND_DPAD_ALL = 6,
    INPUTGROUP_FRONTEND_DPAD_UD = 7,
    INPUTGROUP_FRONTEND_DPAD_LR = 8,
    INPUTGROUP_FRONTEND_LSTICK_ALL = 9,
    INPUTGROUP_FRONTEND_RSTICK_ALL = 10,
    INPUTGROUP_FRONTEND_GENERIC_UD = 11,
    INPUTGROUP_FRONTEND_GENERIC_LR = 12,
    INPUTGROUP_FRONTEND_GENERIC_ALL = 13,
    INPUTGROUP_FRONTEND_BUMPERS = 14,
    INPUTGROUP_FRONTEND_TRIGGERS = 15,
    INPUTGROUP_FRONTEND_STICKS = 16,
    INPUTGROUP_SCRIPT_DPAD_ALL = 17,
    INPUTGROUP_SCRIPT_DPAD_UD = 18,
    INPUTGROUP_SCRIPT_DPAD_LR = 19,
    INPUTGROUP_SCRIPT_LSTICK_ALL = 20,
    INPUTGROUP_SCRIPT_RSTICK_ALL = 21,
    INPUTGROUP_SCRIPT_BUMPERS = 22,
    INPUTGROUP_SCRIPT_TRIGGERS = 23,
    INPUTGROUP_WEAPON_WHEEL_CYCLE = 24,
    INPUTGROUP_FLY = 25,
    INPUTGROUP_SUB = 26,
    INPUTGROUP_VEH_MOVE_ALL = 27,
    INPUTGROUP_CURSOR = 28,
    INPUTGROUP_CURSOR_SCROLL = 29,
    INPUTGROUP_SNIPER_ZOOM_SECONDARY = 30,
    INPUTGROUP_VEH_HYDRAULICS_CONTROL = 31,
};

export class InstructionalButton {
    Text: string;
    ItemBind: UIMenuItem
    GamepadButton: number
    KeyboardButton: number
    InputGroupButton: InputGroup = InputGroup.UNUSED;
    GamepadButtons: number[] = []
    KeyboardButtons: number[] = []
    PadCheck: PadCheck = PadCheck.Any;
    public get IsUsingController(): boolean { return !IsUsingKeyboard(2); }
    _InstructionalButtonSelected = new InstructionalButtonSelectedEventBuilder();

    constructor(text: string, padcheck: number, gamepadControls: number | number[], keyboardControls: number | number[], inputGroup: InputGroup) {
        this.Text = text;
        this.GamepadButtons = [],
            this.GamepadButton = -1,
            this.KeyboardButtons = [],
            this.KeyboardButton = -1,
            this.PadCheck = padcheck

        if (Array.isArray(gamepadControls)) {
            if (padcheck == 0 || padcheck == -1) {
                this.GamepadButtons = gamepadControls
            }
        } else {
            if (padcheck == 0 || padcheck == -1)
                this.GamepadButton = gamepadControls
            else
                this.GamepadButton = -1;
        }

        if (Array.isArray(keyboardControls)) {
            if (padcheck == 0 || padcheck == -1) {
                this.KeyboardButtons = keyboardControls
            }
        } else {
            if (padcheck == 0 || padcheck == -1)
                this.KeyboardButton = keyboardControls
            else
                this.KeyboardButton = -1;
        }
        this.InputGroupButton = inputGroup;
    }

    public OnControlSelected(delegate: InstructionalButtonSelectedEvent) {
        this._InstructionalButtonSelected.add(delegate);
    }

    public BindToItem(item: UIMenuItem) {
        this.ItemBind = item;
    }

    public GetButtonId(): string {
        if (this.KeyboardButtons.length != 0 || this.GamepadButtons.length != 0) {
            let retVal = "";
            if (this.IsUsingController) {
                for (let i = this.GamepadButtons.length - 1; i > -1; i--) {
                    if (i == 0)
                        retVal += GetControlInstructionalButton(2, this.GamepadButtons[i], true);
                    else
                        retVal += GetControlInstructionalButton(2, this.GamepadButtons[i], true) + "%";
                }
            }
            else {
                for (let i = this.KeyboardButtons.length - 1; i > -1; i--) {
                    if (i == 0)
                        retVal += GetControlInstructionalButton(2, this.KeyboardButtons[i], true);
                    else
                        retVal += GetControlInstructionalButton(2, this.KeyboardButtons[i], true) + "%";
                }
            }
            return retVal;
        }
        else if (this.InputButton != InputGroup.UNUSED) return `~${this.InputButton}~`;
        return this.IsUsingController ? GetControlInstructionalButton(2, this.GamepadButton, true) : GetControlInstructionalButton(0, this.KeyboardButton, true);
    }

    InvokeEvent(control: InstructionalButton) {
        if (UpdateOnscreenKeyboard() == 0) return;
        this._InstructionalButtonSelected.toDelegate()(control);
    }
}