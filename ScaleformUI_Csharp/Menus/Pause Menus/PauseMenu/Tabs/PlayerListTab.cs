using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenus.Elements;
using ScaleformUI.PauseMenus.Elements.Columns;
using ScaleformUI.PauseMenus.Elements.Panels;

namespace ScaleformUI.PauseMenu
{
    public enum PLT_COLUMNS
    {
        SETTINGS,
        PLAYERS,
        MISSIONS,
        STORE,
        MISSION_DETAILS,
    }

    public delegate void ColumnFocusedEvent(PM_Column column, int index);
    public class PlayerListTab : BaseTab
    {
        public event ColumnFocusedEvent OnFocusChanged;
        public bool ForceFirstSelectionOnFocus { get; set; }
        private int[] order = new int[3];
        public PlayerListTab(string name, SColor color) : base(name, color)
        {
            _type = 2;
            _identifier = "Page_Multi";
            Minimap = new MinimapPanel(this) { HidePedBlip = true };
        }

        public void SetupLeftColumn(PM_Column column)
        {
            column.position = PM_COLUMNS.LEFT;
            LeftColumn = column;
            LeftColumn.Parent = this;
            order[0] = column.type;
        }
        public void SetupCenterColumn(PM_Column column)
        {
            column.position = PM_COLUMNS.MIDDLE;
            CenterColumn = column;
            CenterColumn.Parent = this;
            order[1] = column.type;
        }
        public void SetupRightColumn(PM_Column column)
        {
            column.position = PM_COLUMNS.RIGHT;
            RightColumn = column;
            RightColumn.Parent = this;
            order[2] = column.type;
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
            if (index > PM_COLUMNS.RIGHT) return;
            // for now we won't allow selecting the mission details column
            if (order[(int)index] == (int)PLT_COLUMNS.MISSION_DETAILS)
                return;
            var col = GetColumnAtPosition(index);
            CurrentColumnIndex = (int)index;
            if (Parent != null && Parent.Visible)
            {
                if (col is PlayerListColumn plc)
                {
                    if (plc.CurrentItem.Panel != null)
                    {
                        var _col = GetColumnAtPosition(2);
                        _col.ColumnVisible = false;
                    }
                }
                else
                {
                    var befcol = GetColumnAtPosition(index - 1);
                    var afterCol = GetColumnAtPosition(index + 1);
                    if (befcol is PlayerListColumn _plc)
                        _plc.CurrentItem.Dispose();
                    if (afterCol is PlayerListColumn _plc2)
                        _plc2.CurrentItem.Dispose();
                    var _col = GetColumnAtPosition(2);
                    _col.ColumnVisible = true;
                }
                Main.PauseMenu._pause.CallFunction("SET_MENU_LEVEL", CurrentColumnIndex + 1);
                Main.PauseMenu._pause.CallFunction("MENU_SHIFT_DEPTH", 0, true, true);
                Parent.focusLevel = CurrentColumnIndex + 1;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)col.position, col.Index, true, true);
                col.Items[col.Index].Selected = true;
            }
        }

        public override void StateChange(int state)
        {
            Main.PauseMenu._pause.CallFunction("MENU_STATE", string.Join("", order));
        }

        public override void GoUp()
        {
            if (!Focused) return;
            var col = GetColumnAtPosition(CurrentColumnIndex);
            col.GoUp();
            col.SetColumnScroll(col.Index + 1, col.Items.Count, col.VisibleItems, string.Empty, col.Items.Count < col.VisibleItems);
        }

        public override void GoDown()
        {
            if (!Focused) return;
            var col = GetColumnAtPosition(CurrentColumnIndex);
            col.GoDown();
            col.SetColumnScroll(col.Index + 1, col.Items.Count, col.VisibleItems, string.Empty, col.Items.Count < col.VisibleItems);
        }

        public override void MouseEvent(int eventType, int context, int index)
        {
            if (!Focused) return;
            switch (eventType)
            {
                case 5: // mouse click
                    {
                        if (context > 999)
                        {
                            var columnIndex = context - 1000;
                            var col = GetColumnAtPosition(columnIndex);
                            switch (index)
                            {
                                case 0:
                                    col.GoLeft();
                                    break;
                                case 1:
                                    col.GoRight();
                                    break;
                                case 2:
                                    col.GoUp();
                                    break;
                                case 3:
                                    col.GoDown();
                                    break;
                            }
                            return;
                        }

                        var currentCol = GetColumnAtPosition(CurrentColumnIndex);


                        if (CurrentColumnIndex == context)
                        {
                            if (index == currentCol.Index)
                            {
                                currentCol.Select();
                                return;
                            }
                            switch (currentCol)
                            {
                                case SettingsListColumn set:
                                    set.CurrentItem.Selected = false;
                                    set.CurrentSelection = index;
                                    set.CurrentItem.Selected = true;
                                    AddTextEntry("PAUSEMENU_Current_Description", set.CurrentItem.Description);
                                    break;
                                case PlayerListColumn play:
                                    ClearPedInPauseMenu();
                                    play.CurrentItem.Selected = false;
                                    play.CurrentSelection = index;
                                    play.CurrentItem.Selected = true;
                                    play.CurrentItem.CreateClonedPed();
                                    break;
                                case MissionsListColumn miss:
                                    miss.CurrentItem.Selected = false;
                                    miss.CurrentSelection = index;
                                    miss.CurrentItem.Selected = true;
                                    break;
                                case StoreListColumn store:
                                    store.CurrentItem.Selected = false;
                                    store.CurrentSelection = index;
                                    store.CurrentItem.Selected = true;
                                    break;
                            }
                        }
                        else
                        {
                            var selectedCol = GetColumnAtPosition(context);
                            switchColumnInternal((PM_COLUMNS)context, false);
                            switch (selectedCol)
                            {
                                case SettingsListColumn set:
                                    set.CurrentItem.Selected = false;
                                    set.CurrentSelection = index;
                                    set.CurrentItem.Selected = true;
                                    AddTextEntry("PAUSEMENU_Current_Description", set.CurrentItem.Description);
                                    break;
                                case PlayerListColumn play:
                                    ClearPedInPauseMenu();
                                    play.CurrentItem.Selected = false;
                                    play.CurrentSelection = index;
                                    play.CurrentItem.Selected = true;
                                    play.CurrentItem.CreateClonedPed();
                                    break;
                                case MissionsListColumn miss:
                                    miss.CurrentItem.Selected = false;
                                    miss.CurrentSelection = index;
                                    miss.CurrentItem.Selected = true;
                                    break;
                                case StoreListColumn store:
                                    store.CurrentItem.Selected = false;
                                    store.CurrentSelection = index;
                                    store.CurrentItem.Selected = true;
                                    break;
                            }
                        }
                    }
                    break;
                case 8: // not hover
                    break;
                case 9: // mouse hover
                    break;
                case 10: // mouse wheel up
                case 11: // mouse wheel down
                    {
                        var currentCol = GetColumnAtPosition(CurrentColumnIndex);
                        currentCol.MouseScroll(eventType == 10 ? -1 : 1);
                    }
                    break;
            }
        }

        public override void GoLeft()
        {
            if (!Focused) return;
            var col = GetColumnAtPosition(CurrentColumnIndex);
            col.GoLeft();
        }

        public override void GoRight()
        {
            if (!Focused) return;
            var col = GetColumnAtPosition(CurrentColumnIndex);
            col.GoRight();
        }
        public override void Select()
        {
            if (!Focused) return;
            var col = GetColumnAtPosition(CurrentColumnIndex);
            col.Select();
        }

        public override void GoBack()
        {
            if (!Focused) return;
            if (CurrentColumnIndex > 0)
            {
                var col = GetColumnAtPosition(CurrentColumnIndex);
                col.Items[col.Index].Selected = false;
                CurrentColumnIndex--;
                col = GetColumnAtPosition(CurrentColumnIndex);
                col.Items[col.Index].Selected = true;
                if (col is PlayerListColumn plc)
                {
                    if (plc.CurrentItem.Panel != null)
                    {
                        plc.CurrentItem.CreateClonedPed();
                        var _col = GetColumnAtPosition(2);
                        _col.ColumnVisible = false;
                    }
                }
                else
                {
                    var _col = GetColumnAtPosition(2);
                    _col.ColumnVisible = true;
                }
                Parent.FocusLevel--;
            }
        }

        public override void Refresh(bool highlightOldIndex)
        {
        }

        public override void Populate()
        {
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 1);
            StateChange(0);
            Parent._pause._pause.CallFunction("SET_MENU_LEVEL", 0);
            LeftColumn?.Populate();
            CenterColumn?.Populate();
            RightColumn?.Populate();
        }

        public override void ShowColumns()
        {
            LeftColumn?.ShowColumn();
            CenterColumn?.ShowColumn();
            RightColumn?.ShowColumn();
        }

        public override void SetDataSlot(PM_COLUMNS slot, int index)
        {
        }

        public override void UpdateSlot(PM_COLUMNS slot, int index)
        {
        }

        public override void Focus()
        {
            base.Focus();
            var col = GetColumnAtPosition(CurrentColumnIndex);
            switch (col)
            {
                case SettingsListColumn set:
                    set.Focused = true;
                    set.CurrentItem.Selected = true;
                    AddTextEntry("PAUSEMENU_Current_Description", set.CurrentItem.Description);
                    break;
                case PlayerListColumn play:
                    ClearPedInPauseMenu();
                    play.Focused = true;
                    play.CurrentItem.Selected = true;
                    play.CurrentItem.CreateClonedPed();
                    break;
                case MissionsListColumn miss:
                    miss.Focused = true;
                    miss.CurrentItem.Selected = true;
                    break;
                case StoreListColumn store:
                    store.Focused = true;
                    store.CurrentItem.Selected = true;
                    break;
            }
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)col.position, col.Index, true, false);
        }

        public override void UnFocus()
        {
            base.UnFocus();
            if (LeftColumn is SettingsListColumn set)
            {
                set.Focused = false;
                set.CurrentItem.Selected = false;
            }
            API.AddTextEntry("PAUSEMENU_Current_Description", "");
        }
    }
}