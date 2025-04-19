using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;

namespace ScaleformUI.PauseMenus.Elements.Columns
{
    public delegate void MissionItemSelected(MissionItem item, int index);
    public class MissionsListColumn : PM_Column
    {
        public event IndexChanged OnIndexChanged;
        private List<PauseMenuItem> _unfilteredItems;
        private int _unfilteredSelection = 0;
        public event MissionItemSelected OnMissionItemActivated;
        public MissionsListColumn(string label, int maxItems = 16) : base(-1)
        {
            Label = label;
            VisibleItems = maxItems;
            type = (int)PLT_COLUMNS.MISSIONS;
        }

        public void SetVisibleItems(int maxItems)
        {
            VisibleItems = maxItems;
            if (visible)
            {
                Populate();
                ShowColumn();
            }
        }

        public override void AddItem(PauseMenuItem item)
        {
            AddMissionItem((MissionItem)item);
        }
        public void AddMissionItem(MissionItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            if (visible && Items.Count <= VisibleItems)
            {
                var idx = Items.Count - 1;
                AddSlot(idx);
                item.Selected = idx == index;
            }
        }

        public override void SetDataSlot(int index)
        {
            this.SendItemToScaleform(index);
        }

        public override void UpdateSlot(int index)
        {
            if (index >= Items.Count) return;
            if (visible)
                SendItemToScaleform(index, true);
        }

        public override void AddSlot(int index)
        {
            if (index >= Items.Count) return;
            if (visible)
                SendItemToScaleform(index, false, false, true);
        }

        public void AddItemAt(MissionItem item, int idx)
        {
            if (idx >= Items.Count) return;
            Items.Insert(idx, item);
            if (visible)
            {
                SendItemToScaleform(idx, false, true, false);
                item.Selected = idx == index;
            }
        }

        public override void Populate()
        {
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_MAX_ITEMS", (int)position, VisibleItems);
            for (var i = 0; i < Items.Count; i++)
            {
                SetDataSlot(i);
            }
        }


        internal void SendItemToScaleform(int i, bool update = false, bool newItem = false, bool isSlot = false)
        {
            if (i >= Items.Count) return;
            MissionItem item = (MissionItem)Items[i];
            string str = "SET_DATA_SLOT";
            if (update)
                str = "UPDATE_SLOT";
            if (newItem)
                str = "SET_DATA_SLOT_SPLICE";
            if (isSlot)
                str = "ADD_SLOT";
            Main.PauseMenu._pause.CallFunction(str, (int)position, i, 0, i, item.type, 0, item.Enabled, item.Label, item.MainColor, item.HighlightColor, (int)item.LeftIcon, (int)item.RightIcon, item.LeftIconColor, item.RightIconColor, item.customLeftBadge.Key, item.customLeftBadge.Value, item.customRightBadge.Key, item.customRightBadge.Value, item.RightIconChecked, item.Jumpable);
        }

        public override void ShowColumn(bool show = true)
        {
            base.ShowColumn(show);
            InitColumnScroll(Items.Count >= VisibleItems, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT);
            SetColumnScroll(Index + 1, Items.Count, VisibleItems, CaptionLeft, Items.Count < VisibleItems);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, Focused, false, false);
            if(Items.Count >= 0 && CurrentItem is MissionSeparatorItem it && it.Jumpable)
            {
                CurrentItem.Selected = false;
                index++;
                if (index >= Items.Count)
                    index = 0;
                CurrentItem.Selected = true;
            }
        }

        public override async void GoUp()
        {
            try
            {
                CurrentItem.Selected = false;
                do
                {
                    index--;
                    if (index < 0)
                        index = Items.Count - 1;
                    await BaseScript.Delay(0);
                }
                while (CurrentItem is MissionSeparatorItem sp && sp.Jumpable);
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 8);
                SetColumnScroll(Index + 1, Items.Count, VisibleItems, CaptionLeft, Items.Count < VisibleItems);
                CurrentItem.Selected = true;
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        public override async void GoDown()
        {
            try
            {
                CurrentItem.Selected = false;
                do
                {
                    index++;
                    if (index >= Items.Count)
                        index = 0;
                    await BaseScript.Delay(0);
                }
                while (CurrentItem is MissionSeparatorItem sp && sp.Jumpable);
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 9);
                SetColumnScroll(Index + 1, Items.Count, VisibleItems, CaptionLeft, Items.Count < VisibleItems);
                CurrentItem.Selected = true;
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        public override void Select()
        {
            SelectItem();
        }
        public override void GoBack()
        {
            Focused = false;
        }

        public async override void MouseScroll(int dir)
        {
            CurrentItem.Selected = false;
            do
            {
                index += dir;
                if (index < 0)
                    index = Items.Count - 1;
                if (index >= Items.Count)
                    index = 0;
                await BaseScript.Delay(0);
            }
            while (CurrentItem is MissionSeparatorItem sp && sp.Jumpable);
            CurrentItem.Selected = true;
            IndexChangedEvent();
        }
        public MissionItem CurrentItem => (MissionItem)Items[Index];
        public int CurrentSelection
        {
            get => index;
            set
            {
                CurrentItem.Selected = false;
                index = value;
                if (index < 0)
                    index = Items.Count - 1;
                else if (index >= Items.Count)
                    index = 0;
                CurrentItem.Selected = true;

                if (visible)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
                IndexChangedEvent();
            }
        }

        public void RemoveItem(int id)
        {
            Items.RemoveAt(id);
            if (visible)
            {
                //add remove item function here
            }
        }

        public void SortMissions(Comparison<MissionItem> compare)
        {
            try
            {
                CurrentItem.Selected = false;
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                Clear();
                List<MissionItem> list = _unfilteredItems.Cast<MissionItem>().ToList();
                list.Sort(compare);
                Items = list.Cast<PauseMenuItem>().ToList();
                if (visible)
                {
                    Populate();
                    ShowColumn();
                }
            }
            catch (Exception ex)
            {
                ResetFilter();
                Debug.WriteLine("ScaleformUI - " + ex.ToString());
            }
        }

        public void FilterMissions(Func<MissionItem, bool> predicate)
        {
            if (predicate == null)
                throw new ArgumentNullException(nameof(predicate));
            try
            {
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                //_unfilteredTopEdge = topEdge;

                var filteredItems = Items.Cast<MissionItem>().Where(predicate).ToList();

                if (!filteredItems.Any())
                {
                    Debug.WriteLine("^1ScaleformUI - No items were found, resetting the filter");
                    _unfilteredItems.Clear();
                    _unfilteredSelection = 0;
                    return;
                }

                Items[CurrentSelection].Selected = false;
                Clear();

                Items = filteredItems.Cast<PauseMenuItem>().ToList();
                CurrentSelection = 0;

                if (visible)
                {
                    Populate();
                    ShowColumn();
                }
            }
            catch (Exception ex)
            {
                ResetFilter();
                Debug.WriteLine($"^1ScaleformUI - Error filtering menu items: {ex}");
                throw;
            }
        }

        public void ResetFilter()
        {
            try
            {
                if (_unfilteredItems != null && _unfilteredItems.Count > 0)
                {
                    CurrentItem.Selected = false;
                    Clear();
                    Items = _unfilteredItems.ToList();
                    CurrentSelection = _unfilteredSelection;
                    if (visible)
                    {
                        Populate();
                        ShowColumn();
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("ScaleformUI - " + ex.ToString());
            }
        }

        public void SelectItem()
        {
            OnMissionItemActivated?.Invoke(CurrentItem, CurrentSelection);
        }
        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
