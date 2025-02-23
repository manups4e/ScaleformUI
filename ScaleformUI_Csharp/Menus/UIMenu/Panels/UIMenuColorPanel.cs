using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Elements;

namespace ScaleformUI.Menu
{
    public enum ColorPanelType { Hair, Makeup }
    public class UIMenuColorPanel : UIMenuPanel
    {
        public string Title { get; set; }
        public ColorPanelType ColorPanelColorType { get; set; }
        public List<SColor> CustomColors { get; private set; }
        internal int _value { get; set; }
        public event ColorPanelChangedEvent OnColorPanelChange;
        public int CurrentSelection
        {
            get
            {
                //_getValue();
                return _value;
            }
            set
            {
                _value = value;
                if (CustomColors is null)
                {
                    if (value > 63)
                        _value -= 63;
                    if (value < 0)
                        _value += 63;
                }
                else
                {
                    if (value > CustomColors.Count - 1)
                        _value -= CustomColors.Count - 1;
                    if (value < 0)
                        _value += CustomColors.Count - 1;
                }
                if (ParentItem != null && ParentItem.Parent != null && ParentItem.Parent.Visible)
                {
                    int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                    ParentItem.Parent.SendPanelsToItemScaleform(it, true);
                    PanelChanged();
                    ParentItem.Parent.ColorPanelChange(ParentItem, this, _value);
                }
            }
        }
        public UIMenuColorPanel(string title, ColorPanelType ColorType, int startIndex = 0)
        {
            Title = title ?? "Color Panel";
            ColorPanelColorType = ColorType;
            _value = startIndex;
        }

        public UIMenuColorPanel(string title, List<SColor> colors, int startIndex = 0)
        {
            Title = title ?? "Color Panel";
            ColorPanelColorType = (ColorPanelType)2;
            _value = startIndex;
            CustomColors = colors;
        }

        internal void PanelChanged()
        {
            OnColorPanelChange?.Invoke(ParentItem, this, CurrentSelection);
        }
    }
}
