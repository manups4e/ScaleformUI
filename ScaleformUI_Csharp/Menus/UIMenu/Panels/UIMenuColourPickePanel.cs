using CitizenFX.Core;
using ScaleformUI.Elements;

namespace ScaleformUI.Menu
{
    public enum ColorPickerType
    {
        Classic,
        Matte,
        ChromesMetal,
        Chameleon
    }
    public class UIMenuColourPickePanel : UIMenuPanel
    {
        internal int _value;
        internal SColor color;

        public int Value
        {
            get => _value;
            set
            {
                _value = value;
                if (value == -1)
                {
                    _setValue(_value);
                    return;
                }
                if (_value < 0)
                    _value = 0;
                if (_value > 159)
                    _value = 159;
                _setValue(_value);
                color = VehicleColors.GetColorById(_value);
                PickerSelect(VehicleColors.GetColorById(_value));
            }
        }
        public SColor Color => color;
        public event VehicleColorPickerSelectEvent OnColorSelect;
        public event VehicleColorPickerHoverEvent OnColorHover;
        public event VehicleColorPickerHoverEvent OnColorRollOut;
        internal ColorPickerType PanelType;
        public UIMenuColourPickePanel(ColorPickerType panelType)
        {
            PanelType = panelType;
        }

        internal void _setValue(int val)
        {
            if (ParentItem != null && ParentItem.Parent != null)
            {
                int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                ParentItem.Parent.SendPanelsToItemScaleform(it, true);
            }
        }

        internal void PickerHovered(int colorId, SColor color)
        {
            OnColorHover?.Invoke(colorId, color);
        }
        internal void PickerRollout()
        {
            OnColorRollOut?.Invoke(_value, color);
        }
        internal void PickerSelect(SColor color)
        {
            OnColorSelect?.Invoke(null, null, _value, color);
        }

    }
}
