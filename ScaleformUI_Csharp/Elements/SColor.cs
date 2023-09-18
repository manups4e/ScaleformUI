using CitizenFX.Core.Native;
using ScaleformUI.Scaleforms;
using System.Drawing;

namespace ScaleformUI.Elements
{
    public struct SColor
    {
        private readonly Color mainColor;
        public static readonly SColor Transparent = FromArgb(16777215);
        public static readonly SColor AliceBlue = FromArgb(-984833);
        public static readonly SColor AntiqueWhite = FromArgb(-332841);
        public static readonly SColor Aqua = FromArgb(-16711681);
        public static readonly SColor Aquamarine = FromArgb(-8388652);
        public static readonly SColor Azure = FromArgb(-983041);
        public static readonly SColor Beige = FromArgb(-657956);
        public static readonly SColor Bisque = FromArgb(-6972);
        public static readonly SColor Black = FromArgb(-16777216);
        public static readonly SColor BlanchedAlmond = FromArgb(-5171);
        public static readonly SColor Blue = FromArgb(-16776961);
        public static readonly SColor BlueViolet = FromArgb(-7722014);
        public static readonly SColor Brown = FromArgb(-5952982);
        public static readonly SColor BurlyWood = FromArgb(-2180985);
        public static readonly SColor CadetBlue = FromArgb(-10510688);
        public static readonly SColor Chartreuse = FromArgb(-8388864);
        public static readonly SColor Chocolate = FromArgb(-2987746);
        public static readonly SColor Coral = FromArgb(-32944);
        public static readonly SColor CornflowerBlue = FromArgb(-10185235);
        public static readonly SColor Cornsilk = FromArgb(-1828);
        public static readonly SColor Crimson = FromArgb(-2354116);
        public static readonly SColor Cyan = FromArgb(-16711681);
        public static readonly SColor DarkBlue = FromArgb(-16777077);
        public static readonly SColor DarkCyan = FromArgb(-16741493);
        public static readonly SColor DarkGoldenrod = FromArgb(-4684277);
        public static readonly SColor DarkGray = FromArgb(-5658199);
        public static readonly SColor DarkGreen = FromArgb(-16751616);
        public static readonly SColor DarkKhaki = FromArgb(-4343957);
        public static readonly SColor DarkMagenta = FromArgb(-7667573);
        public static readonly SColor DarkOliveGreen = FromArgb(-11179217);
        public static readonly SColor DarkOrange = FromArgb(-29696);
        public static readonly SColor DarkOrchid = FromArgb(-6737204);
        public static readonly SColor DarkRed = FromArgb(-7667712);
        public static readonly SColor DarkSalmon = FromArgb(-1468806);
        public static readonly SColor DarkSeaGreen = FromArgb(-7357301);
        public static readonly SColor DarkSlateBlue = FromArgb(-12042869);
        public static readonly SColor DarkSlateGray = FromArgb(-13676721);
        public static readonly SColor DarkTurquoise = FromArgb(-16724271);
        public static readonly SColor DarkViolet = FromArgb(-7077677);
        public static readonly SColor DeepPink = FromArgb(-60269);
        public static readonly SColor DeepSkyBlue = FromArgb(-16728065);
        public static readonly SColor DimGray = FromArgb(-9868951);
        public static readonly SColor DodgerBlue = FromArgb(-14774017);
        public static readonly SColor Firebrick = FromArgb(-5103070);
        public static readonly SColor FloralWhite = FromArgb(-1296);
        public static readonly SColor ForestGreen = FromArgb(-14513374);
        public static readonly SColor Fuchsia = FromArgb(-65281);
        public static readonly SColor Gainsboro = FromArgb(-2302756);
        public static readonly SColor GhostWhite = FromArgb(-460545);
        public static readonly SColor Gold = FromArgb(-10496);
        public static readonly SColor Goldenrod = FromArgb(-2448096);
        public static readonly SColor Gray = FromArgb(-8355712);
        public static readonly SColor Green = FromArgb(-16744448);
        public static readonly SColor GreenYellow = FromArgb(-5374161);
        public static readonly SColor Honeydew = FromArgb(-983056);
        public static readonly SColor HotPink = FromArgb(-38476);
        public static readonly SColor IndianRed = FromArgb(-3318692);
        public static readonly SColor Indigo = FromArgb(-11861886);
        public static readonly SColor Ivory = FromArgb(-16);
        public static readonly SColor Khaki = FromArgb(-989556);
        public static readonly SColor Lavender = FromArgb(-1644806);
        public static readonly SColor LavenderBlush = FromArgb(-3851);
        public static readonly SColor LawnGreen = FromArgb(-8586240);
        public static readonly SColor LemonChiffon = FromArgb(-1331);
        public static readonly SColor LightBlue = FromArgb(-5383962);
        public static readonly SColor LightCoral = FromArgb(-1015680);
        public static readonly SColor LightCyan = FromArgb(-2031617);
        public static readonly SColor LightGoldenrodYellow = FromArgb(-329006);
        public static readonly SColor LightGreen = FromArgb(-7278960);
        public static readonly SColor LightGray = FromArgb(-2894893);
        public static readonly SColor LightPink = FromArgb(-18751);
        public static readonly SColor LightSalmon = FromArgb(-24454);
        public static readonly SColor LightSeaGreen = FromArgb(-14634326);
        public static readonly SColor LightSkyBlue = FromArgb(-7876870);
        public static readonly SColor LightSlateGray = FromArgb(-8943463);
        public static readonly SColor LightSteelBlue = FromArgb(-5192482);
        public static readonly SColor LightYellow = FromArgb(-32);
        public static readonly SColor Lime = FromArgb(-16711936);
        public static readonly SColor LimeGreen = FromArgb(-13447886);
        public static readonly SColor Linen = FromArgb(-331546);
        public static readonly SColor Magenta = FromArgb(-65281);
        public static readonly SColor Maroon = FromArgb(-8388608);
        public static readonly SColor MediumAquamarine = FromArgb(-10039894);
        public static readonly SColor MediumBlue = FromArgb(-16777011);
        public static readonly SColor MediumOrchid = FromArgb(-4565549);
        public static readonly SColor MediumPurple = FromArgb(-7114533);
        public static readonly SColor MediumSeaGreen = FromArgb(-12799119);
        public static readonly SColor MediumSlateBlue = FromArgb(-8689426);
        public static readonly SColor MediumSpringGreen = FromArgb(-16713062);
        public static readonly SColor MediumTurquoise = FromArgb(-12004916);
        public static readonly SColor MediumVioletRed = FromArgb(-3730043);
        public static readonly SColor MidnightBlue = FromArgb(-15132304);
        public static readonly SColor MintCream = FromArgb(-655366);
        public static readonly SColor MistyRose = FromArgb(-6943);
        public static readonly SColor Moccasin = FromArgb(-6987);
        public static readonly SColor NavajoWhite = FromArgb(-8531);
        public static readonly SColor Navy = FromArgb(-16777088);
        public static readonly SColor OldLace = FromArgb(-133658);
        public static readonly SColor Olive = FromArgb(-8355840);
        public static readonly SColor OliveDrab = FromArgb(-9728477);
        public static readonly SColor Orange = FromArgb(-23296);
        public static readonly SColor OrangeRed = FromArgb(-47872);
        public static readonly SColor Orchid = FromArgb(-2461482);
        public static readonly SColor PaleGoldenrod = FromArgb(-1120086);
        public static readonly SColor PaleGreen = FromArgb(-6751336);
        public static readonly SColor PaleTurquoise = FromArgb(-5247250);
        public static readonly SColor PaleVioletRed = FromArgb(-2396013);
        public static readonly SColor PapayaWhip = FromArgb(-4139);
        public static readonly SColor PeachPuff = FromArgb(-9543);
        public static readonly SColor Peru = FromArgb(-3308225);
        public static readonly SColor Pink = FromArgb(-16181);
        public static readonly SColor Plum = FromArgb(-2252579);
        public static readonly SColor PowderBlue = FromArgb(-5185306);
        public static readonly SColor Purple = FromArgb(-8388480);
        public static readonly SColor Red = FromArgb(-65536);
        public static readonly SColor RosyBrown = FromArgb(-4419697);
        public static readonly SColor RoyalBlue = FromArgb(-12490271);
        public static readonly SColor SaddleBrown = FromArgb(-7650029);
        public static readonly SColor Salmon = FromArgb(-360334);
        public static readonly SColor SandyBrown = FromArgb(-744352);
        public static readonly SColor SeaGreen = FromArgb(-13726889);
        public static readonly SColor SeaShell = FromArgb(-2578);
        public static readonly SColor Sienna = FromArgb(-6270419);
        public static readonly SColor Silver = FromArgb(-4144960);
        public static readonly SColor SkyBlue = FromArgb(-7876885);
        public static readonly SColor SlateBlue = FromArgb(-9807155);
        public static readonly SColor SlateGray = FromArgb(-9404272);
        public static readonly SColor Snow = FromArgb(-1286);
        public static readonly SColor SpringGreen = FromArgb(-16711809);
        public static readonly SColor SteelBlue = FromArgb(-12156236);
        public static readonly SColor Tan = FromArgb(-2968436);
        public static readonly SColor Teal = FromArgb(-16744320);
        public static readonly SColor Thistle = FromArgb(-2572328);
        public static readonly SColor Tomato = FromArgb(-40121);
        public static readonly SColor Turquoise = FromArgb(-12525360);
        public static readonly SColor Violet = FromArgb(-1146130);
        public static readonly SColor Wheat = FromArgb(-663885);
        public static readonly SColor White = FromArgb(-1);
        public static readonly SColor WhiteSmoke = FromArgb(-657931);
        public static readonly SColor Yellow = FromArgb(-256);
        public static readonly SColor YellowGreen = FromArgb(-6632142);
        public static readonly SColor Grey = FromArgb(255, 155, 155, 155);
        public static readonly SColor GreyLight = FromArgb(255, 205, 205, 205);
        public static readonly SColor GreyDark = FromArgb(255, 77, 77, 77);
        public static readonly SColor RedLight = FromArgb(255, 240, 153, 153);
        public static readonly SColor RedDark = FromArgb(255, 112, 25, 25);
        public static readonly SColor BlueLight = FromArgb(255, 174, 219, 242);
        public static readonly SColor BlueDark = FromArgb(255, 47, 92, 115);
        public static readonly SColor YellowLight = FromArgb(255, 254, 235, 169);
        public static readonly SColor YellowDark = FromArgb(255, 126, 107, 41);
        public static readonly SColor OrangeLight = FromArgb(255, 255, 194, 170);
        public static readonly SColor OrangeDark = FromArgb(255, 127, 66, 42);
        public static readonly SColor GreenLight = FromArgb(255, 185, 230, 185);
        public static readonly SColor GreenDark = FromArgb(255, 57, 102, 57);
        public static readonly SColor PurpleLight = FromArgb(255, 192, 179, 239);
        public static readonly SColor PurpleDark = FromArgb(255, 67, 57, 111);
        public static readonly SColor RadarHealth = FromArgb(255, 53, 154, 71);
        public static readonly SColor RadarArmour = FromArgb(255, 93, 182, 229);
        public static readonly SColor RadarDamage = FromArgb(255, 235, 36, 39);
        public static readonly SColor NetPlayer1 = FromArgb(255, 194, 80, 80);
        public static readonly SColor NetPlayer2 = FromArgb(255, 156, 110, 175);
        public static readonly SColor NetPlayer3 = FromArgb(255, 255, 123, 196);
        public static readonly SColor NetPlayer4 = FromArgb(255, 247, 159, 123);
        public static readonly SColor NetPlayer5 = FromArgb(255, 178, 144, 132);
        public static readonly SColor NetPlayer6 = FromArgb(255, 141, 206, 167);
        public static readonly SColor NetPlayer7 = FromArgb(255, 113, 169, 175);
        public static readonly SColor NetPlayer8 = FromArgb(255, 211, 209, 231);
        public static readonly SColor NetPlayer9 = FromArgb(255, 144, 127, 153);
        public static readonly SColor NetPlayer10 = FromArgb(255, 106, 196, 191);
        public static readonly SColor NetPlayer11 = FromArgb(255, 214, 196, 153);
        public static readonly SColor NetPlayer12 = FromArgb(255, 234, 142, 80);
        public static readonly SColor NetPlayer13 = FromArgb(255, 152, 203, 234);
        public static readonly SColor NetPlayer14 = FromArgb(255, 178, 98, 135);
        public static readonly SColor NetPlayer15 = FromArgb(255, 144, 142, 122);
        public static readonly SColor NetPlayer16 = FromArgb(255, 166, 117, 94);
        public static readonly SColor NetPlayer17 = FromArgb(255, 175, 168, 168);
        public static readonly SColor NetPlayer18 = FromArgb(255, 232, 142, 155);
        public static readonly SColor NetPlayer19 = FromArgb(255, 187, 214, 91);
        public static readonly SColor NetPlayer20 = FromArgb(255, 12, 123, 86);
        public static readonly SColor NetPlayer21 = FromArgb(255, 123, 196, 255);
        public static readonly SColor NetPlayer22 = FromArgb(255, 171, 60, 230);
        public static readonly SColor NetPlayer23 = FromArgb(255, 206, 169, 13);
        public static readonly SColor NetPlayer24 = FromArgb(255, 71, 99, 173);
        public static readonly SColor NetPlayer25 = FromArgb(255, 42, 166, 185);
        public static readonly SColor NetPlayer26 = FromArgb(255, 186, 157, 125);
        public static readonly SColor NetPlayer27 = FromArgb(255, 201, 225, 255);
        public static readonly SColor NetPlayer28 = FromArgb(255, 240, 240, 150);
        public static readonly SColor NetPlayer29 = FromArgb(255, 237, 140, 161);
        public static readonly SColor NetPlayer30 = FromArgb(255, 249, 138, 138);
        public static readonly SColor NetPlayer31 = FromArgb(255, 252, 239, 166);
        public static readonly SColor NetPlayer32 = FromArgb(255, 240, 240, 240);
        public static readonly SColor SimpleBlipDefault = FromArgb(255, 159, 201, 166);
        public static readonly SColor MenuBlue = FromArgb(255, 140, 140, 140);
        public static readonly SColor MenuGreyLight = FromArgb(255, 140, 140, 140);
        public static readonly SColor MenuBlueExtraDark = FromArgb(255, 40, 40, 40);
        public static readonly SColor MenuYellow = FromArgb(255, 240, 160, 0);
        public static readonly SColor MenuYellowDark = FromArgb(255, 240, 160, 0);
        public static readonly SColor MenuGreen = FromArgb(255, 240, 160, 0);
        public static readonly SColor MenuGrey = FromArgb(255, 140, 140, 140);
        public static readonly SColor MenuGreyDark = FromArgb(255, 60, 60, 60);
        public static readonly SColor MenuHighlight = FromArgb(255, 30, 30, 30);
        public static readonly SColor MenuStandard = FromArgb(255, 140, 140, 140);
        public static readonly SColor MenuDimmed = FromArgb(255, 75, 75, 75);
        public static readonly SColor MenuExtraDimmed = FromArgb(255, 50, 50, 50);
        public static readonly SColor BriefTitle = FromArgb(255, 95, 95, 95);
        public static readonly SColor MidGreyMp = FromArgb(255, 100, 100, 100);
        public static readonly SColor NetPlayer1Dark = FromArgb(255, 93, 39, 39);
        public static readonly SColor NetPlayer2Dark = FromArgb(255, 77, 55, 89);
        public static readonly SColor NetPlayer3Dark = FromArgb(255, 124, 62, 99);
        public static readonly SColor NetPlayer4Dark = FromArgb(255, 120, 80, 80);
        public static readonly SColor NetPlayer5Dark = FromArgb(255, 87, 72, 66);
        public static readonly SColor NetPlayer6Dark = FromArgb(255, 74, 103, 83);
        public static readonly SColor NetPlayer7Dark = FromArgb(255, 60, 85, 88);
        public static readonly SColor NetPlayer8Dark = FromArgb(255, 105, 105, 64);
        public static readonly SColor NetPlayer9Dark = FromArgb(255, 72, 63, 76);
        public static readonly SColor NetPlayer10Dark = FromArgb(255, 53, 98, 95);
        public static readonly SColor NetPlayer11Dark = FromArgb(255, 107, 98, 76);
        public static readonly SColor NetPlayer12Dark = FromArgb(255, 117, 71, 40);
        public static readonly SColor NetPlayer13Dark = FromArgb(255, 76, 101, 117);
        public static readonly SColor NetPlayer14Dark = FromArgb(255, 65, 35, 47);
        public static readonly SColor NetPlayer15Dark = FromArgb(255, 72, 71, 61);
        public static readonly SColor NetPlayer16Dark = FromArgb(255, 85, 58, 47);
        public static readonly SColor NetPlayer17Dark = FromArgb(255, 87, 84, 84);
        public static readonly SColor NetPlayer18Dark = FromArgb(255, 116, 71, 77);
        public static readonly SColor NetPlayer19Dark = FromArgb(255, 93, 107, 45);
        public static readonly SColor NetPlayer20Dark = FromArgb(255, 6, 61, 43);
        public static readonly SColor NetPlayer21Dark = FromArgb(255, 61, 98, 127);
        public static readonly SColor NetPlayer22Dark = FromArgb(255, 85, 30, 115);
        public static readonly SColor NetPlayer23Dark = FromArgb(255, 103, 84, 6);
        public static readonly SColor NetPlayer24Dark = FromArgb(255, 35, 49, 86);
        public static readonly SColor NetPlayer25Dark = FromArgb(255, 21, 83, 92);
        public static readonly SColor NetPlayer26Dark = FromArgb(255, 93, 98, 62);
        public static readonly SColor NetPlayer27Dark = FromArgb(255, 100, 112, 127);
        public static readonly SColor NetPlayer28Dark = FromArgb(255, 120, 120, 75);
        public static readonly SColor NetPlayer29Dark = FromArgb(255, 152, 76, 93);
        public static readonly SColor NetPlayer30Dark = FromArgb(255, 124, 69, 69);
        public static readonly SColor NetPlayer31Dark = FromArgb(255, 10, 43, 50);
        public static readonly SColor NetPlayer32Dark = FromArgb(255, 95, 95, 10);
        public static readonly SColor Bronze = FromArgb(255, 180, 130, 97);
        public static readonly SColor Platinum = FromArgb(255, 166, 221, 190);
        public static readonly SColor Gang1 = FromArgb(255, 29, 100, 153);
        public static readonly SColor Gang2 = FromArgb(255, 214, 116, 15);
        public static readonly SColor Gang3 = FromArgb(255, 135, 125, 142);
        public static readonly SColor Gang4 = FromArgb(255, 229, 119, 185);
        public static readonly SColor SameCrew = FromArgb(255, 252, 239, 166);
        public static readonly SColor Freemode = FromArgb(255, 45, 110, 185);
        public static readonly SColor PauseBg = FromArgb(255, 0, 0, 0);
        public static readonly SColor Friendly = FromArgb(255, 93, 182, 229);
        public static readonly SColor Enemy = FromArgb(255, 194, 80, 80);
        public static readonly SColor Location = FromArgb(255, 240, 200, 80);
        public static readonly SColor Pickup = FromArgb(255, 114, 204, 114);
        public static readonly SColor PauseSingleplayer = FromArgb(255, 114, 204, 114);
        public static readonly SColor FreemodeDark = FromArgb(255, 22, 55, 92);
        public static readonly SColor InactiveMission = FromArgb(255, 154, 154, 154);
        public static readonly SColor Damage = FromArgb(255, 194, 80, 80);
        public static readonly SColor PinkLight = FromArgb(255, 252, 115, 201);
        public static readonly SColor PmMitemHighlight = FromArgb(255, 252, 177, 49);
        public static readonly SColor ScriptVariable = FromArgb(255, 0, 0, 0);
        public static readonly SColor Yoga = FromArgb(255, 109, 247, 204);
        public static readonly SColor Tennis = FromArgb(255, 241, 101, 34);
        public static readonly SColor Golf = FromArgb(255, 214, 189, 97);
        public static readonly SColor ShootingRange = FromArgb(255, 112, 25, 25);
        public static readonly SColor FlightSchool = FromArgb(255, 47, 92, 115);
        public static readonly SColor NorthBlue = FromArgb(255, 93, 182, 229);
        public static readonly SColor SocialClub = FromArgb(255, 234, 153, 28);
        public static readonly SColor PlatformBlue = FromArgb(255, 11, 55, 123);
        public static readonly SColor PlatformGreen = FromArgb(255, 146, 200, 62);
        public static readonly SColor PlatformGrey = FromArgb(255, 234, 153, 28);
        public static readonly SColor FacebookBlue = FromArgb(255, 66, 89, 148);
        public static readonly SColor IngameBg = FromArgb(255, 0, 0, 0);
        public static readonly SColor Darts = FromArgb(255, 114, 204, 114);
        public static readonly SColor Waypoint = FromArgb(255, 164, 76, 242);
        public static readonly SColor Michael = FromArgb(255, 101, 180, 212);
        public static readonly SColor Franklin = FromArgb(255, 171, 237, 171);
        public static readonly SColor Trevor = FromArgb(255, 255, 163, 87);
        public static readonly SColor GolfP1 = FromArgb(255, 240, 240, 240);
        public static readonly SColor GolfP2 = FromArgb(255, 235, 239, 30);
        public static readonly SColor GolfP3 = FromArgb(255, 255, 149, 14);
        public static readonly SColor GolfP4 = FromArgb(255, 246, 60, 161);
        public static readonly SColor WaypointLight = FromArgb(255, 210, 166, 249);
        public static readonly SColor WaypointDark = FromArgb(255, 82, 38, 121);
        public static readonly SColor PanelLight = FromArgb(255, 0, 0, 0);
        public static readonly SColor MichaelDark = FromArgb(255, 72, 103, 116);
        public static readonly SColor FranklinDark = FromArgb(255, 85, 118, 85);
        public static readonly SColor TrevorDark = FromArgb(255, 127, 81, 43);
        public static readonly SColor ObjectiveRoute = FromArgb(255, 240, 200, 80);
        public static readonly SColor PausemapTint = FromArgb(255, 0, 0, 0);
        public static readonly SColor PauseDeselect = FromArgb(255, 100, 100, 100);
        public static readonly SColor PmWeaponsPurchasable = FromArgb(255, 45, 110, 185);
        public static readonly SColor PmWeaponsLocked = FromArgb(255, 240, 240, 240);
        public static readonly SColor EndScreenBg = FromArgb(255, 0, 0, 0);
        public static readonly SColor Chop = FromArgb(255, 224, 50, 50);
        public static readonly SColor PausemapTintHalf = FromArgb(255, 0, 0, 0);
        public static readonly SColor NorthBlueOfficial = FromArgb(255, 0, 71, 133);
        public static readonly SColor ScriptVariable2 = FromArgb(255, 0, 0, 0);
        public static readonly SColor H = FromArgb(255, 33, 118, 37);
        public static readonly SColor HDark = FromArgb(255, 37, 102, 40);
        public static readonly SColor T = FromArgb(255, 234, 153, 28);
        public static readonly SColor TDark = FromArgb(255, 225, 140, 8);
        public static readonly SColor HShard = FromArgb(255, 20, 40, 0);
        public static readonly SColor ControllerMichael = FromArgb(255, 48, 255, 255);
        public static readonly SColor ControllerFranklin = FromArgb(255, 48, 255, 0);
        public static readonly SColor ControllerTrevor = FromArgb(255, 176, 80, 0);
        public static readonly SColor ControllerChop = FromArgb(255, 127, 0, 0);
        public static readonly SColor VideoEditorVideo = FromArgb(255, 53, 166, 224);
        public static readonly SColor VideoEditorAudio = FromArgb(255, 162, 79, 157);
        public static readonly SColor VideoEditorText = FromArgb(255, 104, 192, 141);
        public static readonly SColor HbBlue = FromArgb(255, 29, 100, 153);
        public static readonly SColor HbYellow = FromArgb(255, 234, 153, 28);
        public static readonly SColor VideoEditorScore = FromArgb(255, 240, 160, 1);
        public static readonly SColor VideoEditorAudioFadeout = FromArgb(255, 59, 34, 57);
        public static readonly SColor VideoEditorTextFadeout = FromArgb(255, 41, 68, 53);
        public static readonly SColor VideoEditorScoreFadeout = FromArgb(255, 82, 58, 10);
        public static readonly SColor HeistBackground = FromArgb(255, 37, 102, 40);
        public static readonly SColor VideoEditorAmbient = FromArgb(255, 240, 200, 80);
        public static readonly SColor VideoEditorAmbientFadeout = FromArgb(255, 80, 70, 34);
        public static readonly SColor Gb = FromArgb(255, 255, 133, 85);
        public static readonly SColor G = FromArgb(255, 255, 194, 170);
        public static readonly SColor B = FromArgb(255, 255, 133, 85);
        public static readonly SColor LowFlow = FromArgb(255, 240, 200, 80);
        public static readonly SColor LowFlowDark = FromArgb(255, 126, 107, 41);
        public static readonly SColor G1 = FromArgb(255, 247, 159, 123);
        public static readonly SColor G2 = FromArgb(255, 226, 134, 187);
        public static readonly SColor G3 = FromArgb(255, 239, 238, 151);
        public static readonly SColor G4 = FromArgb(255, 113, 169, 175);
        public static readonly SColor G5 = FromArgb(255, 160, 140, 193);
        public static readonly SColor G6 = FromArgb(255, 141, 206, 167);
        public static readonly SColor G7 = FromArgb(255, 181, 214, 234);
        public static readonly SColor G8 = FromArgb(255, 178, 144, 132);
        public static readonly SColor G9 = FromArgb(255, 0, 132, 114);
        public static readonly SColor G10 = FromArgb(255, 216, 85, 117);
        public static readonly SColor G11 = FromArgb(255, 30, 100, 152);
        public static readonly SColor G12 = FromArgb(255, 43, 181, 117);
        public static readonly SColor G13 = FromArgb(255, 233, 141, 79);
        public static readonly SColor G14 = FromArgb(255, 137, 210, 215);
        public static readonly SColor G15 = FromArgb(255, 134, 125, 141);
        public static readonly SColor Adversary = FromArgb(255, 109, 34, 33);
        public static readonly SColor DegenRed = FromArgb(255, 255, 0, 0);
        public static readonly SColor DegenYellow = FromArgb(255, 255, 255, 0);
        public static readonly SColor DegenGreen = FromArgb(255, 0, 255, 0);
        public static readonly SColor DegenCyan = FromArgb(255, 0, 255, 255);
        public static readonly SColor DegenBlue = FromArgb(255, 0, 0, 255);
        public static readonly SColor DegenMagenta = FromArgb(255, 255, 0, 255);
        public static readonly SColor Stunt1 = FromArgb(255, 38, 136, 234);
        public static readonly SColor Stunt2 = FromArgb(255, 224, 50, 50);
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
