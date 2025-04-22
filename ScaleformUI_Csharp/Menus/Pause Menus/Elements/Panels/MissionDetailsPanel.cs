using ScaleformUI.Menu;
using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;

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
                    Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, title);
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
            if (!visible) return;
            base.ShowColumn(show);
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, title, TextureDict, TextureName);
            Debug.WriteLine($"{position} - {title} - {TextureDict} - {TextureName}");
            Main.PauseMenu._pause.CallFunction("SET_COLUMN_FOCUS", (int)position, Focused, false, false);
        }

        public override void SetDataSlot(int index)
        {
            if (!visible) return;
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
            if (!visible) return;
            Main.PauseMenu._pause.CallFunction("SET_DATA_SLOT_EMPTY", (int)position);
            for (int i = 0; i < Items.Count; i++)
            {
                SetDataSlot(i);
            }
        }
        internal void SendItemToScaleform(int i, bool update = false, bool newItem = false, bool isSlot = false)
        {
            if (!visible) return;
            if (i >= Items.Count) return;
            UIFreemodeDetailsItem item  = Items[i] as UIFreemodeDetailsItem;
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
            bool change = TextureDict != txd || TextureName != txn;
            TextureDict = txd;
            TextureName = txn;
            if (visible && change)
                Main.PauseMenu._pause.CallFunction("SET_COLUMN_TITLE", (int)position, title, TextureDict, TextureName);
        }

        /// <summary>
        /// Adds an item to the description of the panel
        /// </summary>
        /// <param name="item">The items to add</param>
        public void AddItem(UIFreemodeDetailsItem item)
        {
            Items.Add(item);
            if(visible && Items.Count <= VisibleItems)
            {
                var idx = Items.Count - 1;
                AddSlot(idx);
            }
        }

        /// <summary>
        /// Removes an item from the scription of the panel
        /// </summary>
        /// <param name="idx">item's index</param>
        public void RemoveItem(int idx)
        {
            Items.RemoveAt(idx);
        }

        //public override void ClearColumn()
        //{
        //    base.ClearColumn();
        //    title = "";
        //    TextureDict = "";
        //    TextureName = "";
        //}
    }
}
