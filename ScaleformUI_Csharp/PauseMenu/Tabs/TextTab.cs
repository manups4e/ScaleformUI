using CitizenFX.Core;
using System.Collections.Generic;
using System.Drawing;

namespace ScaleformUI.PauseMenu
{
    public class TextTab : BaseTab
    {
        public string TextTitle { get; set; }
        public int WordWrap { get; set; }
        public List<BasicTabItem> LabelsList = new List<BasicTabItem>();

        public TextTab(string name, string title) : base(name)
        {
            TextTitle = title;
            _type = 1;
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