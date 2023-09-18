using CitizenFX.Core.Native;
using ScaleformUI.Scaleforms;
using System.Drawing;
using System.Runtime.CompilerServices;

namespace ScaleformUI.Elements
{
    public struct SColor
    {
        private const short StateKnownColorValid = 0x0001;
        private const short StateARGBValueValid = 0x0002;
        private const short StateValueMask = StateARGBValueValid;
        private const short StateNameValid = 0x0008;
        private const long NotDefinedValue = 0;
        // User supplied name of color. Will not be filled in if
        // we map to a "knowncolor"
        private readonly string? name; // Do not rename (binary serialization)

        // Standard 32bit sRGB (ARGB)
        private readonly long value; // Do not rename (binary serialization)

        // Ignored, unless "state" says it is valid
        private readonly short knownColor; // Do not rename (binary serialization)

        // State flags.
        private readonly short state; // Do not rename (binary serialization)
        internal const int ARGBAlphaShift = 24;
        internal const int ARGBRedShift = 16;
        internal const int ARGBGreenShift = 8;
        internal const int ARGBBlueShift = 0;
        internal const uint ARGBAlphaMask = 0xFFu << ARGBAlphaShift;
        internal const uint ARGBRedMask = 0xFFu << ARGBRedShift;
        internal const uint ARGBGreenMask = 0xFFu << ARGBGreenShift;
        internal const uint ARGBBlueMask = 0xFFu << ARGBBlueShift;

        public byte R => unchecked((byte)(Value >> ARGBRedShift));

        public byte G => unchecked((byte)(Value >> ARGBGreenShift));

        public byte B => unchecked((byte)(Value >> ARGBBlueShift));

        public byte A => unchecked((byte)(Value >> ARGBAlphaShift));

        public bool IsEmpty => state == 0;

        public static readonly SColor Empty = new();

        #region static list of "web" colors
        public static SColor Transparent => new(KnownColor.Transparent);

        public static SColor AliceBlue => new(KnownColor.AliceBlue);

        public static SColor AntiqueWhite => new(KnownColor.AntiqueWhite);

        public static SColor Aqua => new(KnownColor.Aqua);

        public static SColor Aquamarine => new(KnownColor.Aquamarine);

        public static SColor Azure => new(KnownColor.Azure);

        public static SColor Beige => new(KnownColor.Beige);

        public static SColor Bisque => new(KnownColor.Bisque);

        public static SColor Black => new(KnownColor.Black);

        public static SColor BlanchedAlmond => new(KnownColor.BlanchedAlmond);

        public static SColor Blue => new(KnownColor.Blue);

        public static SColor BlueViolet => new(KnownColor.BlueViolet);

        public static SColor Brown => new(KnownColor.Brown);

        public static SColor BurlyWood => new(KnownColor.BurlyWood);

        public static SColor CadetBlue => new(KnownColor.CadetBlue);

        public static SColor Chartreuse => new(KnownColor.Chartreuse);

        public static SColor Chocolate => new(KnownColor.Chocolate);

        public static SColor Coral => new(KnownColor.Coral);

        public static SColor CornflowerBlue => new(KnownColor.CornflowerBlue);

        public static SColor Cornsilk => new(KnownColor.Cornsilk);

        public static SColor Crimson => new(KnownColor.Crimson);

        public static SColor Cyan => new(KnownColor.Cyan);

        public static SColor DarkBlue => new(KnownColor.DarkBlue);

        public static SColor DarkCyan => new(KnownColor.DarkCyan);

        public static SColor DarkGoldenrod => new(KnownColor.DarkGoldenrod);

        public static SColor DarkGray => new(KnownColor.DarkGray);

        public static SColor DarkGreen => new(KnownColor.DarkGreen);

        public static SColor DarkKhaki => new(KnownColor.DarkKhaki);

        public static SColor DarkMagenta => new(KnownColor.DarkMagenta);

        public static SColor DarkOliveGreen => new(KnownColor.DarkOliveGreen);

        public static SColor DarkOrange => new(KnownColor.DarkOrange);

        public static SColor DarkOrchid => new(KnownColor.DarkOrchid);

        public static SColor DarkRed => new(KnownColor.DarkRed);

        public static SColor DarkSalmon => new(KnownColor.DarkSalmon);

        public static SColor DarkSeaGreen => new(KnownColor.DarkSeaGreen);

        public static SColor DarkSlateBlue => new(KnownColor.DarkSlateBlue);

        public static SColor DarkSlateGray => new(KnownColor.DarkSlateGray);

        public static SColor DarkTurquoise => new(KnownColor.DarkTurquoise);

        public static SColor DarkViolet => new(KnownColor.DarkViolet);

        public static SColor DeepPink => new(KnownColor.DeepPink);

        public static SColor DeepSkyBlue => new(KnownColor.DeepSkyBlue);

        public static SColor DimGray => new(KnownColor.DimGray);

        public static SColor DodgerBlue => new(KnownColor.DodgerBlue);

        public static SColor Firebrick => new(KnownColor.Firebrick);

        public static SColor FloralWhite => new(KnownColor.FloralWhite);

        public static SColor ForestGreen => new(KnownColor.ForestGreen);

        public static SColor Fuchsia => new(KnownColor.Fuchsia);

        public static SColor Gainsboro => new(KnownColor.Gainsboro);

        public static SColor GhostWhite => new(KnownColor.GhostWhite);

        public static SColor Gold => new(KnownColor.Gold);

        public static SColor Goldenrod => new(KnownColor.Goldenrod);

        public static SColor Gray => new(KnownColor.Gray);

        public static SColor Green => new(KnownColor.Green);

        public static SColor GreenYellow => new(KnownColor.GreenYellow);

        public static SColor Honeydew => new(KnownColor.Honeydew);

        public static SColor HotPink => new(KnownColor.HotPink);

        public static SColor IndianRed => new(KnownColor.IndianRed);

        public static SColor Indigo => new(KnownColor.Indigo);

        public static SColor Ivory => new(KnownColor.Ivory);

        public static SColor Khaki => new(KnownColor.Khaki);

        public static SColor Lavender => new(KnownColor.Lavender);

        public static SColor LavenderBlush => new(KnownColor.LavenderBlush);

        public static SColor LawnGreen => new(KnownColor.LawnGreen);

        public static SColor LemonChiffon => new(KnownColor.LemonChiffon);

        public static SColor LightBlue => new(KnownColor.LightBlue);

        public static SColor LightCoral => new(KnownColor.LightCoral);

        public static SColor LightCyan => new(KnownColor.LightCyan);

        public static SColor LightGoldenrodYellow => new(KnownColor.LightGoldenrodYellow);

        public static SColor LightGreen => new(KnownColor.LightGreen);

        public static SColor LightGray => new(KnownColor.LightGray);

        public static SColor LightPink => new(KnownColor.LightPink);

        public static SColor LightSalmon => new(KnownColor.LightSalmon);

        public static SColor LightSeaGreen => new(KnownColor.LightSeaGreen);

        public static SColor LightSkyBlue => new(KnownColor.LightSkyBlue);

        public static SColor LightSlateGray => new(KnownColor.LightSlateGray);

        public static SColor LightSteelBlue => new(KnownColor.LightSteelBlue);

        public static SColor LightYellow => new(KnownColor.LightYellow);

        public static SColor Lime => new(KnownColor.Lime);

        public static SColor LimeGreen => new(KnownColor.LimeGreen);

        public static SColor Linen => new(KnownColor.Linen);

        public static SColor Magenta => new(KnownColor.Magenta);

        public static SColor Maroon => new(KnownColor.Maroon);

        public static SColor MediumAquamarine => new(KnownColor.MediumAquamarine);

        public static SColor MediumBlue => new(KnownColor.MediumBlue);

        public static SColor MediumOrchid => new(KnownColor.MediumOrchid);

        public static SColor MediumPurple => new(KnownColor.MediumPurple);

        public static SColor MediumSeaGreen => new(KnownColor.MediumSeaGreen);

        public static SColor MediumSlateBlue => new(KnownColor.MediumSlateBlue);

        public static SColor MediumSpringGreen => new(KnownColor.MediumSpringGreen);

        public static SColor MediumTurquoise => new(KnownColor.MediumTurquoise);

        public static SColor MediumVioletRed => new(KnownColor.MediumVioletRed);

        public static SColor MidnightBlue => new(KnownColor.MidnightBlue);

        public static SColor MintCream => new(KnownColor.MintCream);

        public static SColor MistyRose => new(KnownColor.MistyRose);

        public static SColor Moccasin => new(KnownColor.Moccasin);

        public static SColor NavajoWhite => new(KnownColor.NavajoWhite);

        public static SColor Navy => new(KnownColor.Navy);

        public static SColor OldLace => new(KnownColor.OldLace);

        public static SColor Olive => new(KnownColor.Olive);

        public static SColor OliveDrab => new(KnownColor.OliveDrab);

        public static SColor Orange => new(KnownColor.Orange);

        public static SColor OrangeRed => new(KnownColor.OrangeRed);

        public static SColor Orchid => new(KnownColor.Orchid);

        public static SColor PaleGoldenrod => new(KnownColor.PaleGoldenrod);

        public static SColor PaleGreen => new(KnownColor.PaleGreen);

        public static SColor PaleTurquoise => new(KnownColor.PaleTurquoise);

        public static SColor PaleVioletRed => new(KnownColor.PaleVioletRed);

        public static SColor PapayaWhip => new(KnownColor.PapayaWhip);

        public static SColor PeachPuff => new(KnownColor.PeachPuff);

        public static SColor Peru => new(KnownColor.Peru);

        public static SColor Pink => new(KnownColor.Pink);

        public static SColor Plum => new(KnownColor.Plum);

        public static SColor PowderBlue => new(KnownColor.PowderBlue);

        public static SColor Purple => new(KnownColor.Purple);

        /// <summary>
        /// Gets a system-defined color that has an ARGB value of <c>#663399</c>.
        /// </summary>
        /// <value>A system-defined color.</value>
        public static SColor RebeccaPurple => new("#663399");

        public static SColor Red => new(KnownColor.Red);

        public static SColor RosyBrown => new(KnownColor.RosyBrown);

        public static SColor RoyalBlue => new(KnownColor.RoyalBlue);

        public static SColor SaddleBrown => new(KnownColor.SaddleBrown);

        public static SColor Salmon => new(KnownColor.Salmon);

        public static SColor SandyBrown => new(KnownColor.SandyBrown);

        public static SColor SeaGreen => new(KnownColor.SeaGreen);

        public static SColor SeaShell => new(KnownColor.SeaShell);

        public static SColor Sienna => new(KnownColor.Sienna);

        public static SColor Silver => new(KnownColor.Silver);

        public static SColor SkyBlue => new(KnownColor.SkyBlue);

        public static SColor SlateBlue => new(KnownColor.SlateBlue);

        public static SColor SlateGray => new(KnownColor.SlateGray);

        public static SColor Snow => new(KnownColor.Snow);

        public static SColor SpringGreen => new(KnownColor.SpringGreen);

        public static SColor SteelBlue => new(KnownColor.SteelBlue);

        public static SColor Tan => new(KnownColor.Tan);

        public static SColor Teal => new(KnownColor.Teal);

        public static SColor Thistle => new(KnownColor.Thistle);

        public static SColor Tomato => new(KnownColor.Tomato);

        public static SColor Turquoise => new(KnownColor.Turquoise);

        public static SColor Violet => new(KnownColor.Violet);

        public static SColor Wheat => new(KnownColor.Wheat);

        public static SColor White => new(KnownColor.White);

        public static SColor WhiteSmoke => new(KnownColor.WhiteSmoke);

        public static SColor Yellow => new(KnownColor.Yellow);

        public static SColor YellowGreen => new(KnownColor.YellowGreen);
        #endregion

        internal SColor(KnownColor knownColor)
        {
            value = 0;
            this.knownColor = unchecked((short)knownColor);
        }

        private long Value
        {
            get
            {
                if ((state & StateValueMask) != 0)
                {
                    return value;
                }
                return NotDefinedValue;
            }
        }

        private static void CheckByte(int value, string name)
        {
            if (unchecked((uint)value) > byte.MaxValue)
            {
                throw new Exception($"{(uint)value} can't be more than {byte.MaxValue}");
            }
        }

        public SColor(string hexColor)
        {
            if (hexColor.StartsWith("#"))
            {
                string argbHexString = hexColor.Substring(1);
                int argbValue = int.Parse(argbHexString, System.Globalization.NumberStyles.HexNumber);
                value = (uint)argbValue;
            }
            else throw new Exception("Invalid Hex value");
        }

        public SColor(Color color)
        {
            this.value = (uint)color.ToArgb();
        }

        public SColor(HudColor color)
        {
            this.value = (uint)FromHudColor(color).ArgbValue;
        }


        public static SColor FromHudColor(HudColor color)
        {
            int r = 0, g = 0, b = 0, a = 0;
            API.GetHudColour((int)color, ref r, ref g, ref b, ref a);
            CheckByte(a, nameof(a));
            CheckByte(r, nameof(r));
            CheckByte(g, nameof(g));
            CheckByte(b, nameof(b));

            return FromArgb(a, r, g, b);
        }

        public static SColor FromArgb(int argb) => new(Color.FromArgb(argb));

        public static SColor FromArgb(int alpha, int red, int green, int blue) => new(Color.FromArgb(alpha, red, green, blue));

        public static SColor FromArgb(int alpha, Color baseColor) => new(Color.FromArgb(alpha, baseColor));

        public static SColor FromArgb(int red, int green, int blue) => FromArgb(byte.MaxValue, red, green, blue);

        public static SColor FromKnownColor(KnownColor color) => new(Color.FromKnownColor(color));

        public static SColor FromName(string name) => new(Color.FromName(name));
        public static SColor FromColor(Color color) => new(color);

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private void GetRgbValues(out int r, out int g, out int b)
        {
            uint value = (uint)Value;
            r = (int)(value & ARGBRedMask) >> ARGBRedShift;
            g = (int)(value & ARGBGreenMask) >> ARGBGreenShift;
            b = (int)(value & ARGBBlueMask) >> ARGBBlueShift;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        private static void MinMaxRgb(out int min, out int max, int r, int g, int b)
        {
            if (r > g)
            {
                max = r;
                min = g;
            }
            else
            {
                max = g;
                min = r;
            }
            if (b > max)
            {
                max = b;
            }
            else if (b < min)
            {
                min = b;
            }
        }

        public float GetBrightness()
        {
            GetRgbValues(out int r, out int g, out int b);

            MinMaxRgb(out int min, out int max, r, g, b);

            return (max + min) / (byte.MaxValue * 2f);
        }

        public float GetHue()
        {
            GetRgbValues(out int r, out int g, out int b);

            if (r == g && g == b)
                return 0f;

            MinMaxRgb(out int min, out int max, r, g, b);

            float delta = max - min;
            float hue;

            if (r == max)
                hue = (g - b) / delta;
            else if (g == max)
                hue = (b - r) / delta + 2f;
            else
                hue = (r - g) / delta + 4f;

            hue *= 60f;
            if (hue < 0f)
                hue += 360f;

            return hue;
        }

        public float GetSaturation()
        {
            GetRgbValues(out int r, out int g, out int b);

            if (r == g && g == b)
                return 0f;

            MinMaxRgb(out int min, out int max, r, g, b);

            int div = max + min;
            if (div > byte.MaxValue)
                div = byte.MaxValue * 2 - max - min;

            return (max - min) / (float)div;
        }

        public int ArgbValue => ToArgb();
        public string HexValue => ToHex();
        public int ToArgb() => unchecked((int)Value);
        public string ToHex() => $"#{A:X2}{R:X2}{G:X2}{B:X2}";
        public KnownColor ToKnownColor() => (KnownColor)knownColor;

        public static bool operator ==(SColor left, SColor right) =>
            left.value == right.value
                && left.state == right.state
                && left.knownColor == right.knownColor
                && left.name == right.name;

        public static bool operator !=(SColor left, SColor right) => !(left == right);

        public override bool Equals(object? obj) => obj is SColor other && Equals(other);

        public bool Equals(SColor other) => this == other;

        public override int GetHashCode()
        {
            int hashCode = -1427721709;
            hashCode = hashCode * -1521134295 + EqualityComparer<string?>.Default.GetHashCode(name);
            hashCode = hashCode * -1521134295 + value.GetHashCode();
            hashCode = hashCode * -1521134295 + knownColor.GetHashCode();
            return hashCode;
        }
    }
}
