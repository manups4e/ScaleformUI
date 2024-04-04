import {Controls} from "./controls";

describe("Controls test", () => {
    const setupGlobalMocks = (disableMock: jest.Mock, enableMock: jest.Mock, isUsingKeyboardMock: jest.Mock) => {
        global.DisableAllControlActions = disableMock;
        global.EnableControlAction = enableMock;
        global.IsUsingKeyboard = isUsingKeyboardMock;
    };

    const verifyControlToggle = (mock: jest.Mock, expectedCallTimes: number, expectedArg: number) => {
        expect(mock).toHaveBeenCalledTimes(expectedCallTimes);
        expect(mock).toHaveBeenCalledWith(expectedArg);
    };

    const verifyControlAction = (mock: jest.Mock, controlsArray: number[]) => {
        controlsArray.forEach(control =>
            expect(mock).toHaveBeenCalledWith(0, control, true)
        );
        expect(mock).toHaveBeenCalledTimes(controlsArray.length);
    };

    it("should enable control action 0-2", () => {
        const mock = jest.fn();
        global.EnableAllControlActions = mock;
        Controls.toggleAll(true);
        verifyControlToggle(mock, 3, 0);
        verifyControlToggle(mock, 3, 1);
        verifyControlToggle(mock, 3, 2);
    });

    it.each([
        [true, Controls.NecessaryControlsKeyboard],
        [false, Controls.NecessaryControlsGamePad]
    ])("should toggle all controls based on keyboard or gamepad usage", (usingKeyboard, expectedControls) => {
        const disableMock = jest.fn();
        const enableMock = jest.fn();
        const isUsingKeyboardMock = jest.fn(() => usingKeyboard);
        setupGlobalMocks(disableMock, enableMock, isUsingKeyboardMock);
        Controls.toggleAll(false);
        verifyControlToggle(isUsingKeyboardMock, 1, 2);
        verifyControlToggle(disableMock, 1, 2);
        verifyControlAction(enableMock, expectedControls);
    });
});