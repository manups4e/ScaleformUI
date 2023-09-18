using CitizenFX.Core.Native;
using ScaleformUI.Scaleforms;
using System.Drawing;

namespace ScaleformUI.Elements
{
    public struct SColor
    {
        private readonly Color mainColor;
        public SColor(string hexColor)
        {
            if (hexColor.StartsWith("#"))
            {
                string argbHexString = hexColor.Substring(1);
                int argbValue = int.Parse(argbHexString, System.Globalization.NumberStyles.HexNumber);
                mainColor = Color.FromArgb(argbValue);
            }
            else throw new Exception("Invalid Hex value");
        }

        public SColor(Color color)
        {
            mainColor = color;
        }

        public SColor(HudColor color)
        {
            int r = 0, g = 0, b = 0, a = 0;
            API.GetHudColour((int)color, ref r, ref g, ref b, ref a);
            mainColor = Color.FromArgb(a, r, g, b);
        }


        public static SColor FromHudColor(HudColor color)
        {
            int r = 0, g = 0, b = 0, a = 0;
            API.GetHudColour((int)color, ref r, ref g, ref b, ref a);
            return FromArgb(a, r, g, b);
        }

        public static SColor FromArgb(int argb) => new(Color.FromArgb(argb));

        public static SColor FromArgb(int alpha, int red, int green, int blue) => new(Color.FromArgb(alpha, red, green, blue));

        public static SColor FromArgb(int alpha, Color baseColor) => new(Color.FromArgb(alpha, baseColor));

        public static SColor FromArgb(int red, int green, int blue) => FromArgb(byte.MaxValue, red, green, blue);

        public static SColor FromKnownColor(KnownColor color) => new(Color.FromKnownColor(color));

        public static SColor FromName(string name) => new(Color.FromName(name));
        public static SColor FromColor(Color color) => new(color);

        public float GetBrightness() => mainColor.GetBrightness();

        public float GetHue() => mainColor.GetHue();

        public float GetSaturation() => mainColor.GetSaturation();

        public int ArgbValue => ToArgb();
        public string HexValue => ToHex();
        public int ToArgb() => mainColor.ToArgb();
        public string ToHex() => $"#{mainColor.A:X2}{mainColor.R:X2}{mainColor.G:X2}{mainColor.B:X2}";
        public KnownColor ToKnownColor() => mainColor.ToKnownColor();
        public Color ToColor() => mainColor;

        public static bool operator ==(SColor left, SColor right) => left.mainColor == right.mainColor;

        public static bool operator !=(SColor left, SColor right) => !(left == right);

        public override bool Equals(object? obj) => obj is SColor other && Equals(other);

        public bool Equals(SColor other) => this == other;

        public override int GetHashCode()
        {
            return mainColor.GetHashCode();
        }
    }
}
