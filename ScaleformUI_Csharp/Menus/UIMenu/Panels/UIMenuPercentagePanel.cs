using CitizenFX.Core;
using CitizenFX.Core.Native;
using System.Drawing;

namespace ScaleformUI.Menu
{
    public class UIMenuPercentagePanel : UIMenuPanel
    {

        public string Min { get; set; }
        public string Max { get; set; }
        public string Title { get; set; }

        public event PercentagePanelChangedEvent OnPercentagePanelChange;

        internal float _value;

        public float Percentage
        {
            get
            {
                return _value;
            }
            set
            {
                _value = value;
                if (ParentItem != null && ParentItem.Parent != null && ParentItem.Parent.Visible)
                {
                    int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                    ParentItem.Parent.SendPanelsToItemScaleform(it, true);
                    PercentagePanelChange();
                    ParentItem.Parent.PercentagePanelChange(ParentItem, this, _value);
                }
            }
        }


        public UIMenuPercentagePanel(string title, string MinText = "0%", string MaxText = "100%", float initialValue = 0)
        {
            Min = MinText;
            Max = MaxText;
            Title = !string.IsNullOrWhiteSpace(title) ? title : "Opacity";
            _value = initialValue;
        }

        internal void PercentagePanelChange()
        {
            OnPercentagePanelChange?.Invoke(ParentItem, this, Percentage);
        }
    }
}
