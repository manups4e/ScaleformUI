using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;
using System;
using System.Collections.Generic;
using System.Linq;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.PauseMenus.Elements.Columns
{
    public delegate void SettingItemSelected(UIMenuItem item, int index);
    public class SettingsListColumn : PM_Column
    {
        public event IndexChanged OnIndexChanged;
        private List<PauseMenuItem> _unfilteredItems;
        private int _unfilteredSelection;
        public event SettingItemSelected OnSettingItemActivated;
        public SettingsListColumn(string label, int maxItems = 16) : base(-1)
        {
            Label = label;
            VisibleItems = maxItems;
            type = (int)PLT_COLUMNS.SETTINGS;
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

        public void SetColumnPosition(PM_COLUMNS pos)
        {
            position = pos;
        }

        public override void AddItem(PauseMenuItem item)
        {
            AddSettings((UIMenuItem)item);
        }

        public void AddSettings(UIMenuItem item)
        {
            if(item.mainColor == SColor.HUD_Panel_light)
            {
                item.MainColor = SColor.HUD_Pause_bg;
            }
            item.ParentColumn = this;
            Items.Add(item);
            if (visible && Items.Count <= VisibleItems)
            {
                var idx = Items.Count - 1;
                AddSlot(idx);
                item.Selected = idx == index;
            }
        }

        public override void ShowColumn(bool show = true)
        {
            if (!visible) return;
            base.ShowColumn(show);
            InitColumnScroll(Items.Count >= VisibleItems, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT);
            SetColumnScroll(Index + 1, Items.Count, VisibleItems, CaptionLeft, Items.Count < VisibleItems);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, Focused, false, false);
            if (Items.Count > 0 && CurrentItem is UIMenuSeparatorItem it && it.Jumpable)
            {
                CurrentItem.Selected = false;
                index++;
                if (index >= Items.Count)
                    index = 0;
                CurrentItem.Selected = true;
            }
        }

        public override void Populate()
        {
            if (!visible) return;
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_MAX_ITEMS", (int)position, VisibleItems);
            for (var i = 0; i < Items.Count; i++)
            {
                SetDataSlot(i);
            }
        }

        public override void SetDataSlot(int index)
        {
            if (index >= Items.Count) return;
            if (visible)
                SendItemToScaleform(index);
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

        public void AddItemAt(UIMenuItem item, int idx)
        {
            if (!visible) return;
            if (idx >= Items.Count) return;
            Items.Insert(idx, item);
            if (visible)
            {
                SendItemToScaleform(idx, false, true, false);
                item.Selected = idx == index;
            }
        }

        internal void SendItemToScaleform(int i, bool update = false, bool newItem = false, bool isSlot = false)
        {
            if (i >= Items.Count) return;

            UIMenuItem item = (UIMenuItem)Items[i];
            string str = "SET_DATA_SLOT";
            if (update)
                str = "UPDATE_SLOT";
            if (newItem)
                str = "SET_DATA_SLOT_SPLICE";
            if (isSlot)
                str = "ADD_SLOT";

            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, str);
            PushScaleformMovieFunctionParameterInt((int)position);
            PushScaleformMovieFunctionParameterInt(i);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(item._itemId);
            switch (item._itemId)
            {
                case 1:
                    UIMenuDynamicListItem dit = (UIMenuDynamicListItem)item;
                    var curString = dit.Selected ? (dit.CurrentListItem.StartsWith("~") ? dit.CurrentListItem : "~s~" + dit.CurrentListItem).ToString().Replace("~w~", "~l~").Replace("~s~", "~l~") : (dit.CurrentListItem.StartsWith("~") ? dit.CurrentListItem : "~s~" + dit.CurrentListItem).ToString().Replace("~l~", "~s~");
                    if (!dit.Enabled)
                        curString = curString.ReplaceRstarColorsWith("~c~");
                    PushScaleformMovieMethodParameterString(curString);
                    break;
                case 2:
                    UIMenuCheckboxItem check = (UIMenuCheckboxItem)item;
                    PushScaleformMovieMethodParameterBool(check.Checked);
                    break;
                case 3:
                    UIMenuSliderItem prItem = (UIMenuSliderItem)item;
                    PushScaleformMovieFunctionParameterInt(prItem.Value);
                    break;
                case 4:
                    UIMenuProgressItem slItem = (UIMenuProgressItem)item;
                    PushScaleformMovieFunctionParameterInt(slItem.Value);
                    break;
                case 5:
                    UIMenuStatsItem statsItem = (UIMenuStatsItem)item;
                    PushScaleformMovieFunctionParameterInt(statsItem.Value);
                    break;
                default:
                    PushScaleformMovieFunctionParameterInt(0);
                    break;
            }
            PushScaleformMovieFunctionParameterBool(item.Enabled);
            PushScaleformMovieMethodParameterString(item._formatLeftLabel);
            PushScaleformMovieFunctionParameterBool(item.BlinkDescription);
            switch (item)
            {
                case UIMenuDynamicListItem:
                    PushScaleformMovieFunctionParameterInt(item.MainColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(item.HighlightColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt((int)item.LeftBadge);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Key);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Value);
                    PushScaleformMovieMethodParameterString(item.labelFont.FontName);
                    PushScaleformMovieMethodParameterString(item.rightLabelFont.FontName);
                    break;
                case UIMenuCheckboxItem check:
                    PushScaleformMovieFunctionParameterInt((int)check.Style);
                    PushScaleformMovieFunctionParameterInt(check.MainColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(check.HighlightColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt((int)item.LeftBadge);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Key);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Value);
                    PushScaleformMovieMethodParameterString(item.labelFont.FontName);
                    break;
                case UIMenuSliderItem prItem:
                    PushScaleformMovieFunctionParameterInt(prItem._max);
                    PushScaleformMovieFunctionParameterInt(prItem._multiplier);
                    PushScaleformMovieFunctionParameterInt(prItem.MainColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(prItem.HighlightColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(prItem.SliderColor.ArgbValue);
                    PushScaleformMovieFunctionParameterBool(prItem._heritage);
                    PushScaleformMovieFunctionParameterInt((int)item.LeftBadge);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Key);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Value);
                    PushScaleformMovieMethodParameterString(item.labelFont.FontName);
                    break;
                case UIMenuProgressItem slItem:
                    PushScaleformMovieFunctionParameterInt(slItem._max);
                    PushScaleformMovieFunctionParameterInt(slItem._multiplier);
                    PushScaleformMovieFunctionParameterInt(slItem.MainColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(slItem.HighlightColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(slItem.SliderColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt((int)item.LeftBadge);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Key);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Value);
                    PushScaleformMovieMethodParameterString(item.labelFont.FontName);
                    break;
                case UIMenuStatsItem statsItem:
                    PushScaleformMovieFunctionParameterInt(statsItem.Type);
                    PushScaleformMovieFunctionParameterInt(statsItem.SliderColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(statsItem.MainColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(statsItem.HighlightColor.ArgbValue);
                    break;
                case UIMenuSeparatorItem separatorItem:
                    PushScaleformMovieFunctionParameterBool(separatorItem.Jumpable);
                    PushScaleformMovieFunctionParameterInt(item.MainColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(item.HighlightColor.ArgbValue);
                    PushScaleformMovieMethodParameterString(item.labelFont.FontName);
                    break;
                default:
                    PushScaleformMovieFunctionParameterInt(item.MainColor.ArgbValue);
                    PushScaleformMovieFunctionParameterInt(item.HighlightColor.ArgbValue);
                    PushScaleformMovieMethodParameterString(item._formatRightLabel);
                    PushScaleformMovieFunctionParameterInt((int)item.LeftBadge);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Key);
                    PushScaleformMovieMethodParameterString(item.customLeftBadge.Value);
                    PushScaleformMovieFunctionParameterInt((int)item.RightBadge);
                    PushScaleformMovieMethodParameterString(item.customRightBadge.Key);
                    PushScaleformMovieMethodParameterString(item.customRightBadge.Value);
                    PushScaleformMovieMethodParameterString(item.labelFont.FontName);
                    PushScaleformMovieMethodParameterString(item.rightLabelFont.FontName);
                    break;
            }
            EndScaleformMovieMethod();
        }

        [Obsolete("Use item.Description instead.")]
        public void UpdateDescription()
        {
            API.AddTextEntry("PAUSEMENU_Current_Description", CurrentItem.Description);
            SendItemToScaleform(Index, true);
        }

        public override async void GoUp()
        {
            if (!visible) return;
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
                while (CurrentItem is UIMenuSeparatorItem sp && sp.Jumpable);
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 8);
                AddTextEntry("PAUSEMENU_Current_Description", CurrentItem.Description);
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
            if (!visible) return;
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
                while (CurrentItem is UIMenuSeparatorItem sp && sp.Jumpable);
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_INPUT_EVENT", (int)position, 9);
                API.AddTextEntry("PAUSEMENU_Current_Description", CurrentItem.Description);
                CurrentItem.Selected = true;
                IndexChangedEvent();
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }

        public override async void GoLeft()
        {
            if (!visible) return;
            if (!CurrentItem.Enabled)
            {
                Game.PlaySound(TabView.AUDIO_ERROR, TabView.AUDIO_LIBRARY);
                return;
            }
            switch (CurrentItem)
            {
                case UIMenuListItem it:
                    {
                        it.Index--;
                        it.ListChangedTrigger(it.Index);
                        break;
                    }
                case UIMenuDynamicListItem it:
                    {
                        string newItem = await it.Callback(it, ChangeDirection.Left);
                        it.CurrentListItem = newItem;
                        break;
                    }
                case UIMenuSliderItem it:
                    {
                        it.Value--;
                        break;
                    }
                case UIMenuProgressItem it:
                    {
                        it.Value--;
                        break;
                    }
                case UIMenuStatsItem it:
                    {
                        it.Value--;
                        break;
                    }
            }
            Game.PlaySound(TabView.AUDIO_LEFTRIGHT, TabView.AUDIO_LIBRARY);
        }

        public override async void GoRight()
        {
            if (!visible) return;
            if (!CurrentItem.Enabled)
            {
                Game.PlaySound(TabView.AUDIO_ERROR, TabView.AUDIO_LIBRARY);
                return;
            }
            switch (CurrentItem)
            {
                case UIMenuListItem it:
                    {
                        it.Index++;
                        it.ListChangedTrigger(it.Index);
                        break;
                    }
                case UIMenuDynamicListItem it:
                    {
                        string newItem = await it.Callback(it, ChangeDirection.Left);
                        it.CurrentListItem = newItem;
                        break;
                    }
                case UIMenuSliderItem it:
                    {
                        it.Value++;
                        break;
                    }
                case UIMenuProgressItem it:
                    {
                        it.Value++;
                        break;
                    }
                case UIMenuStatsItem it:
                    {
                        it.Value++;
                        break;
                    }
            }
            Game.PlaySound(TabView.AUDIO_LEFTRIGHT, TabView.AUDIO_LIBRARY);
        }

        public override void Select()
        {
            if (!visible) return;
            UIMenuItem item = CurrentItem;
            if (!item.Enabled)
            {
                Game.PlaySound(TabView.AUDIO_ERROR, TabView.AUDIO_LIBRARY);
                return;
            }
            switch (item)
            {
                case UIMenuCheckboxItem it:
                    {
                        it.Checked = !it.Checked;
                        it.CheckboxEventTrigger();
                        SelectItem();
                        break;
                    }
                case UIMenuListItem it:
                    {
                        it.ListSelectedTrigger(it.Index);
                        item.ItemActivate(null);
                        SelectItem();
                        break;
                    }
                default :
                    item.ItemActivate(null);
                    SelectItem();
                    break;
            }
        }
        public override void GoBack()
        {
            Focused = false;
        }

        public async override void MouseScroll(int dir)
        {
            if (!visible) return;
            CurrentItem.Selected = false;
            do
            {
                index += dir;
                if(index < 0)
                    index = Items.Count - 1;
                if (index >= Items.Count)
                    index = 0;
                await BaseScript.Delay(0);
            }
            while (CurrentItem is UIMenuSeparatorItem sp && sp.Jumpable);
            API.AddTextEntry("PAUSEMENU_Current_Description", CurrentItem.Description);
            CurrentItem.Selected = true;
            IndexChangedEvent();
        }

        public UIMenuItem CurrentItem => (UIMenuItem)Items[Index];
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

                if (visible && Focused)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_HIGHLIGHT", (int)position, index, true, true);
                IndexChangedEvent();
            }
        }

        public void UpdateItemLabels(int index, string leftLabel, string rightLabel)
        {
            if (visible)
            {
                if (index >= Items.Count) return;
                ((UIMenuItem)Items[index]).Label = leftLabel;
                ((UIMenuItem)Items[index]).SetRightLabel(rightLabel);
            }
        }

        public void UpdateItemBlinkDescription(int index, bool blink)
        {
            if (visible)
            {
                if(index >= Items.Count) return;
                ((UIMenuItem)Items[index]).BlinkDescription = blink;
            }
        }

        public void UpdateItemLabel(int index, string label)
        {
            if (visible)
            {
                if(index >= Items.Count) return;
                ((UIMenuItem)Items[index]).Label = label;
            }
        }

        public void UpdateItemRightLabel(int index, string label)
        {
            if (visible)
            {
                if(index >= Items.Count) return;
                ((UIMenuItem)Items[index]).SetRightLabel(label);
            }
        }

        public void UpdateItemLeftBadge(int index, BadgeIcon badge)
        {
            if (visible)
            {
                if (index >= Items.Count) return;
                ((UIMenuItem)Items[index]).SetLeftBadge(badge);
            }
        }

        public void UpdateItemRightBadge(int index, BadgeIcon badge)
        {
            if (visible)
            {
                if (index >= Items.Count) return;
                ((UIMenuItem)Items[index]).SetRightBadge(badge);
            }
        }

        public void EnableItem(int index, bool enable)
        {
            if (visible)
            {
                if (index >= Items.Count) return;
                ((UIMenuItem)Items[index]).Enabled = enable;
            }
        }

        public void SortSettings(Comparison<UIMenuItem> compare)
        {
            if (!visible) return;
            try
            {
                CurrentItem.Selected = false;
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                Clear();
                List<UIMenuItem> list = _unfilteredItems.Cast<UIMenuItem>().ToList();
                list.Sort(compare);
                Items = list.Cast<PauseMenuItem>().ToList();
                if(visible)
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

        public void FilterSettings(Func<UIMenuItem, bool> predicate)
        {
            if (!visible) return;
            if (predicate == null)
                throw new ArgumentNullException(nameof(predicate));
            try
            {
                _unfilteredItems = Items.ToList();
                _unfilteredSelection = CurrentSelection;
                //_unfilteredTopEdge = topEdge;

                var filteredItems = Items.Cast<UIMenuItem>().Where(predicate).ToList();

                if (!filteredItems.Any())
                {
                    Debug.WriteLine("^1ScaleformUI - No items were found, resetting the filter");
                    _unfilteredItems.Clear();
                    _unfilteredSelection = 0;
                    //_unfilteredTopEdge = 0;
                    return;
                }

                Items[CurrentSelection].Selected = false;
                Clear();

                Items = filteredItems.Cast<PauseMenuItem>().ToList();
                CurrentSelection = 0;
                //topEdge = 0;

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
            if (!visible) return;
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

        public override void ClearColumn()
        {
            base.ClearColumn();
            API.AddTextEntry("PAUSEMENU_Current_Description", "");
        }

        public void SelectItem()
        {
            OnSettingItemActivated?.Invoke(CurrentItem, CurrentSelection);
        }
        public void IndexChangedEvent()
        {
            OnIndexChanged?.Invoke(CurrentSelection);
        }
    }
}
