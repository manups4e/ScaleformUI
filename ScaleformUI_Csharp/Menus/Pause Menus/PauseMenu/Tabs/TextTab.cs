using ScaleformUI.Elements;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenus.Elements;

namespace ScaleformUI.PauseMenu
{
    public class TextTab : BaseTab
    {
        public string TextTitle { get; set; }
        public int WordWrap { get; set; }
        public string BGTextureDict { get; private set; }
        public string BGTextureName { get; private set; }
        public string RightTextureDict { get; private set; }
        public string RightTextureName { get; private set; }

        public new TextColumn LeftColumn
        {
            get => (TextColumn)base.LeftColumn;
            internal set => base.LeftColumn = value;
        }

        public TextTab(string name, string title, SColor color) : base(name, color)
        {
            TextTitle = title;
            LeftColumn = new TextColumn(0);
            _identifier = "Page_Simple";
            _type = 0;
        }

        public void AddTitle(string title)
        {
            if (string.IsNullOrWhiteSpace(TextTitle))
                TextTitle = title;
        }

        public void AddItem(PauseMenuItem item)
        {
            LeftColumn.AddItem(item);
        }

        public override void Populate()
        {
            for (int i = 0; i < LeftColumn.Items.Count; i++)
            {
                SetDataSlot(LeftColumn.position, i);
            }
        }

        public override void ShowColumns()
        {
            LeftColumn.ShowColumn();
            LeftColumn.InitColumnScroll(true, 3, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
            LeftColumn.SetColumnScroll(-1, -1, -1, "", LeftColumn.Items.Count < LeftColumn.VisibleItems);
            LeftColumn.HighlightColumn(true, false, true);
        }

        public override void Focus()
        {
            LeftColumn.HighlightColumn(true, false, true);
        }

        public override void SetDataSlot(PM_COLUMNS slot, int index)
        {
            LeftColumn.SetDataSlot(index);
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