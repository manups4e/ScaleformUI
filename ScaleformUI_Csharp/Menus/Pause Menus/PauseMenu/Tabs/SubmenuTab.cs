using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenus.Elements;
using System.Linq;
using System.Reflection.Emit;
using static CitizenFX.Core.UI.Screen;

namespace ScaleformUI.PauseMenu
{
    public class SubmenuTab : BaseTab
    {
        private bool _focused;
        public new SubmenuLefColumn LeftColumn
        {
            get => (SubmenuLefColumn)base.LeftColumn;
            internal set => base.LeftColumn = value;
        }

        public new SubmenuCentralColumn CenterColumn
        {
            get => (SubmenuCentralColumn)base.CenterColumn;
            internal set => base.CenterColumn = value;
        }
        internal LeftItemType currentItemType => LeftColumn.currentItemType;

        public SubmenuTab(string name, SColor color) : base(name, color)
        {
            _type = 1;
            _identifier = "Page_Info";
            LeftColumn = new SubmenuLefColumn(0) { Parent = this };
            CenterColumn = new SubmenuCentralColumn(1) { Parent = this };
        }

        public override bool Focused
        {
            get { return _focused; }
            set
            {
                _focused = value;
                //if (!value) Items[Index].Focused = false;
            }
        }

        public void AddLeftItem(TabLeftItem item)
        {
            item.Parent = this;
            LeftColumn.AddItem(item);
        }

        public override void StateChange(int state)
        {
            Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
            CenterColumn.Items.Clear();
            if(state != 0)
                CenterColumn.Items.AddRange(((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemList);
            switch (currentItemType)
            {
                case LeftItemType.Statistics:
                    CenterColumn.VisibleItems = 16;
                    CenterColumn.InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
                    CenterColumn.SetColumnScroll(-1, -1, -1, string.Empty, CenterColumn.Items.Count < CenterColumn.VisibleItems);
                    break;
                case LeftItemType.Settings:
                    CenterColumn.VisibleItems = 16;
                    CenterColumn.InitColumnScroll(true, 2, ScrollType.ALL, ScrollArrowsPosition.RIGHT);
                    CenterColumn.SetColumnScroll(CenterColumn.Index + 1, CenterColumn.Items.Count, CenterColumn.VisibleItems, string.Empty, CenterColumn.Items.Count < CenterColumn.VisibleItems);
                    break;
                case LeftItemType.Info:
                    CenterColumn.VisibleItems = 10;
                    CenterColumn.InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
                    CenterColumn.SetColumnScroll(-1, -1, -1, string.Empty, CenterColumn.Items.Count < CenterColumn.VisibleItems);
                    break;
                case LeftItemType.Keymap:
                    CenterColumn.VisibleItems = 15;
                    CenterColumn.InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
                    CenterColumn.SetColumnScroll(-1, -1, -1, string.Empty, CenterColumn.Items.Count < CenterColumn.VisibleItems);
                    break;
                default:
                    CenterColumn.VisibleItems = 0;
                    break;
            }
        }

        public override void GoUp()
        {
            if (Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 8);
            switch (CurrentColumnIndex)
            {
                case 0:
                    LeftColumn.GoUp();
                    CenterColumn.currentColumnType = currentItemType;
                    StateChange((int)currentItemType);
                    Refresh(false);
                    break;
                case 1:
                    CenterColumn.GoUp();
                    if(CenterColumn.currentColumnType == LeftItemType.Settings)
                        CenterColumn.SetColumnScroll(CenterColumn.Index + 1, CenterColumn.Items.Count, CenterColumn.VisibleItems, string.Empty, CenterColumn.Items.Count < CenterColumn.VisibleItems);
                    break;
            }
        }

        public override void GoDown()
        {
            if (Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 9);
            switch (CurrentColumnIndex)
            {
                case 0:
                    LeftColumn.GoDown();
                    CenterColumn.currentColumnType = currentItemType;
                    StateChange((int)currentItemType);
                    Refresh(false);
                    break;
                case 1:
                    CenterColumn.GoDown();
                    if (CenterColumn.currentColumnType == LeftItemType.Settings)
                        CenterColumn.SetColumnScroll(CenterColumn.Index + 1, CenterColumn.Items.Count, CenterColumn.VisibleItems, string.Empty, CenterColumn.Items.Count < CenterColumn.VisibleItems);
                    break;
            }
        }

        public override void MouseScroll(int dir)
        {
            int col = Parent.hoveredColumn;
            switch (CurrentColumnIndex)
            {
                case 0:
                    if (col == 1)
                    {
                        if (currentItemType == LeftItemType.Info || currentItemType == LeftItemType.Statistics)
                        {
                            Debug.WriteLine("GET_HOVERED_COLUMN -- Current: " + col);
                            Game.PlaySound(Parent.AUDIO_UPDOWN, Parent.AUDIO_LIBRARY);
                            return;
                        }
                    }
                    if (dir == -1)
                        LeftColumn.GoUp();
                    else
                        LeftColumn.GoDown();
                    CenterColumn.currentColumnType = currentItemType;
                    StateChange((int)currentItemType);
                    Refresh(false);
                    break;
                case 1:
                    if (currentItemType == LeftItemType.Settings)
                    {
                        if (dir == -1)
                            CenterColumn.GoUp();
                        else
                            CenterColumn.GoDown();
                    }
                    if (CenterColumn.currentColumnType == LeftItemType.Settings)
                        CenterColumn.SetColumnScroll(CenterColumn.Index + 1, CenterColumn.Items.Count, CenterColumn.VisibleItems, string.Empty, CenterColumn.Items.Count < CenterColumn.VisibleItems);
                    Game.PlaySound(Parent.AUDIO_UPDOWN, Parent.AUDIO_LIBRARY);
                    break;
            }
        }

        public override void GoLeft()
        {
            if(Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 10);

            if (CurrentColumnIndex == 1)
            {
                CenterColumn.GoLeft();
            }
        }

        public override void GoRight()
        {
            if (Parent.FocusLevel == 0) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 11);
            if (CurrentColumnIndex == 1)
            {
                CenterColumn.GoRight();
            }
        }

        public override async void Select()
        {
            switch (CurrentColumnIndex)
            {
                case 0 when currentItemType == LeftItemType.Settings:
                    TabLeftItem leftItem = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
                    if (!leftItem.Enabled)
                    {
                        Game.PlaySound(Parent.AUDIO_ERROR, Parent.AUDIO_LIBRARY);
                        return;
                    }
                    CurrentColumnIndex++;
                    if (leftItem.ItemList.All(x => !(x as SettingsItem).Enabled)) break;
                    while (!(CenterColumn.Items[CenterColumn.Index] as SettingsItem).Enabled)
                    {
                        await BaseScript.Delay(0);
                        CenterColumn.Index++;
                    }
                    Parent.FocusLevel++;
                    Parent.SendColumnItemSelect(LeftColumn);
                    break;
                case 1:
                    CenterColumn.Select();
                    Parent.SendColumnItemSelect(CenterColumn);
                    break;
            }
        }

        public override void GoBack()
        {
            if (CurrentColumnIndex == 1)
            {
                CurrentColumnIndex--;
                Parent.FocusLevel--;
            }
        }

        public override void Focus()
        {
            LeftColumn.HighlightColumn(true, false, true);
        }

        public override void Refresh(bool highlightOldIndex)
        {
            Parent._pause._pause.CallFunction("ALLOW_CLICK_FROM_COLUMN", 0, true);
            Parent._pause._pause.CallFunction("SET_DATA_SLOT_EMPTY", 1);
            for (int i = 0; i < CenterColumn.Items.Count; i++)
            {
                SetDataSlot(CenterColumn.position, i);
            }
            switch (currentItemType)
            {
                case LeftItemType.Keymap:
                    Parent._pause._pause.CallFunction("SET_COLUMN_TITLE", 1, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).RightTitle, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).KeymapRightLabel_1, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).KeymapRightLabel_2);
                    Parent._pause._pause.CallFunction("SET_COLUMN_FOCUS", 1, false, false, false);
                    break;
                case LeftItemType.Settings:
                    if (highlightOldIndex)
                        Parent._pause._pause.CallFunction("SET_COLUMN_HIGHLIGHT", 1, CenterColumn.Index, true, true);
                        //Parent._pause._pause.CallFunction("SET_COLUMN_STATE", 3);
                        ////Parent._pause._pause.CallFunction("SET_CONTROL_IMAGE", "pause_menu_pages_settings_pc", "controller");
                        ////Parent._pause._pause.CallFunction("SET_CONTROL_LABELS", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "SUPER TITLE");

                        ////Parent._pause._pause.CallFunction("SET_VIDEO_MEMORY_BAR", true, "ScaleformUI Pause Menu Awesomeness", 70, 116);
                        //Parent._pause._pause.CallFunction("SET_DESCRIPTION", 1, "~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "scaleformui", "pauseinfobg", 0, 0, 578, 160);
                        break;
            }
            CenterColumn.ShowColumn();
        }

        public override void Populate()
        {
            TabLeftItem item = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
            item.Selected = true;
            CenterColumn.Items.Clear();
            if (currentItemType != LeftItemType.Empty)
                CenterColumn.Items.AddRange(item.ItemList);
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 1);
            Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 0);
            for (int i = 0; i < LeftColumn.Items.Count; i++)
            {
                SetDataSlot(LeftColumn.position, i);
            }
            for (int i = 0; i < CenterColumn.Items.Count; i++)
            {
                SetDataSlot(CenterColumn.position, i);
            }
        }

        public override void ShowColumns()
        {
            //Parent._pause._pause.CallFunction("MOUSE_COLUMN_SHIFT", 0);
            //Parent._pause._pause.CallFunction("SET_COLUMN_HIGHLIGHT", 0, 0, false, false);
            LeftColumn.ShowColumn();
            CenterColumn.ShowColumn();
            if (currentItemType == LeftItemType.Settings)
            {
                Parent._pause._pause.CallFunction("SET_COLUMN_STATE", 1, 1);
            }
            Parent._pause._pause.CallFunction("SET_COLUMN_FOCUS", 0, false, false, false);
            //to be overridden by subcolumns
            LeftColumn.InitColumnScroll(true, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT);
            LeftColumn.SetColumnScroll(LeftColumn.Index, LeftColumn.Items.Count, 16, "", LeftColumn.Items.Count < 16);
        }

        public override void SetDataSlot(PM_COLUMNS slot, int index)
        {
            switch (slot)
            {
                case PM_COLUMNS.LEFT:
                    LeftColumn.SetDataSlot(index);
                    break;
                case PM_COLUMNS.MIDDLE:
                    CenterColumn.SetDataSlot(index);
                    break;
            }

        }

        public override void UpdateSlot(PM_COLUMNS slot, int index)
        {
            switch (slot)
            {
                case PM_COLUMNS.LEFT:
                    LeftColumn.UpdateSlot(index);
                    break;
                case PM_COLUMNS.MIDDLE:
                    CenterColumn.UpdateSlot(index);
                    break;
            }
        }
    }
}