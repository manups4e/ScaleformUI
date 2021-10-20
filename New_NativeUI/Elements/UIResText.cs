using System;
using System.Drawing;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;
using Font = CitizenFX.Core.UI.Font;

namespace NativeUI
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
            : base(caption, position, scale, color, font, CitizenFX.Core.UI.Alignment.Left)
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
                API.AddTextComponentString(substr);
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
				API.AddTextComponentString(input);
                return;
            }

            var startIndex = 0;

            for (int i = 0; i < input.Length; i++)
            {
                var length = i - startIndex;
                if (enc.GetByteCount(input.Substring(startIndex, length)) > maxByteLengthPerString)
                {
                    string substr = (input.Substring(startIndex, length - 1));
					API.AddTextComponentString(substr);

                    i -= 1;
                    startIndex = (startIndex + length - 1);
                }
            }
			API.AddTextComponentString(input.Substring(startIndex, input.Length - startIndex));
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

			API.SetTextFont((int)Font);
			API.SetTextScale(1.0f, Scale);
			API.SetTextColour(Color.R, Color.G, Color.B, Color.A);
			if (Shadow)
				API.SetTextDropShadow();
			if (Outline)
				API.SetTextOutline();
			switch (TextAlignment)
			{
				case Alignment.Center:
					API.SetTextCentre(true);
					break;
				case Alignment.Right:
					API.SetTextRightJustify(true);
					API.SetTextWrap(0, x);
					break;
			}

			if (Wrap != 0)
            {
                float xsize = (Position.X + Wrap) / width;
				API.SetTextWrap(x, xsize);
			}

			API.SetTextEntry("jamyfafi");
			AddLongString(Caption);

			API.DrawText(x, y);
		}

		//public static void Draw(string caption, int xPos, int yPos, Font font, float scale, UnknownColors color, Alignment alignment, bool Shadow, bool outline, int wordWrap)
		//{
		//    int screenw = Screen.Resolution.Width;
		//    int screenh = Screen.Resolution.Height;
		//    const float height = 1080f;
		//    float ratio = (float)screenw / screenh;
		//    var width = height * ratio;

		//    float x = (xPos) / width;
		//    float y = (yPos) / height;

		//    Function.Call(Hash.SET_TEXT_FONT, (int)font);
		//    Function.Call(Hash.SET_TEXT_SCALE, 1.0f, scale);
		//    Function.Call(Hash.SET_TEXT_COLOUR, color.R, color.G, color.B, color.A);
		//    if (Shadow)
		//        Function.Call(Hash.SET_TEXT_DROP_SHADOW);
		//    if (outline)
		//        Function.Call(Hash.SET_TEXT_OUTLINE);
		//    switch (alignment)
		//    {
		//        case Alignment.Center:
		//            Function.Call(Hash.SET_TEXT_CENTRE, true);
		//            break;
		//        case Alignment.Right:
		//            Function.Call(Hash.SET_TEXT_RIGHT_JUSTIFY, true);
		//            Function.Call(Hash.SET_TEXT_WRAP, 0, x);
		//            break;
		//    }

		//    if (wordWrap != 0)
		//    {
		//        float xsize = (xPos + wordWrap) / width;
		//        Function.Call(Hash.SET_TEXT_WRAP, x, xsize);
		//    }

		//    Function.Call(Hash._SET_TEXT_ENTRY, "jamyfafi");
		//    AddLongString(caption);

		//    Function.Call(Hash._DRAW_TEXT, x, y);
		//}
	}
}
