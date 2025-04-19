using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;

namespace ScaleformUI.PauseMenus.Elements.Columns
{
    public delegate void PlayerItemSelected(LobbyItem item, int index);
    public class PlayerListColumn : PM_Column
    {
        public event IndexChanged OnIndexChanged;
        private List<PauseMenuItem> _unfilteredItems;
        private int _unfilteredSelection = 0;
        public event PlayerItemSelected OnPlayerItemActivated;

        public PlayerListColumn(string label, int maxItems = 16) : base(-1)
        {
            Label = label;
            VisibleItems = maxItems;
            type = (int)PLT_COLUMNS.PLAYERS;
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
            AddPlayer((FriendItem)item);
        }
        public void AddPlayer(FriendItem item)
        {
            item.ParentColumn = this;
            Items.Add(item);
            if (visible)
            {
                var idx = Items.Count - 1;
                SendItemToScaleform(idx, false, false, isSlot: Items.Count <= VisibleItems);
                item.Selected = idx == 0;
            }
        }

        public override void SetDataSlot(int index)
        {
            SendItemToScaleform(index);
        }

        internal void SendItemToScaleform(int i, bool update = false, bool newItem = false, bool isSlot = false)
        {
            if (i >= Items.Count) return;
            FriendItem fi = (FriendItem)Items[i];
            string str = "SET_DATA_SLOT";
            if (update)
                str = "UPDATE_SLOT";
            if (newItem)
                str = "SET_DATA_SLOT_SPLICE";
            if (isSlot)
                str = "ADD_SLOT";
            Main.PauseMenu._pause.CallFunction(str, (int)position, i, 0, i, 2, fi.Rank, true, fi.Label, fi.ItemColor, fi.ColoredTag, fi.iconL, fi.boolL, fi.iconR, fi.boolR, fi.Status, fi.StatusColor, fi.CrewTag.TAG);
            if(position == PM_COLUMNS.LEFT)
                fi.Panel?.UpdatePanel();
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

        public override void ShowColumn(bool show = true)
        {
            base.ShowColumn(show);
            InitColumnScroll(Items.Count >= VisibleItems, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT);
            SetColumnScroll(Index + 1, Items.Count, VisibleItems, CaptionLeft, Items.Count < VisibleItems);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, Focused, false, false);
        }

        public override void ClearColumn()
        {
            base.ClearColumn();
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", 3);
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", 4);
        }

        public void Clear()
        {
            if (visible)
                ClearColumn();
            Items.Clear();
        }

        public void RemovePlayer(int id)
        {
            Items.RemoveAt(id);
            if(visible)
            {
                //TODO: Remove player from scaleform
            }
        }

        public override void GoUp()
        {
            try
            {
                API.ClearPedInPauseMenu();
                CurrentItem.Selected = false;
                index--;
                if (index < 0)
                    index = Items.Count - 1;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 8);
                CurrentItem.Selected = true;
                CurrentItem.CreateClonedPed();
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        public override void GoDown()
        {
            try
            {
                API.ClearPedInPauseMenu();
                CurrentItem.Selected = false;
                    index++;
                    if (index >= Items.Count)
                        index = 0;
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 9);
                CurrentItem.Selected = true;
                CurrentItem.CreateClonedPed();
                CurrentItem.Panel?.UpdatePanel(true);
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

        public override void MouseScroll(int dir)
        {
            API.ClearPedInPauseMenu();
            CurrentItem.Selected = false;
                index += dir;
                if (index < 0)
                    index = Items.Count - 1;
                if (index >= Items.Count)
                    index = 0;
            CurrentItem.Selected = true;
            CurrentItem.CreateClonedPed();
            IndexChangedEvent();
        }

        public FriendItem CurrentItem => (FriendItem)Items[CurrentSelection];
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
                CurrentItem.CreateClonedPed();
                CurrentItem.Panel?.UpdatePanel(true);
                if (visible)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
                IndexChangedEvent();
            }
        }

        public void SortPlayers(Comparison<LobbyItem> compare)
        {
            try
            {
                CurrentItem.Selected = false;
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                Clear();
                List<LobbyItem> list = _unfilteredItems.Cast<LobbyItem>().ToList();
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

        public void FilterPlayers(Func<LobbyItem, bool> predicate)
        {
            if (predicate == null)
                throw new ArgumentNullException(nameof(predicate));
            try
            {
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                //_unfilteredTopEdge = topEdge;

                var filteredItems = Items.Cast<LobbyItem>().Where(predicate).ToList();

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
            OnPlayerItemActivated?.Invoke(CurrentItem, CurrentSelection);
        }

        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
