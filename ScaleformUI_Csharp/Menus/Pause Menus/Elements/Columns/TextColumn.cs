using ScaleformUI.Menus;
using ScaleformUI.PauseMenu;
using System.Security.Policy;

namespace ScaleformUI.PauseMenus.Elements
{
    public class TextColumn : PM_Column
    {
        public TextColumn(int position) : base(position)
        {
            VisibleItems = 16;
        }

        public override void SetDataSlot(int index)
        {
            if (index >= Items.Count)
                return;
            PauseMenuItem it = Items[index];
            var labels = it.Label.SplitLabel;
            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "SET_DATA_SLOT");
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterBool(true);
			AddTextEntry("TXT_COL_LBL", it.Label.Label);
			BeginTextCommandScaleformString("TXT_COL_LBL");
			EndTextCommandScaleformString_2();
			EndScaleformMovieMethod();
        }

        public override void UpdateSlot(int index)
        {
            if (index >= Items.Count)
                return;
            PauseMenuItem it = Items[index];
            var labels = it.Label.SplitLabel;
            BeginScaleformMovieMethod(Main.PauseMenu._pause.Handle, "UPDATE_SLOT");
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(index);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterInt(0);
            PushScaleformMovieFunctionParameterBool(true);
			AddTextEntry("TXT_COL_LBL", it.Label.Label);
			BeginTextCommandScaleformString("TXT_COL_LBL");
			EndTextCommandScaleformString_2();
			EndScaleformMovieMethod();
        }
    }
}
