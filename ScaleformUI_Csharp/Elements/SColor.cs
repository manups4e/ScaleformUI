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

        public static readonly SColor Empty = new SColor();

        #region static list of "web" colors
        public static SColor Transparent => new SColor(KnownColor.Transparent);

        public static SColor AliceBlue => new SColor(KnownColor.AliceBlue);

        public static SColor AntiqueWhite => new SColor(KnownColor.AntiqueWhite);

        public static SColor Aqua => new SColor(KnownColor.Aqua);

        public static SColor Aquamarine => new SColor(KnownColor.Aquamarine);

        public static SColor Azure => new SColor(KnownColor.Azure);

        public static SColor Beige => new SColor(KnownColor.Beige);

        public static SColor Bisque => new SColor(KnownColor.Bisque);

        public static SColor Black => new SColor(KnownColor.Black);

        public static SColor BlanchedAlmond => new SColor(KnownColor.BlanchedAlmond);

        public static SColor Blue => new SColor(KnownColor.Blue);

        public static SColor BlueViolet => new SColor(KnownColor.BlueViolet);

        public static SColor Brown => new SColor(KnownColor.Brown);

        public static SColor BurlyWood => new SColor(KnownColor.BurlyWood);

        public static SColor CadetBlue => new SColor(KnownColor.CadetBlue);

        public static SColor Chartreuse => new SColor(KnownColor.Chartreuse);

        public static SColor Chocolate => new SColor(KnownColor.Chocolate);

        public static SColor Coral => new SColor(KnownColor.Coral);

        public static SColor CornflowerBlue => new SColor(KnownColor.CornflowerBlue);

        public static SColor Cornsilk => new SColor(KnownColor.Cornsilk);

        public static SColor Crimson => new SColor(KnownColor.Crimson);

        public static SColor Cyan => new SColor(KnownColor.Cyan);

        public static SColor DarkBlue => new SColor(KnownColor.DarkBlue);

        public static SColor DarkCyan => new SColor(KnownColor.DarkCyan);

        public static SColor DarkGoldenrod => new SColor(KnownColor.DarkGoldenrod);

        public static SColor DarkGray => new SColor(KnownColor.DarkGray);

        public static SColor DarkGreen => new SColor(KnownColor.DarkGreen);

        public static SColor DarkKhaki => new SColor(KnownColor.DarkKhaki);

        public static SColor DarkMagenta => new SColor(KnownColor.DarkMagenta);

        public static SColor DarkOliveGreen => new SColor(KnownColor.DarkOliveGreen);

        public static SColor DarkOrange => new SColor(KnownColor.DarkOrange);

        public static SColor DarkOrchid => new SColor(KnownColor.DarkOrchid);

        public static SColor DarkRed => new SColor(KnownColor.DarkRed);

        public static SColor DarkSalmon => new SColor(KnownColor.DarkSalmon);

        public static SColor DarkSeaGreen => new SColor(KnownColor.DarkSeaGreen);

        public static SColor DarkSlateBlue => new SColor(KnownColor.DarkSlateBlue);

        public static SColor DarkSlateGray => new SColor(KnownColor.DarkSlateGray);

        public static SColor DarkTurquoise => new SColor(KnownColor.DarkTurquoise);

        public static SColor DarkViolet => new SColor(KnownColor.DarkViolet);

        public static SColor DeepPink => new SColor(KnownColor.DeepPink);

        public static SColor DeepSkyBlue => new SColor(KnownColor.DeepSkyBlue);

        public static SColor DimGray => new SColor(KnownColor.DimGray);

        public static SColor DodgerBlue => new SColor(KnownColor.DodgerBlue);

        public static SColor Firebrick => new SColor(KnownColor.Firebrick);

        public static SColor FloralWhite => new SColor(KnownColor.FloralWhite);

        public static SColor ForestGreen => new SColor(KnownColor.ForestGreen);

        public static SColor Fuchsia => new SColor(KnownColor.Fuchsia);

        public static SColor Gainsboro => new SColor(KnownColor.Gainsboro);

        public static SColor GhostWhite => new SColor(KnownColor.GhostWhite);

        public static SColor Gold => new SColor(KnownColor.Gold);

        public static SColor Goldenrod => new SColor(KnownColor.Goldenrod);

        public static SColor Gray => new SColor(KnownColor.Gray);

        public static SColor Green => new SColor(KnownColor.Green);

        public static SColor GreenYellow => new SColor(KnownColor.GreenYellow);

        public static SColor Honeydew => new SColor(KnownColor.Honeydew);

        public static SColor HotPink => new SColor(KnownColor.HotPink);

        public static SColor IndianRed => new SColor(KnownColor.IndianRed);

        public static SColor Indigo => new SColor(KnownColor.Indigo);

        public static SColor Ivory => new SColor(KnownColor.Ivory);

        public static SColor Khaki => new SColor(KnownColor.Khaki);

        public static SColor Lavender => new SColor(KnownColor.Lavender);

        public static SColor LavenderBlush => new SColor(KnownColor.LavenderBlush);

        public static SColor LawnGreen => new SColor(KnownColor.LawnGreen);

        public static SColor LemonChiffon => new SColor(KnownColor.LemonChiffon);

        public static SColor LightBlue => new SColor(KnownColor.LightBlue);

        public static SColor LightCoral => new SColor(KnownColor.LightCoral);

        public static SColor LightCyan => new SColor(KnownColor.LightCyan);

        public static SColor LightGoldenrodYellow => new SColor(KnownColor.LightGoldenrodYellow);

        public static SColor LightGreen => new SColor(KnownColor.LightGreen);

        public static SColor LightGray => new SColor(KnownColor.LightGray);

        public static SColor LightPink => new SColor(KnownColor.LightPink);

        public static SColor LightSalmon => new SColor(KnownColor.LightSalmon);

        public static SColor LightSeaGreen => new SColor(KnownColor.LightSeaGreen);

        public static SColor LightSkyBlue => new SColor(KnownColor.LightSkyBlue);

        public static SColor LightSlateGray => new SColor(KnownColor.LightSlateGray);

        public static SColor LightSteelBlue => new SColor(KnownColor.LightSteelBlue);

        public static SColor LightYellow => new SColor(KnownColor.LightYellow);

        public static SColor Lime => new SColor(KnownColor.Lime);

        public static SColor LimeGreen => new SColor(KnownColor.LimeGreen);

        public static SColor Linen => new SColor(KnownColor.Linen);

        public static SColor Magenta => new SColor(KnownColor.Magenta);

        public static SColor Maroon => new SColor(KnownColor.Maroon);

        public static SColor MediumAquamarine => new SColor(KnownColor.MediumAquamarine);

        public static SColor MediumBlue => new SColor(KnownColor.MediumBlue);

        public static SColor MediumOrchid => new SColor(KnownColor.MediumOrchid);

        public static SColor MediumPurple => new SColor(KnownColor.MediumPurple);

        public static SColor MediumSeaGreen => new SColor(KnownColor.MediumSeaGreen);

        public static SColor MediumSlateBlue => new SColor(KnownColor.MediumSlateBlue);

        public static SColor MediumSpringGreen => new SColor(KnownColor.MediumSpringGreen);

        public static SColor MediumTurquoise => new SColor(KnownColor.MediumTurquoise);

        public static SColor MediumVioletRed => new SColor(KnownColor.MediumVioletRed);

        public static SColor MidnightBlue => new SColor(KnownColor.MidnightBlue);

        public static SColor MintCream => new SColor(KnownColor.MintCream);

        public static SColor MistyRose => new SColor(KnownColor.MistyRose);

        public static SColor Moccasin => new SColor(KnownColor.Moccasin);

        public static SColor NavajoWhite => new SColor(KnownColor.NavajoWhite);

        public static SColor Navy => new SColor(KnownColor.Navy);

        public static SColor OldLace => new SColor(KnownColor.OldLace);

        public static SColor Olive => new SColor(KnownColor.Olive);

        public static SColor OliveDrab => new SColor(KnownColor.OliveDrab);

        public static SColor Orange => new SColor(KnownColor.Orange);

        public static SColor OrangeRed => new SColor(KnownColor.OrangeRed);

        public static SColor Orchid => new SColor(KnownColor.Orchid);

        public static SColor PaleGoldenrod => new SColor(KnownColor.PaleGoldenrod);

        public static SColor PaleGreen => new SColor(KnownColor.PaleGreen);

        public static SColor PaleTurquoise => new SColor(KnownColor.PaleTurquoise);

        public static SColor PaleVioletRed => new SColor(KnownColor.PaleVioletRed);

        public static SColor PapayaWhip => new SColor(KnownColor.PapayaWhip);

        public static SColor PeachPuff => new SColor(KnownColor.PeachPuff);

        public static SColor Peru => new SColor(KnownColor.Peru);

        public static SColor Pink => new SColor(KnownColor.Pink);

        public static SColor Plum => new SColor(KnownColor.Plum);

        public static SColor PowderBlue => new SColor(KnownColor.PowderBlue);

        public static SColor Purple => new SColor(KnownColor.Purple);

        /// <summary>
        /// Gets a system-defined color that has an ARGB value of <c>#663399</c>.
        /// </summary>
        /// <value>A system-defined color.</value>
        public static SColor RebeccaPurple => new SColor("#663399");

        public static SColor Red => new SColor(KnownColor.Red);

        public static SColor RosyBrown => new SColor(KnownColor.RosyBrown);

        public static SColor RoyalBlue => new SColor(KnownColor.RoyalBlue);

        public static SColor SaddleBrown => new SColor(KnownColor.SaddleBrown);

        public static SColor Salmon => new SColor(KnownColor.Salmon);

        public static SColor SandyBrown => new SColor(KnownColor.SandyBrown);

        public static SColor SeaGreen => new SColor(KnownColor.SeaGreen);

        public static SColor SeaShell => new SColor(KnownColor.SeaShell);

        public static SColor Sienna => new SColor(KnownColor.Sienna);

        public static SColor Silver => new SColor(KnownColor.Silver);

        public static SColor SkyBlue => new SColor(KnownColor.SkyBlue);

        public static SColor SlateBlue => new SColor(KnownColor.SlateBlue);

        public static SColor SlateGray => new SColor(KnownColor.SlateGray);

        public static SColor Snow => new SColor(KnownColor.Snow);

        public static SColor SpringGreen => new SColor(KnownColor.SpringGreen);

        public static SColor SteelBlue => new SColor(KnownColor.SteelBlue);

        public static SColor Tan => new SColor(KnownColor.Tan);

        public static SColor Teal => new SColor(KnownColor.Teal);

        public static SColor Thistle => new SColor(KnownColor.Thistle);

        public static SColor Tomato => new SColor(KnownColor.Tomato);

        public static SColor Turquoise => new SColor(KnownColor.Turquoise);

        public static SColor Violet => new SColor(KnownColor.Violet);

        public static SColor Wheat => new SColor(KnownColor.Wheat);

        public static SColor White => new SColor(KnownColor.White);

        public static SColor WhiteSmoke => new SColor(KnownColor.WhiteSmoke);

        public static SColor Yellow => new SColor(KnownColor.Yellow);

        public static SColor YellowGreen => new SColor(KnownColor.YellowGreen);
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

        public static SColor FromArgb(int argb) => new SColor(Color.FromArgb(argb));

        public static SColor FromArgb(int alpha, int red, int green, int blue) => new SColor(Color.FromArgb(alpha, red, green, blue));

        public static SColor FromArgb(int alpha, Color baseColor) => new SColor(Color.FromArgb(alpha, baseColor));

        public static SColor FromArgb(int red, int green, int blue) => FromArgb(byte.MaxValue, red, green, blue);

        public static SColor FromKnownColor(KnownColor color) => new SColor(Color.FromKnownColor(color));

        public static SColor FromName(string name) => new SColor(Color.FromName(name));

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
