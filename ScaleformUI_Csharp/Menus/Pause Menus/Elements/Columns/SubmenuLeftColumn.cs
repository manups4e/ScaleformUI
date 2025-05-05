using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;

namespace ScaleformUI.PauseMenus.Elements
{
    public class SubmenuLeftColumn : PM_Column
    {
        internal LeftItemType currentItemType => ((TabLeftItem)Items[Index]).ItemType;
        public int CurrentSelection { get => Index; set => Index = value; }
        public TabLeftItem CurrentItem => (TabLeftItem)Items[CurrentSelection];

        public SubmenuLeftColumn(PM_COLUMNS position) : base(position)
        {
            VisibleItems = 10;
        }

        public void AddItem(TabLeftItem item)
        {
            Items.Add(item);
            if (Parent != null && Parent.Visible && Parent.Parent != null && Parent.Parent.Visible)
            {

            }
        }

        public override void SetDataSlot(int index)
        {
            if (index >= Items.Count)
                return;
            TabLeftItem item = (TabLeftItem)Items[index];
            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
            PushScaleformMovieFunctionParameterInt((int)position);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterBool(item.Enabled);
            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
            AddTextComponentScaleform(item.Label);
            EndTextCommandScaleformString_2();
            PushScaleformMovieFunctionParameterBool(false);
            PushScaleformMovieFunctionParameterInt(item.MainColor.ArgbValue);
            PushScaleformMovieFunctionParameterInt(item.HighlightColor.ArgbValue);
            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
            AddTextComponentScaleform(item._internalItem.RightLabel);
            EndTextCommandScaleformString_2();
            PushScaleformMovieFunctionParameterInt((int)item._internalItem.LeftBadge);
            PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Key);
            PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Value);
            PushScaleformMovieFunctionParameterInt((int)item._internalItem.RightBadge);
            PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Key);
            PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Value);
            PushScaleformMovieMethodParameterString(item._internalItem.labelFont.FontName);
            PushScaleformMovieMethodParameterString(item._internalItem.rightLabelFont.FontName);
            EndScaleformMovieMethod();
        }

        public override void UpdateSlot(int index)
        {
            if (index >= Items.Count)
                return;
            TabLeftItem item = (TabLeftItem)Items[index];
            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "UPDATE_SLOT");
            PushScaleformMovieFunctionParameterInt((int)position);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterBool(item.Enabled);
            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
            AddTextComponentScaleform(item.Label);
            EndTextCommandScaleformString_2();
            PushScaleformMovieFunctionParameterBool(false);
            PushScaleformMovieFunctionParameterInt(item.MainColor.ArgbValue);
            PushScaleformMovieFunctionParameterInt(item.HighlightColor.ArgbValue);
            BeginTextCommandScaleformString("CELL_EMAIL_BCON");
            AddTextComponentScaleform(item._internalItem.RightLabel);
            EndTextCommandScaleformString_2();
            PushScaleformMovieFunctionParameterInt((int)item._internalItem.LeftBadge);
            PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Key);
            PushScaleformMovieMethodParameterString(item._internalItem.customLeftBadge.Value);
            PushScaleformMovieFunctionParameterInt((int)item._internalItem.RightBadge);
            PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Key);
            PushScaleformMovieMethodParameterString(item._internalItem.customRightBadge.Value);
            PushScaleformMovieMethodParameterString(item._internalItem.labelFont.FontName);
            PushScaleformMovieMethodParameterString(item._internalItem.rightLabelFont.FontName);
            EndScaleformMovieMethod();
        }

        public override void GoUp()
        {
            Items[Index].Selected = false;
            index--;
            if (index < 0)
                index = Items.Count - 1;
            Items[Index].Selected = true;
            Parent.CenterColumn.Items.Clear();
            if (currentItemType != LeftItemType.Empty)
                Parent.CenterColumn.Items.AddRange(((TabLeftItem)Items[Index]).ItemList);
            if (Parent != null && Parent.Visible && Parent.Parent != null && Parent.Parent.Visible)
                Parent.Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
        }
         
        public override void GoDown()
        {
            Items[Index].Selected = false;
            index++;
            if (index >= Items.Count)
                index = 0;
            Items[Index].Selected = true;
            Parent.CenterColumn.Items.Clear();
            if (currentItemType != LeftItemType.Empty)
                Parent.CenterColumn.Items.AddRange(((TabLeftItem)Items[Index]).ItemList);
            if (Parent != null && Parent.Visible && Parent.Parent != null && Parent.Parent.Visible)
                Parent.Parent._pause._pause.CallFunction("MENU_STATE", (int)currentItemType);
        }
    }
}
