using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public class TextTab : BaseTab
    {
        public string TextTitle { get; set; }
        public int WordWrap { get; set; }
        public List<BasicTabItem> LabelsList = new List<BasicTabItem>();
        public string TextureDict { get; private set; }
        public string TextureName { get; private set; }
        public TextTab(string name, string title, SColor color) : base(name, color)
        {
            TextTitle = title;
            _type = 0;
        }

        public void AddTitle(string title)
        {
            if (string.IsNullOrWhiteSpace(TextTitle))
                TextTitle = title;
        }

        public void AddItem(BasicTabItem item)
        {
            LabelsList.Add(item);
        }

        /// <summary>
        /// Image suggested not bigger than 1280x720
        /// </summary>
        /// <param name="txd"></param>
        /// <param name="txn"></param>
        public void UpdateBackground(string txd, string txn)
        {
            TextureDict = txd;
            TextureName = txn;
            if (Parent != null && Parent.Visible)
            {
                Parent._pause._pause.CallFunction("UPDATE_BASE_TAB_BACKGROUND", Parent.Tabs.IndexOf(this), txd, txn);
            }
        }
    }
}