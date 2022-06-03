using System;
using System.Collections.Generic;
using System.Linq;
using CitizenFX.Core;
using CitizenFX.Core.Native;
using static CitizenFX.Core.Native.API;
using Control = CitizenFX.Core.Control;
using Font = CitizenFX.Core.UI.Font;
using CitizenFX.Core.UI;
using System.Drawing;
using System.Threading.Tasks;

namespace ScaleformUI
{
	#region Delegates
	public enum Keys
	{
		//
		// Summary:
		//     The bitmask to extract modifiers from a key value.
		Modifiers = -65536,
		//
		// Summary:
		//     No key pressed.
		None = 0,
		//
		// Summary:
		//     The left mouse button.
		LButton = 1,
		//
		// Summary:
		//     The right mouse button.
		RButton = 2,
		//
		// Summary:
		//     The CANCEL key.
		Cancel = 3,
		//
		// Summary:
		//     The middle mouse button (three-button mouse).
		MButton = 4,
		//
		// Summary:
		//     The first x mouse button (five-button mouse).
		XButton1 = 5,
		//
		// Summary:
		//     The second x mouse button (five-button mouse).
		XButton2 = 6,
		//
		// Summary:
		//     The BACKSPACE key.
		Back = 8,
		//
		// Summary:
		//     The TAB key.
		Tab = 9,
		//
		// Summary:
		//     The LINEFEED key.
		LineFeed = 10,
		//
		// Summary:
		//     The CLEAR key.
		Clear = 12,
		//
		// Summary:
		//     The RETURN key.
		Return = 13,
		//
		// Summary:
		//     The ENTER key.
		Enter = 13,
		//
		// Summary:
		//     The SHIFT key.
		ShiftKey = 16,
		//
		// Summary:
		//     The CTRL key.
		ControlKey = 17,
		//
		// Summary:
		//     The ALT key.
		Menu = 18,
		//
		// Summary:
		//     The PAUSE key.
		Pause = 19,
		//
		// Summary:
		//     The CAPS LOCK key.
		Capital = 20,
		//
		// Summary:
		//     The CAPS LOCK key.
		CapsLock = 20,
		//
		// Summary:
		//     The IME Kana mode key.
		KanaMode = 21,
		//
		// Summary:
		//     The IME Hanguel mode key. (maintained for compatibility; use HangulMode)
		HanguelMode = 21,
		//
		// Summary:
		//     The IME Hangul mode key.
		HangulMode = 21,
		//
		// Summary:
		//     The IME Junja mode key.
		JunjaMode = 23,
		//
		// Summary:
		//     The IME final mode key.
		FinalMode = 24,
		//
		// Summary:
		//     The IME Hanja mode key.
		HanjaMode = 25,
		//
		// Summary:
		//     The IME Kanji mode key.
		KanjiMode = 25,
		//
		// Summary:
		//     The ESC key.
		Escape = 27,
		//
		// Summary:
		//     The IME convert key.
		IMEConvert = 28,
		//
		// Summary:
		//     The IME nonconvert key.
		IMENonconvert = 29,
		//
		// Summary:
		//     The IME accept key, replaces System.Windows.Forms.Keys.IMEAceept.
		IMEAccept = 30,
		//
		// Summary:
		//     The IME accept key. Obsolete, use System.Windows.Forms.Keys.IMEAccept instead.
		IMEAceept = 30,
		//
		// Summary:
		//     The IME mode change key.
		IMEModeChange = 31,
		//
		// Summary:
		//     The SPACEBAR key.
		Space = 32,
		//
		// Summary:
		//     The PAGE UP key.
		Prior = 33,
		//
		// Summary:
		//     The PAGE UP key.
		PageUp = 33,
		//
		// Summary:
		//     The PAGE DOWN key.
		Next = 34,
		//
		// Summary:
		//     The PAGE DOWN key.
		PageDown = 34,
		//
		// Summary:
		//     The END key.
		End = 35,
		//
		// Summary:
		//     The HOME key.
		Home = 36,
		//
		// Summary:
		//     The LEFT ARROW key.
		Left = 37,
		//
		// Summary:
		//     The UP ARROW key.
		Up = 38,
		//
		// Summary:
		//     The RIGHT ARROW key.
		Right = 39,
		//
		// Summary:
		//     The DOWN ARROW key.
		Down = 40,
		//
		// Summary:
		//     The SELECT key.
		Select = 41,
		//
		// Summary:
		//     The PRINT key.
		Print = 42,
		//
		// Summary:
		//     The EXECUTE key.
		Execute = 43,
		//
		// Summary:
		//     The PRINT SCREEN key.
		Snapshot = 44,
		//
		// Summary:
		//     The PRINT SCREEN key.
		PrintScreen = 44,
		//
		// Summary:
		//     The INS key.
		Insert = 45,
		//
		// Summary:
		//     The DEL key.
		Delete = 46,
		//
		// Summary:
		//     The HELP key.
		Help = 47,
		//
		// Summary:
		//     The 0 key.
		D0 = 48,
		//
		// Summary:
		//     The 1 key.
		D1 = 49,
		//
		// Summary:
		//     The 2 key.
		D2 = 50,
		//
		// Summary:
		//     The 3 key.
		D3 = 51,
		//
		// Summary:
		//     The 4 key.
		D4 = 52,
		//
		// Summary:
		//     The 5 key.
		D5 = 53,
		//
		// Summary:
		//     The 6 key.
		D6 = 54,
		//
		// Summary:
		//     The 7 key.
		D7 = 55,
		//
		// Summary:
		//     The 8 key.
		D8 = 56,
		//
		// Summary:
		//     The 9 key.
		D9 = 57,
		//
		// Summary:
		//     The A key.
		A = 65,
		//
		// Summary:
		//     The B key.
		B = 66,
		//
		// Summary:
		//     The C key.
		C = 67,
		//
		// Summary:
		//     The D key.
		D = 68,
		//
		// Summary:
		//     The E key.
		E = 69,
		//
		// Summary:
		//     The F key.
		F = 70,
		//
		// Summary:
		//     The G key.
		G = 71,
		//
		// Summary:
		//     The H key.
		H = 72,
		//
		// Summary:
		//     The I key.
		I = 73,
		//
		// Summary:
		//     The J key.
		J = 74,
		//
		// Summary:
		//     The K key.
		K = 75,
		//
		// Summary:
		//     The L key.
		L = 76,
		//
		// Summary:
		//     The M key.
		M = 77,
		//
		// Summary:
		//     The N key.
		N = 78,
		//
		// Summary:
		//     The O key.
		O = 79,
		//
		// Summary:
		//     The P key.
		P = 80,
		//
		// Summary:
		//     The Q key.
		Q = 81,
		//
		// Summary:
		//     The R key.
		R = 82,
		//
		// Summary:
		//     The S key.
		S = 83,
		//
		// Summary:
		//     The T key.
		T = 84,
		//
		// Summary:
		//     The U key.
		U = 85,
		//
		// Summary:
		//     The V key.
		V = 86,
		//
		// Summary:
		//     The W key.
		W = 87,
		//
		// Summary:
		//     The X key.
		X = 88,
		//
		// Summary:
		//     The Y key.
		Y = 89,
		//
		// Summary:
		//     The Z key.
		Z = 90,
		//
		// Summary:
		//     The left Windows logo key (Microsoft Natural Keyboard).
		LWin = 91,
		//
		// Summary:
		//     The right Windows logo key (Microsoft Natural Keyboard).
		RWin = 92,
		//
		// Summary:
		//     The application key (Microsoft Natural Keyboard).
		Apps = 93,
		//
		// Summary:
		//     The computer sleep key.
		Sleep = 95,
		//
		// Summary:
		//     The 0 key on the numeric keypad.
		NumPad0 = 96,
		//
		// Summary:
		//     The 1 key on the numeric keypad.
		NumPad1 = 97,
		//
		// Summary:
		//     The 2 key on the numeric keypad.
		NumPad2 = 98,
		//
		// Summary:
		//     The 3 key on the numeric keypad.
		NumPad3 = 99,
		//
		// Summary:
		//     The 4 key on the numeric keypad.
		NumPad4 = 100,
		//
		// Summary:
		//     The 5 key on the numeric keypad.
		NumPad5 = 101,
		//
		// Summary:
		//     The 6 key on the numeric keypad.
		NumPad6 = 102,
		//
		// Summary:
		//     The 7 key on the numeric keypad.
		NumPad7 = 103,
		//
		// Summary:
		//     The 8 key on the numeric keypad.
		NumPad8 = 104,
		//
		// Summary:
		//     The 9 key on the numeric keypad.
		NumPad9 = 105,
		//
		// Summary:
		//     The multiply key.
		Multiply = 106,
		//
		// Summary:
		//     The add key.
		Add = 107,
		//
		// Summary:
		//     The separator key.
		Separator = 108,
		//
		// Summary:
		//     The subtract key.
		Subtract = 109,
		//
		// Summary:
		//     The decimal key.
		Decimal = 110,
		//
		// Summary:
		//     The divide key.
		Divide = 111,
		//
		// Summary:
		//     The F1 key.
		F1 = 112,
		//
		// Summary:
		//     The F2 key.
		F2 = 113,
		//
		// Summary:
		//     The F3 key.
		F3 = 114,
		//
		// Summary:
		//     The F4 key.
		F4 = 115,
		//
		// Summary:
		//     The F5 key.
		F5 = 116,
		//
		// Summary:
		//     The F6 key.
		F6 = 117,
		//
		// Summary:
		//     The F7 key.
		F7 = 118,
		//
		// Summary:
		//     The F8 key.
		F8 = 119,
		//
		// Summary:
		//     The F9 key.
		F9 = 120,
		//
		// Summary:
		//     The F10 key.
		F10 = 121,
		//
		// Summary:
		//     The F11 key.
		F11 = 122,
		//
		// Summary:
		//     The F12 key.
		F12 = 123,
		//
		// Summary:
		//     The F13 key.
		F13 = 124,
		//
		// Summary:
		//     The F14 key.
		F14 = 125,
		//
		// Summary:
		//     The F15 key.
		F15 = 126,
		//
		// Summary:
		//     The F16 key.
		F16 = 127,
		//
		// Summary:
		//     The F17 key.
		F17 = 128,
		//
		// Summary:
		//     The F18 key.
		F18 = 129,
		//
		// Summary:
		//     The F19 key.
		F19 = 130,
		//
		// Summary:
		//     The F20 key.
		F20 = 131,
		//
		// Summary:
		//     The F21 key.
		F21 = 132,
		//
		// Summary:
		//     The F22 key.
		F22 = 133,
		//
		// Summary:
		//     The F23 key.
		F23 = 134,
		//
		// Summary:
		//     The F24 key.
		F24 = 135,
		//
		// Summary:
		//     The NUM LOCK key.
		NumLock = 144,
		//
		// Summary:
		//     The SCROLL LOCK key.
		Scroll = 145,
		//
		// Summary:
		//     The left SHIFT key.
		LShiftKey = 160,
		//
		// Summary:
		//     The right SHIFT key.
		RShiftKey = 161,
		//
		// Summary:
		//     The left CTRL key.
		LControlKey = 162,
		//
		// Summary:
		//     The right CTRL key.
		RControlKey = 163,
		//
		// Summary:
		//     The left ALT key.
		LMenu = 164,
		//
		// Summary:
		//     The right ALT key.
		RMenu = 165,
		//
		// Summary:
		//     The browser back key (Windows 2000 or later).
		BrowserBack = 166,
		//
		// Summary:
		//     The browser forward key (Windows 2000 or later).
		BrowserForward = 167,
		//
		// Summary:
		//     The browser refresh key (Windows 2000 or later).
		BrowserRefresh = 168,
		//
		// Summary:
		//     The browser stop key (Windows 2000 or later).
		BrowserStop = 169,
		//
		// Summary:
		//     The browser search key (Windows 2000 or later).
		BrowserSearch = 170,
		//
		// Summary:
		//     The browser favorites key (Windows 2000 or later).
		BrowserFavorites = 171,
		//
		// Summary:
		//     The browser home key (Windows 2000 or later).
		BrowserHome = 172,
		//
		// Summary:
		//     The volume mute key (Windows 2000 or later).
		VolumeMute = 173,
		//
		// Summary:
		//     The volume down key (Windows 2000 or later).
		VolumeDown = 174,
		//
		// Summary:
		//     The volume up key (Windows 2000 or later).
		VolumeUp = 175,
		//
		// Summary:
		//     The media next track key (Windows 2000 or later).
		MediaNextTrack = 176,
		//
		// Summary:
		//     The media previous track key (Windows 2000 or later).
		MediaPreviousTrack = 177,
		//
		// Summary:
		//     The media Stop key (Windows 2000 or later).
		MediaStop = 178,
		//
		// Summary:
		//     The media play pause key (Windows 2000 or later).
		MediaPlayPause = 179,
		//
		// Summary:
		//     The launch mail key (Windows 2000 or later).
		LaunchMail = 180,
		//
		// Summary:
		//     The select media key (Windows 2000 or later).
		SelectMedia = 181,
		//
		// Summary:
		//     The start application one key (Windows 2000 or later).
		LaunchApplication1 = 182,
		//
		// Summary:
		//     The start application two key (Windows 2000 or later).
		LaunchApplication2 = 183,
		//
		// Summary:
		//     The OEM Semicolon key on a US standard keyboard (Windows 2000 or later).
		OemSemicolon = 186,
		//
		// Summary:
		//     The OEM 1 key.
		Oem1 = 186,
		//
		// Summary:
		//     The OEM plus key on any country/region keyboard (Windows 2000 or later).
		Oemplus = 187,
		//
		// Summary:
		//     The OEM comma key on any country/region keyboard (Windows 2000 or later).
		Oemcomma = 188,
		//
		// Summary:
		//     The OEM minus key on any country/region keyboard (Windows 2000 or later).
		OemMinus = 189,
		//
		// Summary:
		//     The OEM period key on any country/region keyboard (Windows 2000 or later).
		OemPeriod = 190,
		//
		// Summary:
		//     The OEM question mark key on a US standard keyboard (Windows 2000 or later).
		OemQuestion = 191,
		//
		// Summary:
		//     The OEM 2 key.
		Oem2 = 191,
		//
		// Summary:
		//     The OEM tilde key on a US standard keyboard (Windows 2000 or later).
		Oemtilde = 192,
		//
		// Summary:
		//     The OEM 3 key.
		Oem3 = 192,
		//
		// Summary:
		//     The OEM open bracket key on a US standard keyboard (Windows 2000 or later).
		OemOpenBrackets = 219,
		//
		// Summary:
		//     The OEM 4 key.
		Oem4 = 219,
		//
		// Summary:
		//     The OEM pipe key on a US standard keyboard (Windows 2000 or later).
		OemPipe = 220,
		//
		// Summary:
		//     The OEM 5 key.
		Oem5 = 220,
		//
		// Summary:
		//     The OEM close bracket key on a US standard keyboard (Windows 2000 or later).
		OemCloseBrackets = 221,
		//
		// Summary:
		//     The OEM 6 key.
		Oem6 = 221,
		//
		// Summary:
		//     The OEM singled/double quote key on a US standard keyboard (Windows 2000 or later).
		OemQuotes = 222,
		//
		// Summary:
		//     The OEM 7 key.
		Oem7 = 222,
		//
		// Summary:
		//     The OEM 8 key.
		Oem8 = 223,
		//
		// Summary:
		//     The OEM angle bracket or backslash key on the RT 102 key keyboard (Windows 2000
		//     or later).
		OemBackslash = 226,
		//
		// Summary:
		//     The OEM 102 key.
		Oem102 = 226,
		//
		// Summary:
		//     The PROCESS KEY key.
		ProcessKey = 229,
		//
		// Summary:
		//     Used to pass Unicode characters as if they were keystrokes. The Packet key value
		//     is the low word of a 32-bit virtual-key value used for non-keyboard input methods.
		Packet = 231,
		//
		// Summary:
		//     The ATTN key.
		Attn = 246,
		//
		// Summary:
		//     The CRSEL key.
		Crsel = 247,
		//
		// Summary:
		//     The EXSEL key.
		Exsel = 248,
		//
		// Summary:
		//     The ERASE EOF key.
		EraseEof = 249,
		//
		// Summary:
		//     The PLAY key.
		Play = 250,
		//
		// Summary:
		//     The ZOOM key.
		Zoom = 251,
		//
		// Summary:
		//     A constant reserved for future use.
		NoName = 252,
		//
		// Summary:
		//     The PA1 key.
		Pa1 = 253,
		//
		// Summary:
		//     The CLEAR key.
		OemClear = 254,
		//
		// Summary:
		//     The bitmask to extract a key code from a key value.
		KeyCode = 65535,
		//
		// Summary:
		//     The SHIFT modifier key.
		Shift = 65536,
		//
		// Summary:
		//     The CTRL modifier key.
		Control = 131072,
		//
		// Summary:
		//     The ALT modifier key.
		Alt = 262144
	}

	public enum MenuState
	{
		Opened,
		Closed,
		ChangeForward,
		ChangeBackward
	}

	public delegate void IndexChangedEvent(UIMenu sender, int newIndex);
	public delegate void ListChangedEvent(UIMenu sender, UIMenuListItem listItem, int newIndex);
	public delegate void SliderChangedEvent(UIMenu sender, UIMenuSliderItem listItem, int newIndex);
	public delegate void ListSelectedEvent(UIMenu sender, UIMenuListItem listItem, int newIndex);
	public delegate void CheckboxChangeEvent(UIMenu sender, UIMenuCheckboxItem checkboxItem, bool Checked);
	public delegate void ItemSelectEvent(UIMenu sender, UIMenuItem selectedItem, int index);
	public delegate void ItemActivatedEvent(UIMenu sender, UIMenuItem selectedItem);
	public delegate void ItemCheckboxEvent(UIMenuCheckboxItem sender, bool Checked);
	public delegate void ItemListEvent(UIMenuListItem sender, int newIndex);
	public delegate void ItemSliderEvent(UIMenuSliderItem sender, int newIndex);
	public delegate void ItemSliderProgressEvent(UIMenuProgressItem sender, int newIndex);
	public delegate void OnProgressChanged(UIMenu menu, UIMenuProgressItem item, int newIndex);
	public delegate void OnProgressSelected(UIMenu menu, UIMenuProgressItem item, int newIndex);
	public delegate void StatItemProgressChange(UIMenu menu, UIMenuStatsItem item, int value);
    public delegate void ColorPanelChangedEvent(UIMenuItem menu, UIMenuColorPanel panel, int index);
    public delegate void VehicleColorPickerSelectEvent(UIMenuItem menu, UIVehicleColourPickerPanel panel, int index);
    public delegate void PercentagePanelChangedEvent(UIMenuItem menu, UIMenuPercentagePanel panel, float value);
	public delegate void GridPanelChangedEvent(UIMenuItem menu, UIMenuGridPanel panel, PointF value);

	public enum MenuAnimationType
	{
		LINEAR = 0,
		QUADRATIC_IN,
		QUADRATIC_OUT,
		QUADRATIC_INOUT,
		CUBIC_IN,
		CUBIC_OUT,
		CUBIC_INOUT,
		QUARTIC_IN,
		QUARTIC_OUT,
		QUARTIC_INOUT,
		SINE_IN,
		SINE_OUT,
		SINE_INOUT,
		BACK_IN,
		BACK_OUT,
		BACK_INOUT,
		CIRCULAR_IN,
		CIRCULAR_OUT,
		CIRCULAR_INOUT
	}

    #endregion

    /// <summary>
    /// Base class for ScaleformUI. Calls the next events: OnIndexChange, OnListChanged, OnCheckboxChange, OnItemSelect, OnMenuClose, OnMenuchange.
    /// </summary>
    public class UIMenu
    {
        #region Private Fields
        private int _activeItem = 0;

        private bool _visible;
        private bool _justOpened = true;
        private bool _itemsDirty = false;

        internal KeyValuePair<string, string> _customTexture;

        /// <summary>
        /// Players won't be able to close the menu if this is false! Make sure players can close the menu in some way!!!!!!
        /// </summary>
        public bool CanPlayerCloseMenu = true;
        //Pagination
        public int MaxItemsOnScreen
        {
            get => _maxItem;
            set
            {
                _maxItem = value;
                RefreshIndex();
            }
        }
        private int _maxItem = 7;

        private bool mouseWheelControlEnabled = true;
        private int menuSound;
        private bool _changed = true;
        private bool keyboard = false;
        //Keys
        private readonly Dictionary<MenuControls, Tuple<List<Keys>, List<Tuple<Control, int>>>> _keyDictionary =
            new Dictionary<MenuControls, Tuple<List<Keys>, List<Tuple<Control, int>>>>();

        private readonly Scaleform _menuGlare;

        private static readonly MenuControls[] _menuControls = Enum.GetValues(typeof(MenuControls)).Cast<MenuControls>().ToArray();

        internal MenuPool _poolcontainer;

        public bool Glare { get; set; }

        internal readonly static string _selectTextLocalized = Game.GetGXTEntry("HUD_INPUT2");
        internal readonly static string _backTextLocalized = Game.GetGXTEntry("HUD_INPUT3");
        protected readonly SizeF Resolution = ScreenTools.ResolutionMaintainRatio;

        // Button delay
        private int time;
        private int times;
        private int delay = 150;
        #endregion

        #region Public Fields

        public string AUDIO_LIBRARY = "HUD_FRONTEND_DEFAULT_SOUNDSET";

        public string AUDIO_UPDOWN = "NAV_UP_DOWN";
        public string AUDIO_LEFTRIGHT = "NAV_LEFT_RIGHT";
        public string AUDIO_SELECT = "SELECT";
        public string AUDIO_BACK = "BACK";
        public string AUDIO_ERROR = "ERROR";

        public List<UIMenuItem> MenuItems = new List<UIMenuItem>();

        public bool MouseEdgeEnabled = true;
        public bool ControlDisablingEnabled = true;
        public bool EnableAnimation
        {
            get => enableAnimation;
            set
            {
                enableAnimation = value;
                if (Visible)
                {
                    ScaleformUI._ui.CallFunction("ENABLE_SCROLLING_ANIMATION", enableAnimation);
                }
            }
        }
        public MenuAnimationType AnimationType
        {
            get => animationType;
            set
            {
                animationType = value;
                if (Visible)
                {
                    ScaleformUI._ui.CallFunction("CHANGE_SCROLLING_ANIMATION_TYPE", (int)animationType);
                }
            }
        }
        public bool MouseWheelControlEnabled
        {
            get => mouseWheelControlEnabled;
            set
            {
                mouseWheelControlEnabled = value;
                if (value)
                {
                    SetKey(MenuControls.Up, Control.CursorScrollUp);
                    SetKey(MenuControls.Down, Control.CursorScrollDown);
                }
                else
                {
                    ResetKey(MenuControls.Up);
                    ResetKey(MenuControls.Down);
                    SetKey(MenuControls.Up, Control.PhoneUp);
                    SetKey(MenuControls.Down, Control.PhoneDown);
                }
            }
        }
        public bool ResetCursorOnOpen = true;
        private bool mouseControlsEnabled = true;
        public bool AlternativeTitle = false;
        private bool canBuild = true;
        public PointF Offset { get; internal set; }

        public List<UIMenuWindow> Windows = new List<UIMenuWindow>();

        public List<InstructionalButton> InstructionalButtons = new List<InstructionalButton>()
        {
            new InstructionalButton(Control.PhoneSelect, _selectTextLocalized),
            new InstructionalButton(Control.PhoneCancel, _backTextLocalized)
        };

        #endregion

        #region Events

        /// <summary>
        /// Called when user presses up or down, changing current selection.
        /// </summary>
        public event IndexChangedEvent OnIndexChange;

        /// <summary>
        /// Called when user presses left or right, changing a list position.
        /// </summary>
        public event ListChangedEvent OnListChange;

        /// <summary>
        /// Called when user selects a list item.
        /// </summary>
        public event ListSelectedEvent OnListSelect;

        /// <summary>
        /// Called when user presses left or right, changing a slider position.
        /// </summary>
        public event SliderChangedEvent OnSliderChange;

        /// <summary>
        /// Called when user presses left or right, changing a the index of a color panel.
        /// </summary>
        public event ColorPanelChangedEvent OnColorPanelChange;

        /// <summary>
        /// Called when user changes the value of a percentage panel.
        /// </summary>
        public event PercentagePanelChangedEvent OnPercentagePanelChange;

        /// <summary>
        /// Called when user changes value of a grid panel.
        /// </summary>
        public event GridPanelChangedEvent OnGridPanelChange;

        /// <summary>
        /// Called When user changes progress in a ProgressItem.
        /// </summary>
        public event OnProgressChanged OnProgressChange;

        /// <summary>
        /// Called when user either clicks on a ProgressItem.
        /// </summary>
        public event OnProgressSelected OnProgressSelect;

        /// <summary>
        /// Called when user presses enter on a checkbox item.
        /// </summary>
        public event CheckboxChangeEvent OnCheckboxChange;

        /// <summary>
        /// Called when user selects a simple item.
        /// </summary>
        public event ItemSelectEvent OnItemSelect;

        /// <summary>
        /// Called when user either opens or closes the main menu, clicks on a binded button, goes back to a parent menu.
        /// </summary>
        public event MenuStateChangeEvent OnMenuStateChanged;

        /// <summary>
        /// Called every time a Stat item changes value
        /// </summary>
        public event StatItemProgressChange OnStatsItemChanged;
        #endregion

        #region Constructors

        /// <summary>
        /// Basic Menu constructor.
        /// </summary>
        /// <param name="title">Title that appears on the big banner.</param>
        /// <param name="subtitle">Subtitle that appears in capital letters in a small black bar.</param>
        /// <param name="glare">Add menu Glare scaleform?.</param>
        public UIMenu(string title, string subtitle, bool glare = false, bool alternativeTitle = false) : this(title, subtitle, new PointF(0, 0), "commonmenu", "interaction_bgd", glare, alternativeTitle)
        {
        }


        /// <summary>
        /// Basic Menu constructor with an offset.
        /// </summary>
        /// <param name="title">Title that appears on the big banner.</param>
        /// <param name="subtitle">Subtitle that appears in capital letters in a small black bar. Set to "" if you dont want a subtitle.</param>
        /// <param name="offset">PointF object with X and Y data for offsets. Applied to all menu elements.</param>
        /// <param name="glare">Add menu Glare scaleform?.</param>
        /// <param name="alternativeTitle">Set the alternative type to the title?.</param>
        public UIMenu(string title, string subtitle, PointF offset, bool glare = false, bool alternativeTitle = false) : this(title, subtitle, offset, "commonmenu", "interaction_bgd", glare, alternativeTitle)
        {
        }

        /// <summary>
        /// Initialise a menu with a custom texture banner.
        /// </summary>
        /// <param name="title">Title that appears on the big banner. Set to "" if you don't want a title.</param>
        /// <param name="subtitle">Subtitle that appears in capital letters in a small black bar. Set to "" if you dont want a subtitle.</param>
        /// <param name="offset">PointF object with X and Y data for offsets. Applied to all menu elements.</param>
        /// <param name="customBanner">Path to your custom texture.</param>
        /// <param name="glare">Add menu Glare scaleform?.</param>
        /// <param name="alternativeTitle">Set the alternative type to the title?.</param>
        public UIMenu(string title, string subtitle, PointF offset, KeyValuePair<string, string> customBanner, bool glare = false, bool alternativeTitle = false) : this(title, subtitle, offset, customBanner.Key, customBanner.Value, glare, alternativeTitle)
        {
        }


        /// <summary>
        /// Advanced Menu constructor that allows custom title banner.
        /// </summary>
        /// <param name="title">Title that appears on the big banner. Set to "" if you are using a custom banner.</param>
        /// <param name="subtitle">Subtitle that appears in capital letters in a small black bar.</param>
        /// <param name="offset">PointF object with X and Y data for offsets. Applied to all menu elements.</param>
        /// <param name="spriteLibrary">Sprite library name for the banner.</param>
        /// <param name="spriteName">Sprite name for the banner.</param>
        /// <param name="glare">Add menu Glare scaleform?.</param>
        /// <param name="alternativeTitle">Set the alternative type to the title?.</param>
        public UIMenu(string title, string subtitle, PointF offset, string spriteLibrary, string spriteName, bool glare = false, bool alternativeTitle = false)
        {
            _customTexture = new KeyValuePair<string, string>(spriteLibrary, spriteName);
            Offset = offset;
            Children = new Dictionary<UIMenuItem, UIMenu>();
            WidthOffset = 0;
            Glare = glare;
            _menuGlare = new Scaleform("mp_menu_glare");
            Title = title;
            Subtitle = subtitle;
            AlternativeTitle = alternativeTitle;
            MouseWheelControlEnabled = true;
            SetKey(MenuControls.Up, Control.PhoneUp);
            SetKey(MenuControls.Down, Control.PhoneDown);

            SetKey(MenuControls.Left, Control.PhoneLeft);
            SetKey(MenuControls.Right, Control.PhoneRight);
            SetKey(MenuControls.Select, Control.FrontendAccept);

            SetKey(MenuControls.Back, Control.PhoneCancel);
            SetKey(MenuControls.Back, Control.FrontendPause);
        }

        #endregion

        #region Static Methods
        /// <summary>
        /// Toggles the availability of the controls.
        /// It does not disable the basic movement and frontend controls.
        /// </summary>
        /// <param name="enable"></param>
        /// <param name="toggle">If we want to enable or disable the controls.</param>
        [Obsolete("Use Controls.Toggle instead.", true)]
        public static void DisEnableControls(bool toggle) => Controls.Toggle(toggle);

        /// <summary>
        /// Returns the 1080pixels-based screen resolution while mantaining current aspect ratio.
        /// </summary>
        [Obsolete("Use ScreenTools.ResolutionMaintainRatio instead.", true)]
        public static SizeF GetScreenResolutionMaintainRatio() => ScreenTools.ResolutionMaintainRatio;

        /// <summary>
        /// ScreenTools.ResolutionMaintainRatio for providing backwards compatibility.
        /// </summary>
        /// <returns></returns>
        [Obsolete("Use ScreenTools.ResolutionMaintainRatio instead.", true)]
        public static SizeF GetScreenResiolutionMantainRatio() => ScreenTools.ResolutionMaintainRatio;

        /// <summary>
        /// Chech whether the mouse is inside the specified rectangle.
        /// </summary>
        /// <param name="topLeft">Start point of the rectangle at the top left.</param>
        /// <param name="boxSize">size of your rectangle.</param>
        /// <returns>true if the mouse is inside of the specified bounds, false otherwise.</returns>
        [Obsolete("Use ScreenTools.IsMouseInBounds instead.", true)]
        public static bool IsMouseInBounds(Point topLeft, Size boxSize) => ScreenTools.IsMouseInBounds(topLeft, boxSize);

        /// <summary>
        /// Returns the safezone bounds in pixel, relative to the 1080pixel based system.
        /// </summary>
        [Obsolete("Use ScreenTools.SafezoneBounds instead.", true)]
        public static Point GetSafezoneBounds() => ScreenTools.SafezoneBounds;

        #endregion

        #region Public Methods
        /// <summary>
        /// Change the menu's width. The width is calculated as DefaultWidth + WidthOffset, so a width offset of 10 would enlarge the menu by 10 pixels.
        /// </summary>
        /// <param name="widthOffset">New width offset.</param>
        public void SetMenuWidthOffset(int widthOffset)
        {
            WidthOffset = widthOffset;
        }

        /// <summary>
        /// Enable or disable the instructional buttons.
        /// </summary>
        /// <param name="disable"></param>
        public void DisableInstructionalButtons(bool disable)
        {
            ScaleformUI.InstructionalButtons.Enabled = !disable;
        }

        /// <summary>
        /// Set the banner to your own custom texture. Set it to "" if you want to restore the banner.
        /// </summary>
        /// <param name="pathToCustomSprite">Path to your sprite image.</param>
        public void SetBannerType(KeyValuePair<string, string> pathToCustomSprite)
        {
            _customTexture = pathToCustomSprite;
        }

        /// <summary>
        /// Add an item to the menu.
        /// </summary>
        /// <param name="item">Item object to be added. Can be normal item, checkbox or list item.</param>
        public void AddItem(UIMenuItem item)
        {
            int selectedItem = CurrentSelection;
            item.Parent = this;
            MenuItems.Add(item);
            CurrentSelection = selectedItem;
        }

        /// <summary>
        /// Add a new Heritage Window to the Menu
        /// </summary>
        /// <param name="window"></param>
        public void AddWindow(UIMenuWindow window)
        {
            window.ParentMenu = this;
            Windows.Add(window);
        }

        /// <summary>
        /// Removes Windows at given index
        /// </summary>
        /// <param name="index"></param>
        public void RemoveWindowAt(int index)
        {
            Windows.RemoveAt(index);
        }

        /// <summary>
        /// If a Description is changed during some events after the menu as been opened this updates the description live
        /// </summary>
        public void UpdateDescription()
        {
            BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "UPDATE_ITEM_DESCRIPTION");
            ScaleformMovieMethodAddParamInt(CurrentSelection);
            BeginTextCommandScaleformString($"menu_{_poolcontainer._menuList.IndexOf(this)}_desc_{CurrentSelection}");
            EndTextCommandScaleformString_2();
            EndScaleformMovieMethod();
        }

        /// <summary>
        /// Remove an item at index n.
        /// </summary>
        /// <param name="index">Index to remove the item at.</param>
        public void RemoveItemAt(int index)
        {
            int selectedItem = CurrentSelection;
            MenuItems.RemoveAt(index);
            if (Visible) ScaleformUI._ui.CallFunction("REMOVE_ITEM", index);
            CurrentSelection = selectedItem;
        }

        public void RemoveItem(UIMenuItem item)
        {
            RemoveItemAt(MenuItems.IndexOf(item));
        }

        public void AddSubMenu(UIMenu menu, string text, bool OffsetInheritance = true)
        {
            PointF Offset = PointF.Empty;
            if (OffsetInheritance)
                Offset = this.Offset;
            AddSubMenu(menu, text, "", Offset);
        }
        public void AddSubMenu(UIMenu menu, string text, PointF offset)
        {
            AddSubMenu(menu, text, "", offset);
        }
        public void AddSubMenu(UIMenu menu, string text, string description, bool OffsetInheritance = true)
        {
            PointF Offset = PointF.Empty;
            if (OffsetInheritance)
                Offset = this.Offset;
            AddSubMenu(menu, text, description, Offset);
        }
        public void AddSubMenu(UIMenu menu, string text, string description, PointF offset, bool BannerInheritance = true)
        {
            UIMenuItem item = new UIMenuItem(text, description);
            this.AddItem(item);
            menu.Offset = offset;

            if (BannerInheritance && this._customTexture.Key != null && this._customTexture.Value != null)
                menu.SetBannerType(this._customTexture);

            menu.MouseEdgeEnabled = this.MouseEdgeEnabled;
            menu.MouseWheelControlEnabled = this.MouseWheelControlEnabled;
            menu.MouseControlsEnabled = this.MouseControlsEnabled;
            menu.MaxItemsOnScreen = this.MaxItemsOnScreen;
            _poolcontainer.Add(menu);
            this.BindMenuToItem(menu, item);
            menu._poolcontainer = this._poolcontainer;
        }

        /// <summary>
        /// Reset the current selected item to 0. Use this after you add or remove items dynamically.
        /// </summary>
        public void RefreshIndex()
        {
            if (MenuItems.Count == 0)
            {
                _activeItem = 0;
                _maxItem = MaxItemsOnScreen;
                return;
            }
            MenuItems[_activeItem % (MenuItems.Count)].Selected = false;
            _activeItem = 1000 - (1000 % MenuItems.Count);
        }

        /// <summary>
        /// Remove all items from the menu.
        /// </summary>
        public void Clear()
        {
            MenuItems.Clear();
        }

        /// <summary>
        /// Removes the items that matches the predicate.
        /// </summary>
        /// <param name="predicate">The function to use as the check.</param>
        public void Remove(Func<UIMenuItem, bool> predicate)
        {
            List<UIMenuItem> TempList = new List<UIMenuItem>(MenuItems);
            foreach (UIMenuItem item in TempList)
            {
                if (predicate(item))
                {
                    MenuItems.Remove(item);
                }
            }
        }

        /// <summary>
        /// Set a key to control a menu. Can be multiple keys for each control.
        /// </summary>
        /// <param name="control"></param>
        /// <param name="keyToSet"></param>
        public void SetKey(MenuControls control, Keys keyToSet)
        {
            if (_keyDictionary.ContainsKey(control))
                _keyDictionary[control].Item1.Add(keyToSet);
            else
            {
                _keyDictionary.Add(control,
                    new Tuple<List<Keys>, List<Tuple<Control, int>>>(new List<Keys>(), new List<Tuple<Control, int>>()));
                _keyDictionary[control].Item1.Add(keyToSet);
            }
        }


        /// <summary>
        /// Set a GTA.Control to control a menu. Can be multiple controls. This applies it to all indexes.
        /// </summary>
        /// <param name="control"></param>
        /// <param name="gtaControl"></param>
        public void SetKey(MenuControls control, Control gtaControl)
        {
            SetKey(control, gtaControl, 0);
            SetKey(control, gtaControl, 1);
            SetKey(control, gtaControl, 2);
        }


        /// <summary>
        /// Set a GTA.Control to control a menu only on a specific index.
        /// </summary>
        /// <param name="control"></param>
        /// <param name="gtaControl"></param>
        /// <param name="controlIndex"></param>
        public void SetKey(MenuControls control, Control gtaControl, int controlIndex)
        {
            if (_keyDictionary.ContainsKey(control))
                _keyDictionary[control].Item2.Add(new Tuple<Control, int>(gtaControl, controlIndex));
            else
            {
                _keyDictionary.Add(control,
                    new Tuple<List<Keys>, List<Tuple<Control, int>>>(new List<Keys>(), new List<Tuple<Control, int>>()));
                _keyDictionary[control].Item2.Add(new Tuple<Control, int>(gtaControl, controlIndex));
            }

        }


        /// <summary>
        /// Remove all controls on a control.
        /// </summary>
        /// <param name="control"></param>
        public void ResetKey(MenuControls control)
        {
            _keyDictionary[control].Item1.Clear();
            _keyDictionary[control].Item2.Clear();
        }


        /// <summary>
        /// Check whether a menucontrol has been pressed.
        /// </summary>
        /// <param name="control">Control to check for.</param>
        /// <param name="key">Key if you're using keys.</param>
        /// <returns></returns>
        public bool HasControlJustBeenPressed(MenuControls control, Keys key = Keys.None)
        {
            List<Keys> tmpKeys = new List<Keys>(_keyDictionary[control].Item1);
            List<Tuple<Control, int>> tmpControls = new List<Tuple<Control, int>>(_keyDictionary[control].Item2);

            if (key != Keys.None)
            {
                //if (tmpKeys.Any(Game.IsKeyPressed))
                //    return true;
            }
            if (tmpControls.Any(tuple => Game.IsControlJustPressed(tuple.Item2, tuple.Item1)))
                return true;
            return false;
        }


        /// <summary>
        /// Check whether a menucontrol has been released.
        /// </summary>
        /// <param name="control">Control to check for.</param>
        /// <param name="key">Key if you're using keys.</param>
        /// <returns></returns>
        public bool HasControlJustBeenReleased(MenuControls control, Keys key = Keys.None)
        {
            List<Keys> tmpKeys = new List<Keys>(_keyDictionary[control].Item1);
            List<Tuple<Control, int>> tmpControls = new List<Tuple<Control, int>>(_keyDictionary[control].Item2);

            if (key != Keys.None)
            {
                //if (tmpKeys.Any(Game.IsKeyPressed))
                //    return true;
            }
            if (tmpControls.Any(tuple => Game.IsControlJustReleased(tuple.Item2, tuple.Item1)))
                return true;
            return false;
        }

        private int _controlCounter;
        private bool enableAnimation = true;
        private MenuAnimationType animationType = MenuAnimationType.LINEAR;

        /// <summary>
        /// Check whether a menucontrol is being pressed.
        /// </summary>
        /// <param name="control"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        public bool IsControlBeingPressed(MenuControls control, Keys key = Keys.None)
        {
            List<Keys> tmpKeys = new List<Keys>(_keyDictionary[control].Item1);
            List<Tuple<Control, int>> tmpControls = new List<Tuple<Control, int>>(_keyDictionary[control].Item2);
            if (HasControlJustBeenReleased(control, key)) _controlCounter = 0;
            if (tmpControls.Any(tuple => Game.IsControlPressed(tuple.Item2, tuple.Item1)))
                return true;
            return false;
        }

        [Obsolete("Use InstructionalButtons.Add instead")]
        public void AddInstructionalButton(InstructionalButton button)
        {
            //_instructionalButtons.Add(button);
        }

        [Obsolete("Use InstructionalButtons.Remove instead")]
        public void RemoveInstructionalButton(InstructionalButton button)
        {
            //_instructionalButtons.Remove(button);
        }

        /// <summary>
        /// Makes the specified item open a menu when is activated.
        /// </summary>
        /// <param name="menuToBind">The menu that is going to be opened when the item is activated.</param>
        /// <param name="itemToBindTo">The item that is going to activate the menu.</param>
        public void BindMenuToItem(UIMenu menuToBind, UIMenuItem itemToBindTo)
        {
            if (!MenuItems.Contains(itemToBindTo))
                AddItem(itemToBindTo);
            menuToBind.ParentMenu = this;
            menuToBind.ParentItem = itemToBindTo;
            if (Children.ContainsKey(itemToBindTo))
                Children[itemToBindTo] = menuToBind;
            else
                Children.Add(itemToBindTo, menuToBind);
        }


        /// <summary>
        /// Remove menu binding from button.
        /// </summary>
        /// <param name="releaseFrom">Button to release from.</param>
        /// <returns>Returns true if the operation was successful.</returns>
        public bool ReleaseMenuFromItem(UIMenuItem releaseFrom)
        {
            if (!Children.ContainsKey(releaseFrom)) return false;
            Children[releaseFrom].ParentItem = null;
            Children[releaseFrom].ParentMenu = null;
            Children.Remove(releaseFrom);
            return true;
        }

        #endregion

        #region Drawing & Processing
        /// <summary>
        /// Draw the menu and all of it's components.
        /// </summary>
        public async void Draw()
        {
            if (!Visible || ScaleformUI.Warning.IsShowing) return;
            while (!ScaleformUI._ui.IsLoaded) await BaseScript.Delay(0);

            HideHudComponentThisFrame(19);

            Controls.Toggle(!ControlDisablingEnabled);

            float x = 0 / Screen.Width;
            float y = 0 / Screen.Height;
            float width = 1280 / Screen.ScaledWidth;
            float height = 720 / Screen.Height;

            DrawScaleformMovie(ScaleformUI._ui.Handle, x + (width / 2.0f), y + (height / 2.0f), width, height, 255, 255, 255, 255, 0);

            if (Glare)
            {
                _menuGlare.CallFunction("SET_DATA_SLOT", GameplayCamera.RelativeHeading);
                SizeF _glareSize = new SizeF(1.0f, 1f);
                PointF gl = new PointF((Offset.X / Screen.Width) + 0.4499f, (Offset.Y / Screen.Height) + 0.449f);

                DrawScaleformMovie(_menuGlare.Handle, gl.X, gl.Y, _glareSize.Width, _glareSize.Height, 255, 255, 255, 255, 0);
            }

            if (IsUsingController)
            {
                if (keyboard)
                {
                    keyboard = false;
                    _changed = true;
                }
            }
            else
            {
                if (!keyboard)
                {
                    keyboard = true;
                    _changed = true;
                }
            }
            if (_changed)
            {
                UpdateDescription();
                _changed = false;
            }
        }

        int eventType = 0;
        int itemId = 0;
        int context = 0;
        int unused = 0;
        bool cursorPressed;

        /// <summary>
        /// Process the mouse's position and check if it's hovering over any UI element. Call this in OnTick
        /// </summary>
        public async void ProcessMouse()
        {
            if (!Visible || _justOpened || MenuItems.Count == 0 || IsUsingController || !MouseControlsEnabled)
            {
                Game.EnableControlThisFrame(0, Control.LookUpDown);
                Game.EnableControlThisFrame(0, Control.LookLeftRight);
                Game.EnableControlThisFrame(1, Control.LookUpDown);
                Game.EnableControlThisFrame(1, Control.LookLeftRight);
                Game.EnableControlThisFrame(2, Control.LookUpDown);
                Game.EnableControlThisFrame(2, Control.LookLeftRight);
                if (_itemsDirty)
                {
                    MenuItems.Where(i => i.Hovered).ToList().ForEach(i => i.Hovered = false);
                    _itemsDirty = false;
                }
                return;
            }

            SetMouseCursorActiveThisFrame();
            SetInputExclusive(2, 239);
            SetInputExclusive(2, 240);
            SetInputExclusive(2, 237);
            SetInputExclusive(2, 238);

            var success = GetScaleformMovieCursorSelection(ScaleformUI._ui.Handle, ref eventType, ref context, ref itemId, ref unused);
            if (success)
            {
                switch (eventType)
                {
                    case 5: // on click
                        switch (context)
                        {
                            case 0:
                                {
                                    var item = MenuItems[itemId];
                                    if ((MenuItems[itemId] is UIMenuSeparatorItem && (MenuItems[itemId] as UIMenuSeparatorItem).Jumpable) || !MenuItems[itemId].Enabled)
                                    {
                                        Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                                        return;
                                    }
                                    if (item.Selected)
                                    {
                                        switch (item._itemId)
                                        {
                                            case 0:
                                            case 2:
                                                Select(false);
                                                break;
                                            case 1:
                                            case 3:
                                            case 4:
                                                {
                                                    BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "SELECT_ITEM");
                                                    ScaleformMovieMethodAddParamInt(itemId);
                                                    var ret = EndScaleformMovieMethodReturnValue();
                                                    while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
                                                    int value = GetScaleformMovieMethodReturnValueInt(ret);
                                                    switch (MenuItems[CurrentSelection])
                                                    {
                                                        case UIMenuListItem:
                                                            {
                                                                var it = MenuItems[CurrentSelection] as UIMenuListItem;
                                                                it.Index = value;
                                                                ListChange(it, it.Index);
                                                                it.ListChangedTrigger(it.Index);
                                                            }
                                                            break;
                                                        case UIMenuSliderItem:
                                                            {
                                                                UIMenuSliderItem it = (UIMenuSliderItem)MenuItems[CurrentSelection];
                                                                it.Value = value;
                                                                it.SliderChanged(it.Value);
                                                                SliderChange(it, it.Value);
                                                            }
                                                            break;
                                                        case UIMenuProgressItem:
                                                            {
                                                                UIMenuProgressItem it = (UIMenuProgressItem)MenuItems[CurrentSelection];
                                                                it.Value = value;
                                                                it.ProgressChanged(it.Value);
                                                                ProgressChange(it, it.Value);
                                                            }
                                                            break;
                                                    }
                                                }
                                                break;
                                        }
                                        return;
                                    }
                                    CurrentSelection = itemId;
                                    Game.PlaySound(AUDIO_SELECT, AUDIO_LIBRARY);
                                }
                                break;
                            case 10: // panels (10 => context 1, panel_type 0) // ColorPanel
                                {
                                    BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "SELECT_PANEL");
                                    ScaleformMovieMethodAddParamInt(CurrentSelection);
                                    var ret = EndScaleformMovieMethodReturnValue();
                                    while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
                                    var res = GetScaleformMovieMethodReturnValueString(ret);
                                    var split = res.Split(',');
                                    var panel = (UIMenuColorPanel)MenuItems[CurrentSelection].Panels[Convert.ToInt32(split[0])];
                                    panel._value = Convert.ToInt32(split[1]);
                                    ColorPanelChange(panel.ParentItem, panel, panel.CurrentSelection);
                                    panel.PanelChanged();
                                }
                                break;
                            case 11: // panels (11 => context 1, panel_type 1) // PercentagePanel
                                cursorPressed = true;
                                break;
                            case 12: // panels (12 => context 1, panel_type 2) // GridPanel
                                cursorPressed = true;
                                break;
                            case 2: // side panel
                                {
                                    var panel = (UIVehicleColourPickerPanel)MenuItems[CurrentSelection].SidePanel;
                                    if (itemId != -1)
                                    {
                                        panel._value = itemId;
                                        panel.PickerSelect();
                                        Game.PlaySound(AUDIO_SELECT, AUDIO_LIBRARY);
                                    }
                                }
                                break;
                        }
                        break;
                    case 6: // on click released
                        cursorPressed = false;
                        break;
                    case 7: // on click released ouside
                        cursorPressed = false;
                        SetMouseCursorSprite(1);
                        break;
                    case 8: // on not hover
                        cursorPressed = false;
                        if (context == 0)
                        {
                            MenuItems[itemId].Hovered = false;
                        }
                        SetMouseCursorSprite(1);
                        break;
                    case 9: // on hovered
                        if (context == 0)
                        {
                            MenuItems[itemId].Hovered = true;
                        }
                        SetMouseCursorSprite(5);
                        break;
                    case 0: // dragged outside
                        cursorPressed = false;
                        break;
                    case 1: // dragged inside
                        cursorPressed = true;
                        break;
                }
            }

            if (cursorPressed)
            {
                if (HasSoundFinished(menuSound))
                {
                    menuSound = GetSoundId();
                    PlaySoundFrontend(menuSound, "CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
                }

                BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "SET_INPUT_MOUSE_EVENT_CONTINUE");
                var ret = EndScaleformMovieMethodReturnValue();
                while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
                var res = GetScaleformMovieMethodReturnValueString(ret);
                var split = res.Split(',');
                var selection = Convert.ToInt32(split[0]);
                var panel = MenuItems[CurrentSelection].Panels[selection];
                switch (panel)
                {
                    case UIMenuGridPanel:
                        var grid = panel as UIMenuGridPanel;
                        grid._value = new(Convert.ToSingle(split[1]), Convert.ToSingle(split[2]));
                        GridPanelChange(panel.ParentItem, grid, grid.CirclePosition);
                        grid.OnGridChange();
                        break;
                    case UIMenuPercentagePanel:
                        var perc = panel as UIMenuPercentagePanel;
                        perc._value = Convert.ToSingle(split[1]);
                        PercentagePanelChange(panel.ParentItem, perc, perc.Percentage);
                        perc.PercentagePanelChange();
                        break;
                }
            }
            else
            {
                if (!HasSoundFinished(menuSound))
                {
                    await BaseScript.Delay(1);
                    StopSound(menuSound);
                    ReleaseSoundId(menuSound);
                }
            }

            if (ScreenTools.IsMouseInBounds(new PointF(0, 0), new SizeF(30, 1080)) && MouseEdgeEnabled)
            {
                GameplayCamera.RelativeHeading += 5f;
                SetCursorSprite(6);
            }
            else if (ScreenTools.IsMouseInBounds(new PointF(Convert.ToInt32(Resolution.Width - 30f), 0), new SizeF(30, 1080)) && MouseEdgeEnabled)
            {
                GameplayCamera.RelativeHeading -= 5f;
                SetCursorSprite(7);
            }
            else if (MouseEdgeEnabled && !MenuItems.Any(x=>x.Hovered))
            {
                SetCursorSprite(1);
            }
        }

        public void GoBack()
        {
            Game.PlaySound(AUDIO_BACK, AUDIO_LIBRARY);
            if (ParentMenu != null)
            {
                canBuild = false;
                ScaleformUI._ui.CallFunction("CLEAR_ALL");
                ScaleformUI.InstructionalButtons.Enabled = true;
                ScaleformUI.InstructionalButtons.SetInstructionalButtons(ParentMenu.InstructionalButtons);
                _visible = false;
                _poolcontainer.MenuChangeEv(this, ParentMenu, MenuState.ChangeBackward);
                ParentMenu.MenuChangeEv(this, ParentMenu, MenuState.ChangeBackward);
                MenuChangeEv(this, ParentMenu, MenuState.ChangeBackward);
                ParentMenu.canBuild = true;
                ParentMenu._visible = true;
                ParentMenu.BuildUpMenu();
            }
            else
            {
                if (CanPlayerCloseMenu) Visible = false;
            }
        }

        public async void GoUp()
        {
            try
            {
                MenuItems[CurrentSelection].Selected = false;
                BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "SET_INPUT_EVENT");
                ScaleformMovieMethodAddParamInt(8);
                ScaleformMovieMethodAddParamInt(delay);
                var ret = EndScaleformMovieMethodReturnValue();
                while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
                _activeItem = GetScaleformMovieFunctionReturnInt(ret);
                MenuItems[CurrentSelection].Selected = true;
                IndexChange(CurrentSelection);
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }
        public async void GoDown()
        {
            try
            {
                MenuItems[CurrentSelection].Selected = false;
                BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "SET_INPUT_EVENT");
                ScaleformMovieMethodAddParamInt(9);
                ScaleformMovieMethodAddParamInt(delay);
                var ret = EndScaleformMovieMethodReturnValue();
                while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
                _activeItem = GetScaleformMovieFunctionReturnInt(ret);
                MenuItems[CurrentSelection].Selected = true;
                IndexChange(CurrentSelection);
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }
        public async void GoLeft()
        {
            if (!MenuItems[CurrentSelection].Enabled)
            {
                Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                return;
            }
            BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(10);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var res = GetScaleformMovieFunctionReturnInt(ret);
            switch (MenuItems[CurrentSelection])
            {
                case UIMenuListItem:
                    {
                        UIMenuListItem it = (UIMenuListItem)MenuItems[CurrentSelection];
                        it.Index = res;
                        ListChange(it, it.Index);
                        it.ListChangedTrigger(it.Index);
                        break;
                    }
                case UIMenuDynamicListItem:
                    {
                        UIMenuDynamicListItem it = (UIMenuDynamicListItem)MenuItems[CurrentSelection];
                        string newItem = await it.Callback(it, UIMenuDynamicListItem.ChangeDirection.Left);
                        it.CurrentListItem = newItem;
                        break;
                    }
                case UIMenuSliderItem:
                    {
                        UIMenuSliderItem it = (UIMenuSliderItem)MenuItems[CurrentSelection];
                        it.Value = res;
                        SliderChange(it, it.Value);
                        break;
                    }
                case UIMenuProgressItem:
                    {
                        UIMenuProgressItem it = (UIMenuProgressItem)MenuItems[CurrentSelection];
                        it.Value = res;
                        ProgressChange(it, it.Value);
                        break;
                    }
                case UIMenuStatsItem:
                    {
                        UIMenuStatsItem it = (UIMenuStatsItem)MenuItems[CurrentSelection];
                        it.Value = res;
                        StatItemChange(it, it.Value);
                        break;
                    }
            }
        }

        public async void GoRight()
        {
            if (!MenuItems[CurrentSelection].Enabled)
            {
                Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                return;
            }
            BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "SET_INPUT_EVENT");
            ScaleformMovieMethodAddParamInt(11);
            var ret = EndScaleformMovieMethodReturnValue();
            while (!IsScaleformMovieMethodReturnValueReady(ret)) await BaseScript.Delay(0);
            var res = GetScaleformMovieFunctionReturnInt(ret);
            switch (MenuItems[CurrentSelection])
            {
                case UIMenuListItem:
                    {
                        UIMenuListItem it = (UIMenuListItem)MenuItems[CurrentSelection];
                        it.Index = res;
                        ListChange(it, it.Index);
                        it.ListChangedTrigger(it.Index);
                        break;
                    }
                case UIMenuDynamicListItem:
                    {
                        UIMenuDynamicListItem it = (UIMenuDynamicListItem)MenuItems[CurrentSelection];
                        string newItem = await it.Callback(it, UIMenuDynamicListItem.ChangeDirection.Right);
                        it.CurrentListItem = newItem;
                        break;
                    }
                case UIMenuSliderItem:
                    {
                        UIMenuSliderItem it = (UIMenuSliderItem)MenuItems[CurrentSelection];
                        it.Value = res;
                        SliderChange(it, it.Value);
                        break;
                    }
                case UIMenuProgressItem:
                    {
                        UIMenuProgressItem it = (UIMenuProgressItem)MenuItems[CurrentSelection];
                        it.Value = res;
                        ProgressChange(it, it.Value);
                        break;
                    }
                case UIMenuStatsItem:
                    {
                        UIMenuStatsItem it = (UIMenuStatsItem)MenuItems[CurrentSelection];
                        it.Value = res;
                        StatItemChange(it, it.Value);
                        break;
                    }
            }
        }

        public void Select(bool playSound)
        {
            if (!MenuItems[CurrentSelection].Enabled)
            {
                Game.PlaySound(AUDIO_ERROR, AUDIO_LIBRARY);
                return;
            }

            if (playSound) Game.PlaySound(AUDIO_SELECT, AUDIO_LIBRARY);
            switch (MenuItems[CurrentSelection])
            {
                case UIMenuCheckboxItem:
                    {
                        UIMenuCheckboxItem it = (UIMenuCheckboxItem)MenuItems[CurrentSelection];
                        it.Checked = !it.Checked;
                        CheckboxChange(it, it.Checked);
                        it.CheckboxEventTrigger();
                        break;
                    }

                case UIMenuListItem:
                    {
                        UIMenuListItem it = (UIMenuListItem)MenuItems[CurrentSelection];
                        ListSelect(it, it.Index);
                        it.ListSelectedTrigger(it.Index);
                        break;
                    }

                default:
                    ItemSelect(MenuItems[CurrentSelection], CurrentSelection);
                    MenuItems[CurrentSelection].ItemActivate(this);
                    if (!Children.ContainsKey(MenuItems[CurrentSelection])) return;
                    canBuild = false;
                    _visible = false;
                    ScaleformUI._ui.CallFunction("CLEAR_ALL");
                    ScaleformUI.InstructionalButtons.Enabled = true;
                    ScaleformUI.InstructionalButtons.SetInstructionalButtons(Children[MenuItems[CurrentSelection]].InstructionalButtons);
                    _poolcontainer.MenuChangeEv(this, Children[MenuItems[CurrentSelection]], MenuState.ChangeForward);
                    MenuChangeEv(this, Children[MenuItems[CurrentSelection]], MenuState.ChangeForward);
                    Children[MenuItems[CurrentSelection]].MenuChangeEv(this, Children[MenuItems[CurrentSelection]], MenuState.ChangeForward);
                    Children[MenuItems[CurrentSelection]].canBuild = true;
                    Children[MenuItems[CurrentSelection]].Visible = true;
                    Children[MenuItems[CurrentSelection]].BuildUpMenu();
                    Children[MenuItems[CurrentSelection]].MouseEdgeEnabled = MouseEdgeEnabled;
                    break;
            }
        }
        /// <summary>
        /// Process control-stroke. Call this in the OnTick event.
        /// </summary>
        public void ProcessControl(Keys key = Keys.None)
        {
            if (!ScaleformUI._ui.IsLoaded) return;
            if (!Visible || ScaleformUI.Warning.IsShowing) return;
            if (_justOpened)
            {
                _justOpened = false;
                return;
            }

            if (UpdateOnscreenKeyboard() == 0 || IsWarningMessageActive()) return;

            if (HasControlJustBeenReleased(MenuControls.Back, key))
            {
                GoBack();
            }
            if (MenuItems.Count == 0) return;
            if (IsControlBeingPressed(MenuControls.Up, key))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoUp();
                }
            }

            else if (IsControlBeingPressed(MenuControls.Down, key))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoDown();
                }
            }

            else if (IsControlBeingPressed(MenuControls.Left, key))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoLeft();
                }
            }

            else if (IsControlBeingPressed(MenuControls.Right, key))
            {
                if (Game.GameTime - time > delay)
                {
                    ButtonDelay();
                    GoRight();
                }
            }

            else if (HasControlJustBeenPressed(MenuControls.Select, key))
            {
                Select(true);
            }

            // IsControlBeingPressed doesn't run every frame so I had to use this
            if (HasControlJustBeenReleased(MenuControls.Up) || HasControlJustBeenReleased(MenuControls.Down) || HasControlJustBeenReleased(MenuControls.Left) || HasControlJustBeenReleased(MenuControls.Right))
            {
                times = 0;
                delay = 150;
            }
        }

        void ButtonDelay()
        {
            // Increment the "changed indexes" counter
            times++;

            // Each time "times" is a multiple of 5 we decrease the delay.
            // Min delay for the scaleform is 50.. less won't change due to the
            // awaiting time for the scaleform itself.
            if (times % 5 == 0)
            {
                delay -= 10;
                if (delay < 50) delay = 50;
            }
            // Reset the time to the current game timer.
            time = Game.GameTime;
        }

        /// <summary>
        /// Process keystroke. Call this in the OnKeyDown event.
        /// </summary>
        /// <param name="key"></param>
        public void ProcessKey(Keys key)
        {
            if ((from MenuControls menuControl in _menuControls
                 select new List<Keys>(_keyDictionary[menuControl].Item1))
                .Any(tmpKeys => tmpKeys.Any(k => k == key)))
            {
                ProcessControl(key);
            }
        }

        #endregion

        #region Properties

        /// <summary>
        /// Change whether this menu is visible to the user.
        /// </summary>
        public bool Visible
        {
            get { return _visible; }
            set
            {
                _visible = value;
                _justOpened = value;
                _itemsDirty = value;
                if (ParentMenu is not null) return;
                if (Children.Count > 0 && Children.ContainsKey(MenuItems[CurrentSelection]) && Children[MenuItems[CurrentSelection]].Visible) return;
                ScaleformUI.InstructionalButtons.Enabled = value;
                ScaleformUI.InstructionalButtons.SetInstructionalButtons(InstructionalButtons);
                if (value)
                {
                    _poolcontainer.MenuChangeEv(null, this, MenuState.Opened);
                    MenuChangeEv(null, this, MenuState.Opened);
                    BuildUpMenu();
                    _poolcontainer.currentMenu = this;
                    _poolcontainer.ProcessMenus(true);
                }
                else
                {
                    _poolcontainer.MenuChangeEv(this, null, MenuState.Closed);
                    MenuChangeEv(this, null, MenuState.Closed);
                    ScaleformUI._ui.CallFunction("CLEAR_ALL");
                    _poolcontainer.ProcessMenus(false);
                }
                if (!value) return;
                if (!ResetCursorOnOpen) return;
                SetCursorLocation(0.5f, 0.5f);
                Screen.Hud.CursorSprite = CursorSprite.Normal;
            }
        }

        internal async void BuildUpMenu()
        {
            while (!ScaleformUI._ui.IsLoaded) await BaseScript.Delay(0);
            ScaleformUI._ui.CallFunction("CREATE_MENU", Title, Subtitle, Offset.X, Offset.Y, AlternativeTitle, _customTexture.Key, _customTexture.Value, MaxItemsOnScreen, EnableAnimation, (int)AnimationType);
            if (Windows.Count > 0)
            {
                foreach (var wind in Windows)
                {
                    switch (wind)
                    {
                        case UIMenuHeritageWindow:
                            var her = (UIMenuHeritageWindow)wind;
                            ScaleformUI._ui.CallFunction("ADD_WINDOW", her.id, her.Mom, her.Dad);
                            break;
                        case UIMenuDetailsWindow:
                            var det = (UIMenuDetailsWindow)wind;
                            ScaleformUI._ui.CallFunction("ADD_WINDOW", det.id, det.DetailBottom, det.DetailMid, det.DetailTop, det.DetailLeft.Txd, det.DetailLeft.Txn, det.DetailLeft.Pos.X, det.DetailLeft.Pos.Y, det.DetailLeft.Size.Width, det.DetailLeft.Size.Height);
                            if (det.StatWheelEnabled)
                            {
                                foreach (var stat in det.DetailStats)
                                    ScaleformUI._ui.CallFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", Windows.IndexOf(det), stat.Percentage, (int)stat.HudColor);
                            }
                            break;
                    }

                }
            }
            var timer = Game.GameTime;
            if (MenuItems.Count == 0)
            {
                while (MenuItems.Count == 0)
                {
                    await BaseScript.Delay(0);
                    if (Game.GameTime - timer > 150)
                    {
                        ScaleformUI._ui.CallFunction("SET_CURRENT_ITEM", CurrentSelection);
                        return;
                    }
                }
            }
            var i = 0;
            while (i < MenuItems.Count)
            {
                await BaseScript.Delay(1);
                if (!canBuild) break;
                var item = MenuItems[i];
                var index = i;
                AddTextEntry($"menu_{_poolcontainer._menuList.IndexOf(this)}_desc_{index}", item.Description);

                BeginScaleformMovieMethod(ScaleformUI._ui.Handle, "ADD_ITEM");
                PushScaleformMovieFunctionParameterInt(item._itemId);
                PushScaleformMovieMethodParameterString(item.Label);
                if (item.DescriptionHash != 0 && string.IsNullOrWhiteSpace(item.Description))
                {
                    BeginTextCommandScaleformString("STRTNM1");
                    AddTextComponentSubstringTextLabelHashKey(item.DescriptionHash);
                    EndTextCommandScaleformString_2();
                }
                else
                {
                    BeginTextCommandScaleformString($"menu_{_poolcontainer._menuList.IndexOf(this)}_desc_{index}");
                    EndTextCommandScaleformString_2();
                }
                PushScaleformMovieFunctionParameterBool(item.Enabled);
                PushScaleformMovieFunctionParameterBool(item.BlinkDescription);
                switch (item)
                {
                    case UIMenuDynamicListItem:
                        UIMenuDynamicListItem dit = (UIMenuDynamicListItem)item;
                        PushScaleformMovieMethodParameterString(dit.CurrentListItem);
                        PushScaleformMovieFunctionParameterInt(0);
                        PushScaleformMovieFunctionParameterInt((int)dit.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)dit.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)dit.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)dit.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuListItem:
                        UIMenuListItem it = (UIMenuListItem)item;
                        AddTextEntry($"listitem_{index}_list", string.Join(",", it.Items));
                        BeginTextCommandScaleformString($"listitem_{index}_list");
                        EndTextCommandScaleformString();
                        PushScaleformMovieFunctionParameterInt(it.Index);
                        PushScaleformMovieFunctionParameterInt((int)it.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)it.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)it.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuCheckboxItem:
                        UIMenuCheckboxItem check = (UIMenuCheckboxItem)item;
                        PushScaleformMovieFunctionParameterInt((int)check.Style);
                        PushScaleformMovieMethodParameterBool(check.Checked);
                        PushScaleformMovieFunctionParameterInt((int)check.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)check.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)check.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuSliderItem:
                        UIMenuSliderItem prItem = (UIMenuSliderItem)item;
                        PushScaleformMovieFunctionParameterInt(prItem._max);
                        PushScaleformMovieFunctionParameterInt(prItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(prItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)prItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)prItem.SliderColor);
                        PushScaleformMovieFunctionParameterBool(prItem._heritage);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuProgressItem:
                        UIMenuProgressItem slItem = (UIMenuProgressItem)item;
                        PushScaleformMovieFunctionParameterInt(slItem._max);
                        PushScaleformMovieFunctionParameterInt(slItem._multiplier);
                        PushScaleformMovieFunctionParameterInt(slItem.Value);
                        PushScaleformMovieFunctionParameterInt((int)slItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.HighlightedTextColor);
                        PushScaleformMovieFunctionParameterInt((int)slItem.SliderColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuStatsItem:
                        UIMenuStatsItem statsItem = (UIMenuStatsItem)item;
                        PushScaleformMovieFunctionParameterInt(statsItem.Value);
                        PushScaleformMovieFunctionParameterInt(statsItem.Type);
                        PushScaleformMovieFunctionParameterInt((int)statsItem.Color);
                        PushScaleformMovieFunctionParameterInt((int)statsItem.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)statsItem.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)statsItem.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)statsItem.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    case UIMenuSeparatorItem:
                        UIMenuSeparatorItem separatorItem = (UIMenuSeparatorItem)item;
                        PushScaleformMovieFunctionParameterBool(separatorItem.Jumpable);
                        PushScaleformMovieFunctionParameterInt((int)item.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)item.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        break;
                    default:
                        PushScaleformMovieFunctionParameterInt((int)item.MainColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightColor);
                        PushScaleformMovieFunctionParameterInt((int)item.TextColor);
                        PushScaleformMovieFunctionParameterInt((int)item.HighlightedTextColor);
                        EndScaleformMovieMethod();
                        ScaleformUI._ui.CallFunction("SET_RIGHT_LABEL", index, item.RightLabel);
                        if (item.RightBadge != BadgeIcon.NONE)
                            ScaleformUI._ui.CallFunction("SET_RIGHT_BADGE", index, (int)item.RightBadge);
                        break;
                }
                if (item.LeftBadge != BadgeIcon.NONE)
                    ScaleformUI._ui.CallFunction("SET_LEFT_BADGE", index, (int)item.LeftBadge);
                if (item.SidePanel != null)
                {
                    switch (item.SidePanel)
                    {
                        case UIMissionDetailsPanel:
                            var mis = (UIMissionDetailsPanel)item.SidePanel;
                            ScaleformUI._ui.CallFunction("ADD_SIDE_PANEL_TO_ITEM", index, 0, (int)mis.PanelSide, (int)mis._titleType, mis.Title, (int)mis.TitleColor, mis.TextureDict, mis.TextureName);
                            foreach (var _it in mis.Items)
                            {
                                ScaleformUI._ui.CallFunction("ADD_MISSION_DETAILS_DESC_ITEM", index, _it.Type, _it.TextLeft, _it.TextRight, (int)_it.Icon, (int)_it.IconColor, _it.Tick);
                            }
                            break;
                        case UIVehicleColourPickerPanel:
                            var cp = (UIVehicleColourPickerPanel)item.SidePanel;
                            ScaleformUI._ui.CallFunction("ADD_SIDE_PANEL_TO_ITEM", index, 1, (int)cp.PanelSide, (int)cp._titleType, cp.Title, (int)cp.TitleColor);
                            break;
                    }
                }

                if (item.Panels.Count == 0)
                {
                    i++;
                    continue;
                }
                foreach (var panel in item.Panels)
                {
                    var pan = item.Panels.IndexOf(panel);
                    switch (panel)
                    {
                        case UIMenuColorPanel:
                            UIMenuColorPanel cp = (UIMenuColorPanel)panel;
                            ScaleformUI._ui.CallFunction("ADD_PANEL", index, 0, cp.Title, (int)cp.ColorPanelColorType, cp.CurrentSelection, cp.CustomColors is not null ? string.Join(",", cp.CustomColors) : "");
                            break;
                        case UIMenuPercentagePanel:
                            UIMenuPercentagePanel pp = (UIMenuPercentagePanel)panel;
                            ScaleformUI._ui.CallFunction("ADD_PANEL", index, 1, pp.Title, pp.Min, pp.Max, pp.Percentage);
                            break;
                        case UIMenuGridPanel:
                            UIMenuGridPanel gp = (UIMenuGridPanel)panel;
                            ScaleformUI._ui.CallFunction("ADD_PANEL", index, 2, gp.TopLabel, gp.RightLabel, gp.LeftLabel, gp.BottomLabel, gp.CirclePosition.X, gp.CirclePosition.Y, true, (int)gp.GridType);
                            break;
                        case UIMenuStatisticsPanel:
                            UIMenuStatisticsPanel sp = (UIMenuStatisticsPanel)panel;
                            ScaleformUI._ui.CallFunction("ADD_PANEL", index, 3);
                            if (sp.Items.Count > 0)
                                foreach (var stat in sp.Items)
                                    ScaleformUI._ui.CallFunction("ADD_STATISTIC_TO_PANEL", index, pan, stat.Text, stat.Value);
                            break;
                    }
                }
                i++;
            } 

            ScaleformUI._ui.CallFunction("SET_CURRENT_ITEM", CurrentSelection);
            if (MenuItems[CurrentSelection] is UIMenuSeparatorItem)
            {
                if ((MenuItems[CurrentSelection] as UIMenuSeparatorItem).Jumpable)
                {
                    GoDown();
                }
            }
            ScaleformUI._ui.CallFunction("ENABLE_MOUSE", MouseControlsEnabled);
        }

        /// <summary>
        /// Returns the current selected item's index.
        /// Change the current selected item to index. Use this after you add or remove items dynamically.
        /// </summary>
        public int CurrentSelection
        {
            get { return MenuItems.Count == 0 ? 0 : _activeItem % MenuItems.Count; }
            set
            {
                if (MenuItems.Count == 0) _activeItem = 0;
                MenuItems[CurrentSelection].Selected = false;
                _activeItem = 1000000 - (1000000 % MenuItems.Count) + value;
                MenuItems[CurrentSelection].Selected = true;
                ScaleformUI._ui.CallFunction("SET_CURRENT_ITEM", CurrentSelection);
            }
        }

        /// <summary>
        /// Returns false if last input was made with mouse and keyboard, true if it was made with a controller.
        /// </summary>
        public static bool IsUsingController => !IsInputDisabled(2);


        /// <summary>
        /// Returns the amount of items in the menu.
        /// </summary>
        public int Size => MenuItems.Count;


        /// <summary>
        /// Returns the title object.
        /// </summary>
        public string Title { get; internal set; }


        /// <summary>
        /// Returns the subtitle object.
        /// </summary>
        public string Subtitle { get; internal set; }


        /// <summary>
        /// String to pre-attach to the counter string. Useful for color codes.
        /// </summary>
        public string CounterPretext { get; set; }


        /// <summary>
        /// If this is a nested menu, returns the parent menu. You can also set it to a menu so when pressing Back it goes to that menu.
        /// </summary>
        public UIMenu ParentMenu { get; set; }


        /// <summary>
        /// If this is a nested menu, returns the item it was bound to.
        /// </summary>
        public UIMenuItem ParentItem { get; set; }

        //Tree structure
        public Dictionary<UIMenuItem, UIMenu> Children { get; internal set; }

        /// <summary>
        /// Returns the current width offset.
        /// </summary>
        public int WidthOffset { get; private set; }
        public bool MouseControlsEnabled
        {
            get => mouseControlsEnabled;
            set
            {
                mouseControlsEnabled = value;
                if (Visible)
                {
                    ScaleformUI._ui.CallFunction("ENABLE_MOUSE", value);
                }
            }
        }

        #endregion

        #region Event Invokers
        protected virtual void IndexChange(int newindex)
        {
            OnIndexChange?.Invoke(this, newindex);
        }

        internal virtual void ListChange(UIMenuListItem sender, int newindex)
        {
            OnListChange?.Invoke(this, sender, newindex);
        }

        internal virtual void ProgressChange(UIMenuProgressItem sender, int newindex)
        {
            OnProgressChange?.Invoke(this, sender, newindex);
        }

        protected virtual void ListSelect(UIMenuListItem sender, int newindex)
        {
            OnListSelect?.Invoke(this, sender, newindex);
        }

        protected virtual void SliderChange(UIMenuSliderItem sender, int newindex)
        {
            OnSliderChange?.Invoke(this, sender, newindex);
        }

        protected virtual void ItemSelect(UIMenuItem selecteditem, int index)
        {
            OnItemSelect?.Invoke(this, selecteditem, index);
        }

        protected virtual void CheckboxChange(UIMenuCheckboxItem sender, bool Checked)
        {
            OnCheckboxChange?.Invoke(this, sender, Checked);
        }

        public virtual void StatItemChange(UIMenuStatsItem item, int value)
        {
            OnStatsItemChanged?.Invoke(this, item, value);
        }

        internal virtual void MenuChangeEv(UIMenu oldmenu, UIMenu newmenu, MenuState state)
        {
            OnMenuStateChanged?.Invoke(oldmenu, newmenu, state);
        }

        protected virtual void ColorPanelChange(UIMenuItem item, UIMenuColorPanel panel, int index)
        {
            OnColorPanelChange?.Invoke(item, panel, index);
        }
        protected virtual void PercentagePanelChange(UIMenuItem item, UIMenuPercentagePanel panel, float index)
        {
            OnPercentagePanelChange?.Invoke(item, panel, index);
        }
        protected virtual void GridPanelChange(UIMenuItem item, UIMenuGridPanel panel, PointF index)
        {
            OnGridPanelChange?.Invoke(item, panel, index);
        }

        #endregion

        public enum MenuControls
        {
            Up,
            Down,
            Left,
            Right,
            Select,
            Back
        }

    }
}

