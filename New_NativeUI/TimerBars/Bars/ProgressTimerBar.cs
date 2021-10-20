
using System.Drawing;

namespace NativeUI
{
    public class ProgressTimerBar : TimerBarBase
    {
        /// <summary>
        /// Bar percentage. Goes from 0 to 1.
        /// </summary>
        public float Percentage { get; set; }

        public Color BackgroundColor { get; set; }
        public Color ForegroundColor { get; set; }

        private UIResRectangle _background;
        private UIResRectangle _foreground;

        public ProgressTimerBar(string label) : base(label)
        {
            BackgroundColor = Colors.DarkRed;
            ForegroundColor = Colors.Red;
            _background = new UIResRectangle(new PointF(0, 0), new SizeF(150, 15), BackgroundColor);
            _foreground = new UIResRectangle(new PointF(0,0), new SizeF(0, 15), ForegroundColor);
        }

        public ProgressTimerBar(string label, Color background, Color foreground) : base(label)
        {
            BackgroundColor = background;
            ForegroundColor = foreground;
            _background = new UIResRectangle(new PointF(0, 0), new SizeF(150, 15), BackgroundColor);
            _foreground = new UIResRectangle(new PointF(0, 0), new SizeF(0, 15), ForegroundColor);
        }

        public override void Draw(int interval)
        {
            SizeF res = ScreenTools.ResolutionMaintainRatio;
            PointF safe = ScreenTools.SafezoneBounds;

            base.Draw(interval);

            var start = new PointF((int)res.Width - safe.X - 160, (int)res.Height - safe.Y - (28 + (4 * interval)));

            _background.Position = start;
            _foreground.Position = start;

            _foreground.Size = new SizeF(150 * Percentage, 15);

            // In case someone decides to change colors while drawing..
            _background.Color = BackgroundColor;
            _foreground.Color = ForegroundColor;

            _background.Draw();
            _foreground.Draw();
        }
    }
}
