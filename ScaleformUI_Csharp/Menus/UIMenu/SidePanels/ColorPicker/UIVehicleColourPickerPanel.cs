using ScaleformUI.Elements;
using System.Drawing;

namespace ScaleformUI.Menu
{

    public class UIVehicleColourPickerPanel : UIMenuSidePanel
    {
        private string title;
        public string Title
        {
            get => title;
            set
            {
                title = value;
                if (ParentItem is not null && ParentItem.Parent != null && ParentItem.Parent.Visible)
                {
                    int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                    ParentItem.Parent.SendSidePanelToScaleform(it, true);
                }
            }
        }
        public SColor TitleColor;
        internal SColor color;
        internal SidePanelsTitleType _titleType;
        internal int _value;

        public int Value => _value;
        public SColor Color => color;
        public event VehicleColorPickerSelectEvent OnVehicleColorPickerSelect;
        public event VehicleColorPickerHoverEvent OnColorHover;

        /// <summary>
        /// Adds a Mission Details panel as side menu panel
        /// </summary>
        /// <param name="side">Left or Right?</param>
        /// <param name="title">Panel's title</param>
        /// <param name="inside">if true the title will be within the panel itself else will be the same as the menu.</param>
        /// <param name="txd">Texture dictionary for the picture</param>
        /// <param name="txn">Texture name for the picture</param>
        public UIVehicleColourPickerPanel(PanelSide side, string title)
        {
            PanelSide = side;
            _titleType = SidePanelsTitleType.Big;
            Title = title;
            TitleColor = SColor.HUD_None;
        }

        /// <summary>
        /// Adds a Mission Details panel as side menu panel
        /// </summary>
        /// <param name="side">Left or Right?</param>
        /// <param name="title">Panel's title</param>
        /// <param name="color">Background color for the panel title</param>
        public UIVehicleColourPickerPanel(PanelSide side, string title, SColor titleColor)
        {
            PanelSide = side;
            _titleType = SidePanelsTitleType.Small;
            Title = title;
            TitleColor = titleColor;
        }

        internal void PickerSelect(SColor color)
        {
            this.color = color;
            OnVehicleColorPickerSelect?.Invoke(ParentItem, this, _value, color);
        }
        internal void PickerHovered(int colorId, SColor color)
        {
            OnColorHover?.Invoke(colorId, color);
        }
        internal void PickerRollout()
        {
            OnColorHover?.Invoke(_value, color);
        }
    }
}
