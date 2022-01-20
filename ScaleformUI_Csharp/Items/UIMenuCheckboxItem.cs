using CitizenFX.Core;
using CitizenFX.Core.Native;
using System;
using System.Drawing;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public enum UIMenuCheckboxStyle
	{
		Cross,
		Tick
	}

    public class UIMenuCheckboxItem : UIMenuItem
    {
        private bool _checked;

        /// <summary>
        /// Triggered when the checkbox state is changed.
        /// </summary>
        public event ItemCheckboxEvent CheckboxEvent;

        public UIMenuCheckboxStyle Style { get; set; }

        /// <summary>
        /// Checkbox item with a toggleable checkbox.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="check">Boolean value whether the checkbox is checked.</param>
        public UIMenuCheckboxItem(string text, bool check) : this(text, check, "")
        {
        }

        /// <summary>
        /// Checkbox item with a toggleable checkbox.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="check">Boolean value whether the checkbox is checked.</param>
        /// <param name="description">Description for this item.</param>
        public UIMenuCheckboxItem(string text, bool check, string description) : this(text, UIMenuCheckboxStyle.Tick, check, description, HudColor.HUD_COLOUR_PAUSE_BG, HudColor.HUD_COLOUR_WHITE)
        {
        }

        /// <summary>
        /// Checkbox item with a toggleable checkbox.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="style">CheckBox style (Tick or Cross).</param>
        /// <param name="check">Boolean value whether the checkbox is checked.</param>
        /// <param name="description">Description for this item.</param>
        public UIMenuCheckboxItem(string text, UIMenuCheckboxStyle style, bool check, string description) : this(text, style, check, description, HudColor.HUD_COLOUR_PAUSE_BG, HudColor.HUD_COLOUR_WHITE)
        {
        }

        /// <summary>
        /// Checkbox item with a toggleable checkbox.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="style">CheckBox style (Tick or Cross).</param>
        /// <param name="check">Boolean value whether the checkbox is checked.</param>
        /// <param name="description">Description for this item.</param>
        /// <param name="mainColor">Main item color.</param>
        /// <param name="highlightColor">Highlight item color.</param>
        public UIMenuCheckboxItem(string text, UIMenuCheckboxStyle style, bool check, string description, HudColor mainColor, HudColor highlightColor) : base(text, description, mainColor, highlightColor, HudColor.HUD_COLOUR_WHITE, HudColor.HUD_COLOUR_BLACK)
        {
            Style = style;
            _checked = check;
            _itemId = 2;
        }


        /// <summary>
        /// Change or get whether the checkbox is checked.
        /// </summary>
        public bool Checked { get => _checked; 
            set
            {
                _checked = value;
                var it = Parent.MenuItems.IndexOf(this);
                ScaleformUI._ui.CallFunction("SET_INPUT_EVENT", 16, it, value);
            }
        }

        public void CheckboxEventTrigger()
        {
            CheckboxEvent?.Invoke(this, Checked);
        }

        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuCheckboxItem cannot have a right badge.");
        }

        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuListItem cannot have a right label.");
        }
    }
}