﻿
using ScaleformUI.Elements;
using System.Drawing;
using Font = CitizenFX.Core.UI.Font;

namespace ScaleformUI
{
    public class ProgressTimerBar : TimerBarBase
    {
        /// <summary>
        /// Bar percentage. Goes from 0 to 1.
        /// </summary>
        public float Percentage { get; set; }

        public SColor BackgroundColor { get; set; }
        public SColor ForegroundColor { get; set; }

        private UIResRectangle _background;
        private UIResRectangle _foreground;

        public ProgressTimerBar(string label) : base(label)
        {
            BackgroundColor = SColor.HUD_Reddark;
            ForegroundColor = SColor.HUD_Red;
            _background = new UIResRectangle(new PointF(0, 0), new SizeF(150, 15), BackgroundColor.ToColor());
            _foreground = new UIResRectangle(new PointF(0, 0), new SizeF(0, 15), ForegroundColor.ToColor());
        }

        public ProgressTimerBar(string label, Font labelFont) : base(label, labelFont)
        {
            BackgroundColor = SColor.HUD_Reddark;
            ForegroundColor = SColor.HUD_Red;
            _background = new UIResRectangle(new PointF(0, 0), new SizeF(150, 15), BackgroundColor.ToColor());
            _foreground = new UIResRectangle(new PointF(0, 0), new SizeF(0, 15), ForegroundColor.ToColor());
        }

        public ProgressTimerBar(string label, Color background, Color foreground) : base(label)
        {
            BackgroundColor = SColor.FromColor(background);
            ForegroundColor = SColor.FromColor(foreground);
            _background = new UIResRectangle(new PointF(0, 0), new SizeF(150, 15), BackgroundColor.ToColor());
            _foreground = new UIResRectangle(new PointF(0, 0), new SizeF(0, 15), ForegroundColor.ToColor());
        }

        public ProgressTimerBar(string label, Color background, Color foreground, Font labelFont) : base(label, labelFont)
        {
            BackgroundColor = SColor.FromColor(background);
            ForegroundColor = SColor.FromColor(foreground);
            _background = new UIResRectangle(new PointF(0, 0), new SizeF(150, 15), BackgroundColor.ToColor());
            _foreground = new UIResRectangle(new PointF(0, 0), new SizeF(0, 15), ForegroundColor.ToColor());
        }

        public override void Draw(int interval)
        {
            SizeF res = ScreenTools.ResolutionMaintainRatio;
            PointF safe = ScreenTools.SafezoneBounds;

            base.Draw(interval);

            PointF start = new PointF((int)res.Width - safe.X - 160, (int)res.Height - safe.Y - (28 + (4 * interval)));

            _background.Position = start;
            _foreground.Position = start;

            _foreground.Size = new SizeF(150 * Percentage, 15);

            // In case someone decides to change colors while drawing..
            _background.Color = BackgroundColor.ToColor();
            _foreground.Color = ForegroundColor.ToColor();

            _background.Draw();
            _foreground.Draw();
        }
    }
}
