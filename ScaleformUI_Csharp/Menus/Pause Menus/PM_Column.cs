using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.PauseMenu;
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

    public delegate void ItemSelect(TabView menu, TabLeftItem item, int leftItemIndex);
    public delegate void RightItemSelect(TabView menu, SettingsItem item, int leftItemIndex, int rightItemIndex);

    public class PM_Column
    {
        internal PM_COLUMNS position;
        private int index = 0;

        internal List<PauseMenuItem> Items { get; set; }
        public int Index { 
            get => index;
            internal set
            {
                index = value;
                if(index < 0)
                    index = Items.Count - 1;
                if(index >= Items.Count)
                    index = 0;
                //TODO: ADD INDEX CHANGE EVENT HERE
            } 
        }
        public int VisibleItems { get; internal set; }
        public string CaptionLeft { get; internal set; } = string.Empty;
        public string CaptionRight { get; internal set; } = string.Empty;
        public string Label { get; internal set; }
        public SColor Color { get; internal set; }
        public BaseTab Parent {  get; internal set; }

        public PM_Column(PM_COLUMNS position)
        {
            Items = new List<PauseMenuItem>();
            this.position = position;
        }

        public PM_Column(int position) : this((PM_COLUMNS)position) { }

        public void AddItem(PauseMenuItem item)
        {
            Items.Add(item);
        }

        public virtual void SetDataSlot(int index) { }

        public virtual void UpdateSlot(int index) { }

        public virtual void AddSlot(int index) { }

        public virtual void GoUp() { }
        public virtual void GoDown() { }
        public virtual void GoLeft() { }
        public virtual void GoRight() { }
        public virtual void Select() { }
        public virtual void GoBack() { }
        public virtual void Selected() { }
        public virtual void MouseScroll(int dir)
        {
            //Parent._pause._pause.CallFunction("DELTA_MOUSE_WHEEL", dir);
        }
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
    }
}
