using ScaleformUI.Elements;
using System.Drawing;

namespace ScaleformUI
{
    /// <summary>
    /// A Text object in the 1080 pixels height base system.
    /// </summary>
    public class UIResText : Text
    {
        public UIResText(string caption, PointF position, float scale) : base(caption, position, scale)
        {
            TextAlignment = Alignment.Left;
        }

        public UIResText(string caption, PointF position, float scale, Color color)
            : base(caption, position, scale, color)
        {
            TextAlignment = Alignment.Left;
        }

        public UIResText(string caption, PointF position, float scale, Color color, Font font, Alignment justify)
            : base(caption, position, scale, color, font, Alignment.Left)
        {
            TextAlignment = justify;
        }


        public Alignment TextAlignment { get; set; }

        /// <summary>
        /// Push a long string into the stack.
        /// </summary>
        /// <param name="str"></param>
        public static void AddLongString(string str)
        {
            var utf8ByteCount = System.Text.Encoding.UTF8.GetByteCount(str);

            if (utf8ByteCount == str.Length)
            {
                AddLongStringForAscii(str);
            }
            else
            {
                AddLongStringForUtf8(str);
            }
        }

        private static void AddLongStringForAscii(string input)
        {
            const int maxByteLengthPerString = 99;

            for (int i = 0; i < input.Length; i += maxByteLengthPerString)
            {
                string substr = (input.Substring(i, Math.Min(maxByteLengthPerString, input.Length - i)));
                AddTextComponentString(substr);
            }
        }

        internal static void AddLongStringForUtf8(string input)
        {
            const int maxByteLengthPerString = 99;

            if (maxByteLengthPerString < 0)
            {
                throw new ArgumentOutOfRangeException("maxLengthPerString");
            }
            if (string.IsNullOrEmpty(input) || maxByteLengthPerString == 0)
            {
                return;
            }

            var enc = System.Text.Encoding.UTF8;

            var utf8ByteCount = enc.GetByteCount(input);
            if (utf8ByteCount < maxByteLengthPerString)
            {
                AddTextComponentString(input);
                return;
            }

            var startIndex = 0;

            for (int i = 0; i < input.Length; i++)
            {
                var length = i - startIndex;
                if (enc.GetByteCount(input.Substring(startIndex, length)) > maxByteLengthPerString)
                {
                    string substr = (input.Substring(startIndex, length - 1));
                    AddTextComponentString(substr);

                    i -= 1;
                    startIndex = (startIndex + length - 1);
                }
            }
            AddTextComponentString(input.Substring(startIndex, input.Length - startIndex));
        }

        [Obsolete("Use ScreenTools.GetTextWidth instead.", true)]
        public static float MeasureStringWidth(string str, Font font, float scale) => ScreenTools.GetTextWidth(str, font, scale);

        [Obsolete("Use ScreenTools.GetTextWidth instead.", true)]
        public static float MeasureStringWidthNoConvert(string str, Font font, float scale) => ScreenTools.GetTextWidth(str, font, scale);

        /// <summary>
        /// Width of the text wrap box. Set to zero to disable.
        /// </summary>
        public float Wrap { get; set; } = 0;
        /// <summary>
        /// Size of the text wrap box.
        /// </summary>
        [Obsolete("Use UIResText.Wrap instead.", true)]
        public SizeF WordWrap
        {
            get => new SizeF(Wrap, 0);
            set => Wrap = value.Width;
        }

        public override void Draw(SizeF offset)
        {
            int screenw = Screen.Resolution.Width;
            int screenh = Screen.Resolution.Height;
            const float height = 1080f;
            float ratio = (float)screenw / screenh;
            var width = height * ratio;

            float x = (Position.X) / width;
            float y = (Position.Y) / height;

            SetTextFont((int)Font);
            SetTextScale(1.0f, Scale);
            SetTextColour(this.Color.R, this.Color.G, this.Color.B, this.Color.A);
            if (Shadow)
                SetTextDropShadow();
            if (Outline)
                SetTextOutline();
            switch (TextAlignment)
            {
                case Alignment.Center:
                    SetTextCentre(true);
                    break;
                case Alignment.Right:
                    SetTextRightJustify(true);
                    SetTextWrap(0, x);
                    break;
            }

            if (Wrap != 0)
            {
                float xsize = (Position.X + Wrap) / width;
                SetTextWrap(x, xsize);
            }

            SetTextEntry("jamyfafi");
            AddLongString(Caption);

            DrawText(x, y);
        }
    }
}
