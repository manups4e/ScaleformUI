using ScaleformUI.Elements;
using ScaleformUI.LobbyMenu;
using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using ScaleformUI.PauseMenus.Elements.Items;

namespace ScaleformUI.PauseMenus.Elements.Panels
{
    public class MissionDetailsPanel : PM_Column
    {
        private string title = "";
        public string TextureDict = "";
        public string TextureName = "";
        public string Title
        {
            get => title;
            set
            {
                title = value;
                if(visible)
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, title, TextureDict, TextureName);
            }
        }

        public MissionDetailsPanel(string label) : base(PM_COLUMNS.RIGHT)
        {
            Label = label;
            VisibleItems = 10;
            type = (int)PLT_COLUMNS.MISSION_DETAILS;
        }
        public override void ShowColumn(bool show = true)
        {
            base.ShowColumn(show);
            //InitColumnScroll(true, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT);
            //SetColumnScroll(Index + 1, Items.Count, VisibleItems, CaptionLeft, Items.Count < VisibleItems);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, Focused, false, false);
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

        public override void Populate()
        {
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, title, TextureDict, TextureName);
            for (int i = 0; i < Items.Count; i++)
            {
                SetDataSlot(i);
            }
        }
        internal void SendItemToScaleform(int i, bool update = false, bool newItem = false, bool isSlot = false)
        {
            if (i >= Items.Count) return;
            UIFreemodeDetailsItem item  = Items[i] as UIFreemodeDetailsItem;
            string str = "SET_DATA_SLOT";
            if (update)
                str = "UPDATE_SLOT";
            if (newItem)
                str = "ADD_SLOT";
            if (isSlot)
                str = "SET_SLOT_EMPTY";
            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, str);
            PushScaleformMovieFunctionParameterInt((int)position);
            PushScaleformMovieFunctionParameterInt(i);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(item.Type);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterBool(false);
            var labels = item.Label.SplitLabel;
            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
            for (var j = 0; j < labels?.Length; j++)
                AddTextComponentScaleform(labels[j]);
            EndTextCommandScaleformString_2();
            PushScaleformMovieFunctionParameterString(item.TextRight);
            switch (item.Type)
            {
                case 2:
                    PushScaleformMovieFunctionParameterInt((int)item.Icon); 
                    PushScaleformMovieFunctionParameterInt(item.IconColor.ArgbValue);
                    PushScaleformMovieFunctionParameterBool(item.Tick);
                    break;
                case 3:
                    PushScaleformMovieFunctionParameterString(item.CrewTag.TAG);
                    PushScaleformMovieFunctionParameterBool(false);
                    break;
            }
            PushScaleformMovieFunctionParameterString(item.LabelFont.FontName);
            PushScaleformMovieFunctionParameterString(item._rightLabelFont.FontName);
            EndScaleformMovieMethod();
        }

        /// <summary>
        /// To change panel's picture
        /// </summary>
        /// <param name="txd">Texture dictionary for the picture</param>
        /// <param name="txn">Texture name for the picture</param>
        public void UpdatePanelPicture(string txd, string txn)
        {
            TextureDict = txd;
            TextureName = txn;
            if (visible)
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, title, TextureDict, TextureName);

        }

        /// <summary>
        /// Adds an item to the description of the panel
        /// </summary>
        /// <param name="item">The items to add</param>
        public void AddItem(UIFreemodeDetailsItem item)
        {
            Items.Add(item);
            //if (Parent != null && Parent.Visible)
            //{
            //    if (Parent is MainView lobby)
            //        lobby._pause._lobby.CallFunction("ADD_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, (int)item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID);
            //    else if (Parent is TabView pause && ParentTab.Visible)
            //        pause._pause._pause.CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, (int)item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID);
            //}
        }

        /// <summary>
        /// Removes an item from the scription of the panel
        /// </summary>
        /// <param name="idx">item's index</param>
        public void RemoveItem(int idx)
        {
            Items.RemoveAt(idx);
            //if (Parent != null && Parent.Visible)
            //{
            //    if (Parent is MainView lobby)
            //        lobby._pause._lobby.CallFunction("REMOVE_MISSION_PANEL_ITEM", idx);
            //    else if (Parent is TabView pause && ParentTab.Visible)
            //        pause._pause._pause.CallFunction("REMOVE_PLAYERS_TAB_MISSION_PANEL_ITEM", idx);
            //}
        }

        public void Clear()
        {
            Items.Clear();
        }
    }
}
