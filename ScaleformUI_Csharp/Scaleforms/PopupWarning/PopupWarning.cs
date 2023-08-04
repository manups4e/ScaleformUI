using CitizenFX.Core;

namespace ScaleformUI.Scaleforms
{

    public enum WarningPopupType
    {
        Classic,
        Serious
    }
    public delegate void PopupWarningEvent(InstructionalButton button);

    public class PopupWarning
    {
        internal ScaleformWideScreen _sc;
        private bool _disableControls;
        private List<InstructionalButton> _buttonList;

        /// <summary>
        /// Returns <see langword="true"/> if the PopupWarning scaleform is drawing currently
        /// </summary>
        public bool IsShowing
        {
            get => _sc != null;
        }

        public bool IsShowingWithButtons
        {
            get => _disableControls;
        }

        public event PopupWarningEvent OnButtonPressed;

        private async Task Load()
        {
            if (_sc != null) return;
            _sc = new ScaleformWideScreen("POPUP_WARNING");
            int timeout = 1000;
            int start = Main.GameTime;
            while (!_sc.IsLoaded && Main.GameTime - start < timeout) await BaseScript.Delay(0);
        }

        /// <summary>
        /// Disposes the Warning scaleform.
        /// </summary>
        public void Dispose()
        {
            if (_sc == null) return;
            _sc.CallFunction("HIDE_POPUP_WARNING", 1000);
            _sc.Dispose();
            _sc = null;
            _disableControls = false;
        }

        /// <summary>
        /// Show the Warning scaleform to the user.
        /// </summary>
        /// <param name="title">Title of the Warning (if empty defaults to "Warning")</param>
        /// <param name="subtitle">Subtitle of the Warning</param>
        /// <param name="prompt">Prompt usually is used for asking to confirm or cancel (can be anything)</param>
        /// <param name="errorMsg">This string will be shown in the Left-Bottom of the screen as error code or error message</param>
        /// <param name="type">Type of the Warning</param>
        public async void ShowWarning(string title, string subtitle, string prompt = "", string errorMsg = "", WarningPopupType type = WarningPopupType.Classic, bool showBackground = true)
        {
            await Load();
            _sc.CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, showBackground, (int)type, errorMsg);
        }

        /// <summary>
        /// Updates the current Warning, this is used to change any text in the current warning screen.
        /// </summary>
        /// <param name="title">Title of the Warning (if empty defaults to "Warning")</param>
        /// <param name="subtitle">Subtitle of the Warning</param>
        /// <param name="prompt">Prompt usually is used for asking to confirm or cancel (can be anything)</param>
        /// <param name="errorMsg">This string will be shown in the Left-Bottom of the screen as error code or error message</param>
        /// <param name="type">Type of the Warning</param>
        public void UpdateWarning(string title, string subtitle, string prompt = "", string errorMsg = "", WarningPopupType type = WarningPopupType.Classic, bool showBackground = true)
        {
            if (!_sc.IsLoaded) return;
            _sc.CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, showBackground, (int)type, errorMsg);
        }

        /// <summary>
        /// Show the Warning scaleform to the user and awaits for user input
        /// </summary>
        /// <param name="title">Title of the Warning (if empty defaults to "Warning")</param>
        /// <param name="subtitle">Subtitle of the Warning</param>
        /// <param name="prompt">Prompt usually is used for asking to confirm or cancel (can be anything)</param>
        /// <param name="errorMsg">This string will be shown in the Left-Bottom of the screen as error code or error message</param>
        /// <param name="buttons">List of <see cref="InstructionalButton"/> to show to the user (the user can select with GamePad, Keyboard or Mouse) </param>
        /// <param name="type"></param>
        public async void ShowWarningWithButtons(string title, string subtitle, string prompt, List<InstructionalButton> buttons, string errorMsg = "", WarningPopupType type = WarningPopupType.Classic, bool showBackground = true)
        {
            await Load();
            _disableControls = true;
            _buttonList = buttons;
            if (buttons == null || buttons.Count == 0) return;
            Main.InstructionalButtons.UseMouseButtons = true;
            Main.InstructionalButtons.SetInstructionalButtons(_buttonList);
            Main.InstructionalButtons.ControlButtons.ForEach(x => x.OnControlSelected += OnControlSelected);
            _sc.CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, showBackground, (int)type, errorMsg);
        }

        private void OnControlSelected(InstructionalButton control)
        {
            Dispose();
            OnButtonPressed?.Invoke(control);
            Main.InstructionalButtons.ClearButtonList();
            Main.InstructionalButtons.UseMouseButtons = false;
            OnButtonPressed = null;
            if (MenuHandler.CurrentMenu != null)
            {
                if (MenuHandler.CurrentMenu.InstructionalButtons.Count > 0)
                    Main.InstructionalButtons.SetInstructionalButtons(MenuHandler.CurrentMenu.InstructionalButtons);
            }
            else if (MenuHandler.currentBase != null)
            {
                if (MenuHandler.currentBase.InstructionalButtons.Count > 0)
                    Main.InstructionalButtons.SetInstructionalButtons(MenuHandler.currentBase.InstructionalButtons);
            }
        }

        internal void Update()
        {
            _sc.Render2D();
        }
    }
}
