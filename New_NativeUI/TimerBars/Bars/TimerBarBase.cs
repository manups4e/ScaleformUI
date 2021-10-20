using CitizenFX.Core.UI;
using System.Drawing;
using Font = CitizenFX.Core.UI.Font;

namespace NativeUI
{
    public abstract class TimerBarBase
    {
        public string Label { get; set; }

        public TimerBarBase(string label)
        {
            Label = label;
        }

        public virtual void Draw(int interval)
        {
            SizeF res = ScreenTools.ResolutionMaintainRatio;
            PointF safe = ScreenTools.SafezoneBounds;
            new UIResText(Label, new PointF((int)res.Width - safe.X - 180, (int)res.Height - safe.Y - (30 + (4 * interval))), 0.3f, Colors.White, Font.ChaletLondon, Alignment.Right).Draw();

            new Sprite("timerbars", "all_black_bg", new PointF((int)res.Width - safe.X - 298, (int)res.Height - safe.Y - (40 + (4 * interval))), new SizeF(300, 37), 0f, Color.FromArgb(180, 255, 255, 255)).Draw();

            Screen.Hud.HideComponentThisFrame(HudComponent.AreaName);
            Screen.Hud.HideComponentThisFrame(HudComponent.StreetName);
            Screen.Hud.HideComponentThisFrame(HudComponent.VehicleName);
        }
    }
}
