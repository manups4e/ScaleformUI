using ScaleformUI.Elements;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenus.Elements;
using ScaleformUI.PauseMenus.Elements.Columns;
using System.Linq;
using System.Reflection.Emit;
using static CitizenFX.Core.UI.Screen;

namespace ScaleformUI.PauseMenu
{
    public class SubmenuTab : BaseTab
    {
        internal LeftItemType currentItemType => ((SubmenuLeftColumn)LeftColumn).currentItemType;

        public SubmenuTab(string name, SColor color) : base(name, color)
        {
            _type = 1;
            _identifier = "Page_Info";
            LeftColumn = new SubmenuLeftColumn(0) { Parent = this };
            CenterColumn = new SubmenuCentralColumn(1) { Parent = this };
        }
        public void SwitchColumn(int index)
        {
            SwitchColumn((PM_COLUMNS)index);
        }

        public void SwitchColumn(PM_COLUMNS index)
        {
            switchColumnInternal(index, true);
        }

        private void switchColumnInternal(PM_COLUMNS index, bool apply)
        {
            var col = GetColumnAtPosition(index);
            CurrentColumnIndex = (int)index;
            if (Parent != null && Parent.Visible)
            {
                Main.PauseMenu._pause.CallFunction("SET_MENU_LEVEL", CurrentColumnIndex + 1);
                Main.PauseMenu._pause.CallFunction("MENU_SHIFT_DEPTH", 0, true, true);
                Parent.focusLevel = CurrentColumnIndex + 1;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)col.position, col.Index, true, true);
                col.Items[col.Index].Selected = true;
            }
        }
        public void AddLeftItem(TabLeftItem item)
        {
            item.ParentTab = this;
            LeftColumn.AddItem(item);
        }

        public override void StateChange(int state)
        {
            Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
            ((SubmenuCentralColumn)CenterColumn).Items.Clear();
            if(state != 0)
                ((SubmenuCentralColumn)CenterColumn).Items.AddRange(((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).ItemList);
            ((SubmenuCentralColumn)CenterColumn).Items.ForEach(x => x.ParentColumn = ((SubmenuCentralColumn)CenterColumn));
            switch (currentItemType)
            {
                case LeftItemType.Statistics:
                    ((SubmenuCentralColumn)CenterColumn).VisibleItems = 16;
                    ((SubmenuCentralColumn)CenterColumn).InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
                    ((SubmenuCentralColumn)CenterColumn).SetColumnScroll(-1, -1, -1, string.Empty, ((SubmenuCentralColumn)CenterColumn).Items.Count < ((SubmenuCentralColumn)CenterColumn).VisibleItems);
                    break;
                case LeftItemType.Settings:
                    ((SubmenuCentralColumn)CenterColumn).VisibleItems = 16;
                    ((SubmenuCentralColumn)CenterColumn).InitColumnScroll(true, 2, ScrollType.ALL, ScrollArrowsPosition.RIGHT);
                    ((SubmenuCentralColumn)CenterColumn).SetColumnScroll(((SubmenuCentralColumn)CenterColumn).Index + 1, ((SubmenuCentralColumn)CenterColumn).Items.Count, ((SubmenuCentralColumn)CenterColumn).VisibleItems, string.Empty, ((SubmenuCentralColumn)CenterColumn).Items.Count < ((SubmenuCentralColumn)CenterColumn).VisibleItems);
                    break;
                case LeftItemType.Info:
                    ((SubmenuCentralColumn)CenterColumn).VisibleItems = 10;
                    ((SubmenuCentralColumn)CenterColumn).InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
                    ((SubmenuCentralColumn)CenterColumn).SetColumnScroll(-1, -1, -1, string.Empty, ((SubmenuCentralColumn)CenterColumn).Items.Count < ((SubmenuCentralColumn)CenterColumn).VisibleItems);
                    break;
                case LeftItemType.Keymap:
                    ((SubmenuCentralColumn)CenterColumn).VisibleItems = 15;
                    ((SubmenuCentralColumn)CenterColumn).InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER);
                    ((SubmenuCentralColumn)CenterColumn).SetColumnScroll(-1, -1, -1, string.Empty, ((SubmenuCentralColumn)CenterColumn).Items.Count < ((SubmenuCentralColumn)CenterColumn).VisibleItems);
                    break;
                default:
                    ((SubmenuCentralColumn)CenterColumn).VisibleItems = 0;
                    break;
            }
        }

        public override void GoUp()
        {
            if (!Focused) return;
            switch (CurrentColumnIndex)
            {
                case 0:
                    LeftColumn.GoUp();
                    ((SubmenuCentralColumn)CenterColumn).currentColumnType = currentItemType;
                    StateChange((int)currentItemType);
                    Refresh(false);
                    Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 8);
                    break;
                case 1:
                    ((SubmenuCentralColumn)CenterColumn).GoUp();
                    if(((SubmenuCentralColumn)CenterColumn).currentColumnType == LeftItemType.Settings)
                        ((SubmenuCentralColumn)CenterColumn).SetColumnScroll(((SubmenuCentralColumn)CenterColumn).Index + 1, ((SubmenuCentralColumn)CenterColumn).Items.Count, ((SubmenuCentralColumn)CenterColumn).VisibleItems, string.Empty, ((SubmenuCentralColumn)CenterColumn).Items.Count < ((SubmenuCentralColumn)CenterColumn).VisibleItems);
                    break;
            }
        }

        public override void GoDown()
        {
            if (!Focused) return;
            switch (CurrentColumnIndex)
            {
                case 0:
                    LeftColumn.GoDown();
                    ((SubmenuCentralColumn)CenterColumn).currentColumnType = currentItemType;
                    StateChange((int)currentItemType);
                    Refresh(false);
                    Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 9);
                    break;
                case 1:
                    ((SubmenuCentralColumn)CenterColumn).GoDown();
                    if (((SubmenuCentralColumn)CenterColumn).currentColumnType == LeftItemType.Settings)
                        ((SubmenuCentralColumn)CenterColumn).SetColumnScroll(((SubmenuCentralColumn)CenterColumn).Index + 1, ((SubmenuCentralColumn)CenterColumn).Items.Count, ((SubmenuCentralColumn)CenterColumn).VisibleItems, string.Empty, ((SubmenuCentralColumn)CenterColumn).Items.Count < ((SubmenuCentralColumn)CenterColumn).VisibleItems);
                    break;
            }
        }

        public override async void MouseEvent(int eventType, int context, int index)
        {
            if (!Focused) return;
            switch (eventType)
            {
                case 5:
                    if (CurrentColumnIndex == context)
                    {
                        if (CurrentColumn.Index != index)
                        {
                            switch (CurrentColumnIndex)
                            {
                                case 0:
                                    LeftColumn.Items[LeftColumn.Index].Selected = false;
                                    LeftColumn.Index = index;
                                    LeftColumn.Items[LeftColumn.Index].Selected = true;
                                    StateChange((int)currentItemType);
                                    Refresh(false);
                                    break;
                                case 1:
                                    ((SubmenuCentralColumn)CenterColumn).Items[((SubmenuCentralColumn)CenterColumn).Index].Selected = false;
                                    ((SubmenuCentralColumn)CenterColumn).Index = index;
                                    ((SubmenuCentralColumn)CenterColumn).Items[((SubmenuCentralColumn)CenterColumn).Index].Selected = true;
                                    break;
                            }
                            return;
                        }
                        switch (CurrentColumnIndex)
                        {
                            case 0 when currentItemType == LeftItemType.Settings:
                                TabLeftItem leftItem = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
                                if (!leftItem.Enabled)
                                {
                                    Game.PlaySound(TabView.AUDIO_ERROR, TabView.AUDIO_LIBRARY);
                                    return;
                                }
                                CurrentColumnIndex++;
                                if (leftItem.ItemList.All(x => !(x as SettingsItem).Enabled)) break;
                                while (!(((SubmenuCentralColumn)CenterColumn).Items[((SubmenuCentralColumn)CenterColumn).Index] as SettingsItem).Enabled)
                                {
                                    await BaseScript.Delay(0);
                                    ((SubmenuCentralColumn)CenterColumn).Index++;
                                }
                                Parent.FocusLevel++;
                                Parent.SendColumnItemSelect(LeftColumn);
                                break;
                            case 1:
                                ((SubmenuCentralColumn)CenterColumn).Select();
                                Parent.SendColumnItemSelect(((SubmenuCentralColumn)CenterColumn));
                                break;
                        }
                    }
                    else
                    {
                        if (context > CurrentColumnIndex)
                        {
                            Parent.FocusLevel++;
                            CurrentColumnIndex++;
                        }
                        else if (context < CurrentColumnIndex)
                        {
                            Parent.FocusLevel--;
                            CurrentColumnIndex--;
                        }
                        switch (CurrentColumnIndex)
                        {
                            case 0:
                                LeftColumn.Items[LeftColumn.Index].Selected = false;
                                LeftColumn.Index = index;
                                LeftColumn.Items[LeftColumn.Index].Selected = true;
                                StateChange((int)currentItemType);
                                Refresh(false);
                                break;
                            case 1:
                                ((SubmenuCentralColumn)CenterColumn).Items[((SubmenuCentralColumn)CenterColumn).Index].Selected = false;
                                ((SubmenuCentralColumn)CenterColumn).Index = index;
                                ((SubmenuCentralColumn)CenterColumn).Items[((SubmenuCentralColumn)CenterColumn).Index].Selected = true;
                                break;
                        }
                    }
                    break;
                case 10: // mouse wheel up
                case 11: // mouse wheel down
                    MouseScroll(eventType == 10 ? -1 : 1);
                    break;
            }
        }

        public void MouseScroll(int dir)
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
                            Game.PlaySound(TabView.AUDIO_UPDOWN, TabView.AUDIO_LIBRARY);
                            return;
                        }
                    }
                    if (dir == -1)
                        LeftColumn.GoUp();
                    else
                        LeftColumn.GoDown();
                    ((SubmenuCentralColumn)CenterColumn).currentColumnType = currentItemType;
                    StateChange((int)currentItemType);
                    Refresh(false);
                    break;
                case 1:
                    if (currentItemType == LeftItemType.Settings)
                    {
                        if (dir == -1)
                            ((SubmenuCentralColumn)CenterColumn).GoUp();
                        else
                            ((SubmenuCentralColumn)CenterColumn).GoDown();
                    }
                    if (((SubmenuCentralColumn)CenterColumn).currentColumnType == LeftItemType.Settings)
                        ((SubmenuCentralColumn)CenterColumn).SetColumnScroll(((SubmenuCentralColumn)CenterColumn).Index + 1, ((SubmenuCentralColumn)CenterColumn).Items.Count, ((SubmenuCentralColumn)CenterColumn).VisibleItems, string.Empty, ((SubmenuCentralColumn)CenterColumn).Items.Count < ((SubmenuCentralColumn)CenterColumn).VisibleItems);
                    Game.PlaySound(TabView.AUDIO_UPDOWN, TabView.AUDIO_LIBRARY);
                    break;
            }
        }

        public override void GoLeft()
        {
            if(!Focused) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 10);

            if (CurrentColumnIndex == 1)
            {
                ((SubmenuCentralColumn)CenterColumn).GoLeft();
            }
        }

        public override void GoRight()
        {
            if (!Focused) return;
            Parent._pause._pause.CallFunction("SET_COLUMN_INPUT_EVENT", CurrentColumnIndex, 11);
            if (CurrentColumnIndex == 1)
            {
                ((SubmenuCentralColumn)CenterColumn).GoRight();
            }
        }

        public override async void Select()
        {
            if (!Focused) return;
            switch (CurrentColumnIndex)
            {
                case 0:
                    if (currentItemType != LeftItemType.Settings) return;
                    TabLeftItem leftItem = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
                    if (!leftItem.Enabled)
                    {
                        Game.PlaySound(TabView.AUDIO_ERROR, TabView.AUDIO_LIBRARY);
                        return;
                    }
                    CurrentColumnIndex++;
                    if (leftItem.ItemList.All(x => !(x as SettingsItem).Enabled)) break;
                    while (!(((SubmenuCentralColumn)CenterColumn).Items[((SubmenuCentralColumn)CenterColumn).Index] as SettingsItem).Enabled)
                    {
                        await BaseScript.Delay(0);
                        ((SubmenuCentralColumn)CenterColumn).Index++;
                    }
                    Parent.FocusLevel++;
                    Parent.SendColumnItemSelect(LeftColumn);
                    break;
                case 1:
                    ((SubmenuCentralColumn)CenterColumn).Select();
                    Parent.SendColumnItemSelect(((SubmenuCentralColumn)CenterColumn));
                    break;
            }
        }

        public override void GoBack()
        {
            if (!Focused) return;
            if (CurrentColumnIndex == 1)
            {
                CurrentColumnIndex--;
                Parent.FocusLevel--;
            }
        }

        public override void Focus()
        {
            base.Focus();
            LeftColumn.Index = LeftColumn.index;
            LeftColumn.HighlightColumn(true, false, true);
            LeftColumn.Items[LeftColumn.Index].Selected = true;
            Refresh(true);
        }

        public override void UnFocus()
        {
            base.UnFocus();
            LeftColumn.Items[LeftColumn.Index].Selected = false;
        }

        public override void Refresh(bool highlightOldIndex)
        {
            Parent._pause._pause.CallFunction("ALLOW_CLICK_FROM_COLUMN", 0, true);
            Parent._pause._pause.CallFunction("SET_DATA_SLOT_EMPTY", 1);
            for (int i = 0; i < ((SubmenuCentralColumn)CenterColumn).Items.Count; i++)
            {
                SetDataSlot(((SubmenuCentralColumn)CenterColumn).position, i);
            }
            switch (currentItemType)
            {
                case LeftItemType.Keymap:
                    Parent._pause._pause.CallFunction("SET_COLUMN_TITLE", 1, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).RightTitle, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).KeymapRightLabel_1, ((TabLeftItem)LeftColumn.Items[LeftColumn.Index]).KeymapRightLabel_2);
                    Parent._pause._pause.CallFunction("SET_COLUMN_FOCUS", 1, false, false, false);
                    break;
                case LeftItemType.Settings:
                    if (highlightOldIndex)
                        Parent._pause._pause.CallFunction("SET_COLUMN_HIGHLIGHT", 1, ((SubmenuCentralColumn)CenterColumn).Index, true, true);
                        //Parent._pause._pause.CallFunction("SET_COLUMN_STATE", 3);
                        ////Parent._pause._pause.CallFunction("SET_CONTROL_IMAGE", "pause_menu_pages_settings_pc", "controller");
                        ////Parent._pause._pause.CallFunction("SET_CONTROL_LABELS", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "SUPER TITLE");

                        ////Parent._pause._pause.CallFunction("SET_VIDEO_MEMORY_BAR", true, "ScaleformUI Pause Menu Awesomeness", 70, 116);
                        //Parent._pause._pause.CallFunction("SET_DESCRIPTION", 1, "~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "scaleformui", "pauseinfobg", 0, 0, 578, 160);
                        break;
            }
            ((SubmenuCentralColumn)CenterColumn).ShowColumn();
        }

        public override void Populate()
        {
            TabLeftItem item = (TabLeftItem)LeftColumn.Items[LeftColumn.Index];
            item.Selected = true;
            ((SubmenuCentralColumn)CenterColumn).Items.Clear();
            if (currentItemType != LeftItemType.Empty)
            {
                ((SubmenuCentralColumn)CenterColumn).Items.AddRange(item.ItemList);
                ((SubmenuCentralColumn)CenterColumn).Items.ForEach(x => x.ParentColumn = ((SubmenuCentralColumn)CenterColumn));
            }
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 1);
            Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 0);
            for (int i = 0; i < LeftColumn.Items.Count; i++)
            {
                SetDataSlot(LeftColumn.position, i);
            }
            for (int i = 0; i < ((SubmenuCentralColumn)CenterColumn).Items.Count; i++)
            {
                SetDataSlot(((SubmenuCentralColumn)CenterColumn).position, i);
            }
        }

        public override void ShowColumns()
        {
            //Parent._pause._pause.CallFunction("MOUSE_COLUMN_SHIFT", 0);
            //Parent._pause._pause.CallFunction("SET_COLUMN_HIGHLIGHT", 0, 0, false, false);
            LeftColumn.ShowColumn();
            ((SubmenuCentralColumn)CenterColumn).ShowColumn();
            if (currentItemType == LeftItemType.Settings)
            {
                Parent._pause._pause.CallFunction("SET_COLUMN_STATE", 0);
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
                    ((SubmenuCentralColumn)CenterColumn).SetDataSlot(index);
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
                    ((SubmenuCentralColumn)CenterColumn).UpdateSlot(index);
                    break;
            }
        }
    }
}