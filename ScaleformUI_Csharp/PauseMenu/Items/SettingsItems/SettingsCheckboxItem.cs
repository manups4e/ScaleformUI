using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public delegate void SettingsCheckboxChanged(SettingsItem item, bool value);
    public class SettingsCheckboxItem : SettingsItem
    {
        private bool isChecked;
        public event SettingsCheckboxChanged OnCheckboxChange;
        public UIMenuCheckboxStyle CheckBoxStyle { get; set; }
        public bool IsChecked
        {
            get => isChecked;
            set
            {
                isChecked = value;
                if (Parent != null)
                {
                    int tab = Parent.Parent.Parent.Tabs.IndexOf(Parent.Parent);
                    int leftItem = Parent.Parent.LeftItemList.IndexOf(Parent);
                    int rightIndex = Parent.ItemList.IndexOf(this);
                    Parent.Parent.Parent._pause.SetRightSettingsItemBool(tab, leftItem, rightIndex, isChecked);
                }
                CheckboxChanged();
            }
        }
        public SettingsCheckboxItem(string label, UIMenuCheckboxStyle style, bool @checked) : base(label, "")
        {
            ItemType = SettingsItemType.CheckBox;
            Label = label;
            CheckBoxStyle = style;
            IsChecked = @checked;
        }

        public void CheckboxChanged()
        {
            OnCheckboxChange?.Invoke(this, isChecked);
        }
    }
}
