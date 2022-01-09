using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using CitizenFX.Core;

namespace ScaleformUI
{

    public enum WarningPopupType
	{
		Classic,
		Serious
	}
	public delegate void PopupWarningEvent(InstructionalButton button);

	public class PopupWarning
	{
		private Scaleform _warning;
		private bool _disableControls;
		private List<InstructionalButton> _buttonList;

		/// <summary>
		/// Returns <see langword="true"/> if the PopupWarning scaleform is drawing currently
		/// </summary>
		public bool IsShowing
		{
			get => _warning != null;
		}

		public event PopupWarningEvent OnButtonPressed;

		private async Task Load()
		{
			if (_warning != null) return;
			_warning = new Scaleform("POPUP_WARNING");
			int timeout = 1000;
			DateTime start = DateTime.Now;
			while (!_warning.IsLoaded && DateTime.Now.Subtract(start).TotalMilliseconds < timeout) await BaseScript.Delay(0);
		}

		/// <summary>
		/// Disposes the Warning scaleform.
		/// </summary>
		public void Dispose()
		{
			_warning.CallFunction("HIDE_POPUP_WARNING", 1000);
			_warning.Dispose();
			_warning = null;
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
		public async void ShowWarning(string title, string subtitle, string prompt = "", string errorMsg = "", WarningPopupType type = WarningPopupType.Classic)
		{
			await Load();
			_warning.CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, true, (int)type, errorMsg);
		}

		public async void ShowWarning(string title, string subtitle, int ms, string prompt = "", string errorMsg = "", WarningPopupType type = WarningPopupType.Classic)
		{
			await Load();
			_warning.CallFunction("SHOW_POPUP_WARNING", ms, title, subtitle, prompt, true, (int)type, errorMsg);
		}
		/// <summary>
		/// Updates the current Warning, this is used to change any text in the current warning screen.
		/// </summary>
		/// <param name="title">Title of the Warning (if empty defaults to "Warning")</param>
		/// <param name="subtitle">Subtitle of the Warning</param>
		/// <param name="prompt">Prompt usually is used for asking to confirm or cancel (can be anything)</param>
		/// <param name="errorMsg">This string will be shown in the Left-Bottom of the screen as error code or error message</param>
		/// <param name="type">Type of the Warning</param>
		public void UpdateWarning(string title, string subtitle, string prompt = "", string errorMsg = "", WarningPopupType type = WarningPopupType.Classic)
		{
			_warning.CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, true, (int)type, errorMsg);
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
		public async void ShowWarningWithButtons(string title, string subtitle, string prompt, List<InstructionalButton> buttons, string errorMsg = "", WarningPopupType type = WarningPopupType.Classic)
		{
			await Load();
			_disableControls = true;
			_buttonList = buttons;
			if (buttons == null || buttons.Count == 0) return;
			ScaleformUI.InstructionalButtons.SetInstructionalButtons(_buttonList);
			ScaleformUI.InstructionalButtons.UseMouseButtons = true;
			_warning.CallFunction("SHOW_POPUP_WARNING", 1000, title, subtitle, prompt, true, (int)type, errorMsg);
			ScaleformUI.InstructionalButtons.Enabled = true;
		}

		internal void Update()
		{
			if (_warning == null) return;
			_warning.Render2D();
			if (_disableControls)
			{
				ScaleformUI.InstructionalButtons.Draw();
				foreach (var b in _buttonList)
				{
					if (Game.IsControlJustPressed(1, b.GamepadButton) || Game.IsControlJustPressed(1, b.KeyboardButton))
					{
						OnButtonPressed?.Invoke(b);
						Dispose();
						ScaleformUI.InstructionalButtons.Enabled = false;
						ScaleformUI.InstructionalButtons.UseMouseButtons = false;
						return;
					}
				}
			}
		}
	}
}
