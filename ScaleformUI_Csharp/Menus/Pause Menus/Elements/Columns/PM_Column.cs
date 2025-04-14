using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
        public int Index
        {
            get => index;
            set
            {
                index = value;
                if (index < 0)
                    index = Items.Count - 1;
                else if (index >= Items.Count)
                    index = 0;

                if (visible)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, false, false);
                //TODO: ADD INDEX CHANGE EVENT HERE
            }
        }

        public bool ColumnVisible
        {
            get => columnVisible;
            set
            {
                columnVisible = value;
                Debug.WriteLine("SHOW_COLUMN " + (int)position + " " + columnVisible);
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

        public virtual void Populate() { }

        public virtual void SetDataSlot(int index) { }

        public virtual void UpdateSlot(int index) { }

        public virtual void AddSlot(int index) { }

        public virtual void GoUp() { }
        public virtual void GoDown() { }
        public virtual void GoLeft() { }
        public virtual void GoRight() { }
        public virtual void Select() { }
        public virtual void GoBack() { }
        public virtual void MouseScroll(int dir) { }

        public virtual void HighlightColumn(bool highlighted = false, bool moveFocus = false, bool prevHighlight = false)
        {
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, highlighted, moveFocus, prevHighlight);
        }
        public virtual void ClearColumn()
        {
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
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_SCROLL", (int)position, currentPosition, maxPosition, maxVisible);
        }

        public virtual void SetColumnScroll(string caption, params object[] args)
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
}
