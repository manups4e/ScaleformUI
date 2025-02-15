using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.PauseMenu;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ScaleformUI.Menu
{
    public class UIMenuListItem : UIMenuDynamicListItem, IListItem
    {
        protected internal int _index;
        protected internal List<dynamic> _items;
        public List<dynamic> IndexToValue;


        /// <summary>
        /// Triggered when the list is changed.
        /// </summary>
        public event ItemListEvent OnListChanged;

        /// <summary>        
        /// Triggered when a list item is selected.        
        /// </summary>        
        public event ItemListEvent OnListSelected;

        /// <summary>
        /// Returns the current selected index.
        /// </summary>
        public int Index
        {
            get { return Items.Count == 0 ? 0 : _index % Items.Count; }
            set
            {
                if (value < 0)
                    _index = Items.Count - 1;
                else if (value > Items.Count - 1)
                    _index = 0;
                else
                    _index = value;
                CurrentListItem = Items[_index].ToString();
            }
        }

        /// <summary>
        /// Returns the current selected index.
        /// </summary>
        public List<object> Items
        {
            get => _items;
            set
            {
                _items = new(value);
                CurrentListItem = Items[_index].ToString();
            }
        }

        public override bool Enabled
        {
            get => base.Enabled;
            set
            {
                base.Enabled = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                //if (ParentColumn != null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                //{
                //    if (ParentColumn.Parent is MainView lobby)
                //    {
                //        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_LISTITEM_LIST", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), joinedList, Index);
                //    }
                //    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                //    {
                //        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_LISTITEM_LIST", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), joinedList, Index);
                //    }
                //}
            }
        }

        public override bool Selected
        {
            get => base.Selected;
            internal set
            {
                base.Selected = value;
                if (Parent != null && Parent.Visible)
                    Parent.SendItemToScaleform(Parent.MenuItems.IndexOf(this), true);
                //if (ParentColumn != null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
                //{
                //    if (ParentColumn.Parent is MainView lobby)
                //    {
                //        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_LISTITEM_LIST", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), joinedList, Index);
                //    }
                //    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
                //    {
                //        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_LISTITEM_LIST", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), joinedList, Index);
                //    }
                //}
            }
        }


        /// <summary>
        /// List item, with left/right arrows.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="items">List that contains your items.</param>
        /// <param name="index">Index in the list. If unsure user 0.</param>
        public UIMenuListItem(string text, List<dynamic> items, int index) : this(text, items, index, "")
        {
        }

        /// <summary>
        /// List item, with left/right arrows.
        /// </summary>
        /// <param name="text">Item label.</param>
        /// <param name="items">List that contains your items.</param>
        /// <param name="index">Index in the list. If unsure user 0.</param>
        /// <param name="description">Description for this item.</param>
        public UIMenuListItem(string text, List<dynamic> items, int index, string description) : this(text, items, index, description, SColor.HUD_Panel_light, SColor.White)
        {
        }

        private DynamicListItemChangeCallback _callback = async (sender, direction) =>
        {
            return await ((UIMenuListItem)sender).getIndex(direction);
        };

        public UIMenuListItem(string text, List<object> items, int index, string description, SColor mainColor, SColor higlightColor) : base(text, description, "" + items[index])
        {
            _items = new(items);
            Index = index;
            Callback = _callback;
        }

        private async Task<string> getIndex(ChangeDirection d)
        {
            if (d == ChangeDirection.Left)
            {
                _index--;
                if(_index < 0)
                    _index = Items.Count - 1;
            }
            else
            {
                _index++;
                if (_index >= Items.Count)
                    _index = 0;
            }
            return Items[_index].ToString();
        }

        /// <summary>
        /// Find an item in the list and return it's index.
        /// </summary>
        /// <param name="item">Item to search for.</param>
        /// <returns>Item index.</returns>
        [Obsolete("Use UIMenuListItem.Items.FindIndex(p => ReferenceEquals(p, item)) instead.")]
        public virtual int ItemToIndex(dynamic item)
        {
            return _items.FindIndex(p => ReferenceEquals(p, item));
        }

        /// <summary>
        /// Find an item by it's index and return the item.
        /// </summary>
        /// <param name="index">Item's index.</param>
        /// <returns>Item</returns>
        [Obsolete("Use UIMenuListItem.Items[Index] instead.")]
        public virtual dynamic IndexToItem(int index)
        {
            return _items[index];
        }

        /// <summary>
        /// Add a Panel to the UIMenuListItem
        /// </summary>
        /// <param name="panel"></param>
        public override void AddPanel(UIMenuPanel panel)
        {
            Panels.Add(panel);
            panel.SetParentItem(this);
        }

        internal virtual void ListChangedTrigger(int newindex)
        {
            OnListChanged?.Invoke(this, newindex);
        }

        internal virtual void ListSelectedTrigger(int newindex)
        {
            OnListSelected?.Invoke(this, newindex);
        }

        /// <summary>
        /// Change list dinamically
        /// </summary>
        /// <param name="list">The list that will replace the current one</param>
        /// <param name="index">Starting index</param>
        public void ChangeList(List<dynamic> list, int index)
        {
            _items = null;
            _items = new(list);
            Index = index;
            //if (ParentColumn != null && ParentColumn.Parent.Visible && ParentColumn.Pagination.IsItemVisible(ParentColumn.Items.IndexOf(this)))
            //{
            //    if (ParentColumn.Parent is MainView lobby)
            //    {
            //        lobby._pause._lobby.CallFunction("UPDATE_SETTINGS_LISTITEM_LIST", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), joinedList, Index);
            //    }
            //    else if (ParentColumn.Parent is TabView pause && ParentColumn.ParentTab.Visible)
            //    {
            //        pause._pause._pause.CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_LISTITEM_LIST", ParentColumn.Pagination.GetScaleformIndex(ParentColumn.Items.IndexOf(this)), joinedList, Index);
            //    }
            //}
        }


        public override void SetRightBadge(BadgeIcon badge)
        {
            throw new Exception("UIMenuListItem cannot have a right badge.");
        }

        public override void SetRightLabel(string text)
        {
            throw new Exception("UIMenuListItem cannot have a right label.");
        }

        [Obsolete("Use CurrentListItem instead.")]
        public string CurrentItem()
        {
            return _items[Index].ToString();
        }
    }
}