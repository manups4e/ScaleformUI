using ScaleformUI.Elements;

namespace ScaleformUI.PauseMenu
{
    public class TextTab : BaseTab
    {
        public string TextTitle { get; set; }
        public int WordWrap { get; set; }
        public List<BasicTabItem> LabelsList = new List<BasicTabItem>();
        public string BGTextureDict { get; private set; }
        public string BGTextureName { get; private set; }
        public string RightTextureDict { get; private set; }
        public string RightTextureName { get; private set; }

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
            BGTextureDict = txd;
            BGTextureName = txn;
            if (Parent != null && Parent.Visible)
            {
                Parent._pause._pause.CallFunction("UPDATE_BASE_TAB_BACKGROUND", txd, txn);
            }
        }

        /// <summary>
        /// Image suggested has size 288 X 430
        /// </summary>
        /// <param name="txd"></param>
        /// <param name="txn"></param>
        public void AddPicture(string txd, string txn)
        {
            RightTextureDict = txd;
            RightTextureName = txn;
            if (Parent != null && Parent.Visible)
            {
                Parent._pause._pause.CallFunction("SET_BASE_TAB_RIGHT_PICTURE", txd, txn);
            }
        }
    }
}