using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.PauseMenu
{
    public class SettingsSeparatorItem : SettingsItem
    {
        public bool IsJumpable { get; private set; }
        public SettingsSeparatorItem(string label) : base(label, "")
        {
            ItemType = SettingsItemType.Separator;
            Label = label;
        }
        public SettingsSeparatorItem() : base("", "")
        {
            ItemType = SettingsItemType.Empty;
        }
    }
}