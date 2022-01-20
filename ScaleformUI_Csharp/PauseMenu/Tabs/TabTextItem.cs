using CitizenFX.Core;
using System.Collections.Generic;
using System.Drawing;

namespace ScaleformUI.PauseMenu
{
    public class TabTextItem : BaseTab
    {
        public string TextTitle { get; set; }
        public int WordWrap { get; set; }
        public List<BasicTabItem> LabelsList = new List<BasicTabItem>();

        public TabTextItem(string name, string title) : base(name)
        {
            TextTitle = title;
        }

        public async void AddTitle(string title)
        {
            if(string.IsNullOrWhiteSpace(TextTitle))
                TextTitle = title;
        }

        public async void AddItem(BasicTabItem item)
        {
            LabelsList.Add(item);
        }
    }
}