using ScaleformUI.Elements;
using ScaleformUI.Menus;

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

        public TextTab(string name, string title, SColor color) : base(name, color)
        {
            TextTitle = title;
            LeftColumn = new PM_Column(0);
            _identifier = "Page_Simple";
            _type = 0;
        }

        public void AddTitle(string title)
        {
            if (string.IsNullOrWhiteSpace(TextTitle))
                TextTitle = title;
        }

        public void AddItem(BasicTabItem item)
        {
            this.LeftColumn.AddItem(item);
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
            ShowColumn(PM_COLUMNS.LEFT);
            InitColumnScroll(LeftColumn.position, true, 3, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
            SetColumnScroll(LeftColumn.position, -1, -1, -1, "", LeftColumn.Items.Count < 16);
        }

        public override void HighlightColumn(PM_COLUMNS slot, int index)
        {
            Parent._pause._pause.CallFunction("SET_COLUMN_FOCUS", (int)slot, false, false, false);
        }

        public override void SetDataSlot(PM_COLUMNS slot, int index)
        {
            if (index >= LeftColumn.Items.Count)
                return;
            BasicTabItem it = LeftColumn.Items[index];
            var labels = it.Label.SplitLabel;
            BeginScaleformMovieMethod(Parent._pause._pause.Handle, "SET_DATA_SLOT");
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterBool(true);
            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
            for (var i = 0; i < labels?.Length; i++)
                AddTextComponentScaleform(labels[i]);
            EndTextCommandScaleformString_2();
            EndScaleformMovieMethod();
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