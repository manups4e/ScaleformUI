using CitizenFX.Core.UI;
using System.Drawing;
using Font = CitizenFX.Core.UI.Font;

namespace NativeUI
{
    public class TextTimerBar : TimerBarBase
    {
        public string Caption { get; set; }
        public Color CaptionColor { get; set; } = Colors.White;

        public TextTimerBar(string label, string text) : base(label)
        {
            Caption = text;
        }
        public TextTimerBar(string label, string text, Color captionColor) : base(label)
        {
            Caption = text;
            CaptionColor = captionColor;
        }

        public override void Draw(int interval)
        {
            SizeF res = ScreenTools.ResolutionMaintainRatio;
            PointF safe = ScreenTools.SafezoneBounds;

            base.Draw(interval);
            new UIResText(Caption, new PointF((int)res.Width - safe.X - 10, (int)res.Height - safe.Y - (42 + (4 * interval))), 0.5f, CaptionColor, Font.ChaletLondon, Alignment.Right).Draw();
        }
    }
}
