using ScaleformUI.Elements;

namespace ScaleformUI.Menu
{
    public class UIMenuColourPickePanel : UIMenuPanel
    {
        internal int _value;

        public int Value => _value;
        public VehicleColorPickerSelectEvent OnColorSelect;

        public UIMenuColourPickePanel()
        {

        }
        internal void PickerSelect(SColor color)
        {
            OnColorSelect?.Invoke(ParentItem, null, _value, color);
        }

    }
}
