using ScaleformUI.Elements;
using ScaleformUI.PauseMenu;

namespace ScaleformUI.Menus
{
    public enum PM_COLUMNS
    {
        LEFT,
        MIDDLE,
        RIGHT,
        EXTRA3,
        EXTRA4,
        LEFT_MIDDLE,
        MIDDLE_RIGHT,
    };

    public delegate void IndexChanged(int index);
    public delegate void ItemSelect(TabView menu, TabLeftItem item, int leftItemIndex);
    public delegate void RightItemSelect(TabView menu, SettingsItem item, int leftItemIndex, int rightItemIndex);

    public class PM_Column
    {
        internal PM_COLUMNS position;
        internal int index = 0;
        //used in playerlisttab
        internal int type = -1;
        private bool columnVisible;

        internal bool visible => Parent != null && Parent.Visible && Parent.Parent != null && Parent.Parent.Visible;
        public List<PauseMenuItem> Items { get; internal set; } = new List<PauseMenuItem>();
        public virtual int Index
        {
            get => index;
            set
            {
                Items[index].Selected = false;
                index = value;
                if (index < 0)
                    index = Items.Count - 1;
                else if (index >= Items.Count)
                    index = 0;
                Items[index].Selected = true;
                if (visible && Parent.CurrentColumnIndex == (int)position)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, false, false);
            }
        }

        public bool ColumnVisible
        {
            get => columnVisible;
            set
            {
                columnVisible = value;
                Main.PauseMenu._pause.CallFunction("SHOW_COLUMN", (int)position, columnVisible);
            }
        }
        public int VisibleItems { get; internal set; }
        public bool Focused { get; internal set; }
        public string CaptionLeft { get; internal set; } = string.Empty;
        public string CaptionRight { get; internal set; } = string.Empty;
        public string Label { get; internal set; }
        public SColor Color { get; set; } = SColor.HUD_Freemode;
        public BaseTab Parent { get; internal set; }

        public PM_Column(PM_COLUMNS position)
        {
            this.position = position;
        }

        public PM_Column(int position) : this((PM_COLUMNS)position) { }

        public virtual void AddItem(PauseMenuItem item)
        {
            Items.Add(item);
        }

        public void Clear()
        {
            ClearColumn();
        }

        public virtual void Populate() { }

        public virtual void SetDataSlot(int index) { }

        public virtual void UpdateSlot(int index) { }

        public virtual void AddSlot(int index) { }
        public virtual void RemoveSlot(int idx)
        {
            if (idx >= Items.Count) return;
            var selectedItem = Index;
            Items[idx].Selected = false;
            Items.RemoveAt(idx);
            if (visible)
                Main.PauseMenu._pause.CallFunction("REMOVE_SLOT", (int)position, idx, false, false);
            if (Items.Count > 0)
            {
                if (idx == this.index)
                    index = idx >= Items.Count ? Items.Count - 1 : idx >= 0 && idx < Items.Count ? idx : 0;
                else
                {
                    if (selectedItem < Items.Count)
                        index = selectedItem;
                    else
                        index = Items.Count - 1;
                }
                Items[index].Selected = true;
                if (visible && Parent.CurrentColumnIndex == (int)position)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, idx, false, false);
            }
        }

        public virtual void GoUp() { }
        public virtual void GoDown() { }
        public virtual void GoLeft() { }
        public virtual void GoRight() { }
        public virtual void Select() { }
        public virtual void GoBack() { }
        public virtual void MouseScroll(int dir) { }

        public virtual void HighlightColumn(bool highlighted = false, bool moveFocus = false, bool prevHighlight = false)
        {
            if (visible)
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, highlighted, moveFocus, prevHighlight);
        }
        public virtual void ClearColumn()
        {
            Items.Clear();
            index = 0;
            if (visible)
                Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
        }
        public virtual void ShowColumn(bool show = true)
        {
             Main.PauseMenu._pause.CallFunction("DISPLAY_DATA_SLOT", (int)position);
        }
        public virtual void InitColumnScroll(bool visible, int columns, ScrollType scrollType, ScrollArrowsPosition arrowPosition, bool @override = false, float xColOffset = 0f)
        {
             Main.PauseMenu._pause.CallFunction("INIT_COLUMN_SCROLL", (int)position, visible, columns, (int)scrollType, (int)arrowPosition, @override, xColOffset);
        }
        public virtual void SetColumnScroll(int currentPosition, int maxPosition, int maxVisible, string caption, bool forceInvisible = false, string captionR = "")
        {
             Main.PauseMenu._pause.CallFunction("SET_COLUMN_SCROLL", (int)position, currentPosition, maxPosition, maxVisible, caption, forceInvisible, captionR);
        }

        public virtual void SetColumnScroll(int currentPosition, int maxPosition, int maxVisible = -1)
        {
            if (visible)
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_SCROLL", (int)position, currentPosition, maxPosition, maxVisible);
        }

        public virtual void SetColumnScroll(string caption, params object[] args)
        {
            if (visible)
            {
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_SCROLL");
                ScaleformMovieMethodAddParamInt((int)position);
                ScaleformMovieMethodAddParamInt(0);
                ScaleformMovieMethodAddParamInt(0);
                ScaleformMovieMethodAddParamInt(0);
                BeginTextCommandScaleformString(caption);
                foreach (object arg in args)
                {
                    switch (arg)
                    {
                        case int:
                            AddTextComponentInteger((int)arg);
                            break;
                        case string:
                            AddTextComponentSubstringPlayerName((string)arg);
                            break;
                        case float:
                            AddTextComponentFloat((float)arg, 2);
                            break;
                    }
                }
                EndTextCommandScaleformString_2();
                EndScaleformMovieMethod();
            }
        }
        public virtual void SetColumnScroll(string caption, string rightC)
        {
            if (visible)
            {
                BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_COLUMN_SCROLL");
                ScaleformMovieMethodAddParamInt((int)position);
                ScaleformMovieMethodAddParamInt(0);
                ScaleformMovieMethodAddParamInt(0);
                ScaleformMovieMethodAddParamInt(0);
                BeginTextCommandScaleformString("CELL_EMAIL_BCON");
                AddTextComponentSubstringPlayerName(caption);
                EndTextCommandScaleformString_2();
                ScaleformMovieMethodAddParamBool(false);
                ScaleformMovieMethodAddParamPlayerNameString(rightC);
                EndScaleformMovieMethod();
            }
        }
    }
}
