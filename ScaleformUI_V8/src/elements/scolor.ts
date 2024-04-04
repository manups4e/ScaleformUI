import { HudColor } from './color';

export class SColor {
    private a: number;
    private r: number;
    private g: number;
    private b: number;

    private constructor(a: number, r: number, g: number, b: number) {
        this.a = a;
        this.r = r;
        this.g = g;
        this.b = b;
    }

    get A(): number {
        return this.a;
    }

    get B(): number {
        return this.b;
    }

    get G(): number {
        return this.g;
    }

    get R(): number {
        return this.r;
    }

    public static FromHex(hexColor: string): SColor{
        if (typeof hexColor === 'string') {
            if (hexColor.startsWith("#")) {
                let hex = hexColor.replace('#', '') // Remove "#" symbol if present
                let a = GetRandomIntInRange(1, 255);
                let r = parseInt(hex.slice(2, 4), 16) // Convert next two characters to decimal (red channel)
                let g = parseInt(hex.slice(4, 6), 16) // Convert next two characters to decimal (green channel)
                let b = parseInt(hex.slice(6, 8), 16) // Convert last two characters to decimal (blue channel)
                return new SColor(a,r,g,b);
            } else {
                throw new Error("Invalid Hex value");
            }
        }
        return new SColor(0, 0, 0, 0);
    }

    public static FromHudColor(color: HudColor): SColor{
        if (Object.values(HudColor).includes(color)) {
            const [r, g, b, a]: [number, number, number, number] = GetHudColour(color);
            return new SColor(a,r,g,b);
        } else {
            throw new Error("Invalid argument type");
        }
    }

    public static FromRandomValues(): SColor{
        let a = 255;
        let r = GetRandomIntInRange(1, 255);
        let g = GetRandomIntInRange(1, 255);
        let b = GetRandomIntInRange(1, 255);
        return new SColor(a,r,g,b);
    }

    public static FromArgb(argb: number): SColor {
        let isNegative = false;
        if (argb < 0) {
            isNegative = true;
            argb = Math.abs(argb); // Convert negative value to positive
        }
        
        let a = (argb >> 24) & 255;
        let r = (argb >> 16) & 255;
        let g = (argb >> 8) & 255;
        let b = argb & 255;
        
        if (isNegative) {
            a = 255 - a;
            r = 255 - r;
            g = 255 - g;
            b = 255 - b;
        }
        return new SColor(a,r,g,b);
    }

    public static FromArgb(alpha: number, red: number, green: number, blue: number): SColor {
        return new SColor(alpha,red,green,blue);
    }

    public static FromArgb(red: number, green: number, blue: number): SColor {
        return SColor.FromArgb(255, red, green, blue);
    }

    public getBrightness(): number {
        let [min, max] = this.minMaxRGB(this.R, this.G, this.B);
        return (max + min) / (255 * 2);
    }

    public getHue(): number {
        if(this.R === this.G && this.G === this.B){
            return 0.0;
        }
        let [min, max] = this.minMaxRGB(this.R, this.G, this.B);
        let delta = max - min;
        let hue = 0
        if (this.R === max){
            hue = (this.G - this.B) / delta;
        } else if(this.G === max){
            hue = (this.B - this.R) / delta + 2.0;
        } else {
            hue = (this.R - this.G) / delta + 4.0;
        }

        hue = hue * 60.0;
        if(hue < 0){
            hue = hue + 360.0;
        }
        return hue;
    }

    public getSaturation(): number {
        if(this.R === this.G && this.G === this.B){
            return 0.0;
        }
        let [min, max] = this.minMaxRGB(this.R, this.G, this.B);
        let div = max + min;
        if(div > 255){
            div = 255 * 2 - max - min;
        }
        return (max - min) / div;
    }

    private minMaxRGB(r: number,g: number,b: number): [number, number]{
        let min,max = 0;
        if(r>g){
            max = r;
            min = g;
        }
        else{
            max = g;
            min = r;
        }
        if(b>max){
            max = b;
        }
        else if(b < min){
            min = b
        }
        return [min, max];
    }

    public getArgbValue(): number {
        return this.toArgb();
    }

    public getHexValue(): string {
        return this.toHex();
    }

    public toArgb(): number {
        let result = (this.A << 24) | (this.R << 16) | (this.G << 8) | this.B;
        if (result > 2147483647) {
            result -= 4294967296;
        }
        return result;
    }

    public toHex(): string {
        return `#${this.A.toString(16).padStart(2, '0')}${this.R.toString(16).padStart(2, '0')}${this.G.toString(16).padStart(2, '0')}${this.B.toString(16).padStart(2, '0')}`;
    }

    public toString(): string {
        return "Color [A=" + this.A + ", R=:" + this.R + ", G=" + this.G + ", B=" + this.B + "] - INT=" + this.toArgb() + " - HEX=" + this.toHex();
    }

    equals(other: SColor): boolean {
        return this.equals(other);
    }

    //[[ WINDOWS SYSTEM COLORS ]]
    public static Transparent = SColor.FromArgb(16777215);
    public static AliceBlue = SColor.FromArgb(-984833);
    public static AntiqueWhite = SColor.FromArgb(-332841);
    public static Aqua = SColor.FromArgb(-16711681);
    public static Aquamarine = SColor.FromArgb(-8388652);
    public static Azure = SColor.FromArgb(-983041);
    public static Beige = SColor.FromArgb(-657956);
    public static Bisque = SColor.FromArgb(-6972);
    public static Black = SColor.FromArgb(-16777216);
    public static BlanchedAlmond = SColor.FromArgb(-5171);
    public static Blue = SColor.FromArgb(-16776961);
    public static BlueViolet = SColor.FromArgb(-7722014);
    public static Brown = SColor.FromArgb(-5952982);
    public static BurlyWood = SColor.FromArgb(-2180985);
    public static CadetBlue = SColor.FromArgb(-10510688);
    public static Chartreuse = SColor.FromArgb(-8388864);
    public static Chocolate = SColor.FromArgb(-2987746);
    public static Coral = SColor.FromArgb(-32944);
    public static CornflowerBlue = SColor.FromArgb(-10185235);
    public static Cornsilk = SColor.FromArgb(-1828);
    public static Crimson = SColor.FromArgb(-2354116);
    public static Cyan = SColor.FromArgb(-16711681);
    public static DarkBlue = SColor.FromArgb(-16777077);
    public static DarkCyan = SColor.FromArgb(-16741493);
    public static DarkGoldenrod = SColor.FromArgb(-4684277);
    public static DarkGray = SColor.FromArgb(-5658199);
    public static DarkGreen = SColor.FromArgb(-16751616);
    public static DarkKhaki = SColor.FromArgb(-4343957);
    public static DarkMagenta = SColor.FromArgb(-7667573);
    public static DarkOliveGreen = SColor.FromArgb(-11179217);
    public static DarkOrange = SColor.FromArgb(-29696);
    public static DarkOrchid = SColor.FromArgb(-6737204);
    public static DarkRed = SColor.FromArgb(-7667712);
    public static DarkSalmon = SColor.FromArgb(-1468806);
    public static DarkSeaGreen = SColor.FromArgb(-7357301);
    public static DarkSlateBlue = SColor.FromArgb(-12042869);
    public static DarkSlateGray = SColor.FromArgb(-13676721);
    public static DarkTurquoise = SColor.FromArgb(-16724271);
    public static DarkViolet = SColor.FromArgb(-7077677);
    public static DeepPink = SColor.FromArgb(-60269);
    public static DeepSkyBlue = SColor.FromArgb(-16728065);
    public static DimGray = SColor.FromArgb(-9868951);
    public static DodgerBlue = SColor.FromArgb(-14774017);
    public static Firebrick = SColor.FromArgb(-5103070);
    public static FloralWhite = SColor.FromArgb(-1296);
    public static ForestGreen = SColor.FromArgb(-14513374);
    public static Fuchsia = SColor.FromArgb(-65281);
    public static Gainsboro = SColor.FromArgb(-2302756);
    public static GhostWhite = SColor.FromArgb(-460545);
    public static Gold = SColor.FromArgb(-10496);
    public static Goldenrod = SColor.FromArgb(-2448096);
    public static Gray = SColor.FromArgb(-8355712);
    public static Green = SColor.FromArgb(-16744448);
    public static GreenYellow = SColor.FromArgb(-5374161);
    public static Honeydew = SColor.FromArgb(-983056);
    public static HotPink = SColor.FromArgb(-38476);
    public static IndianRed = SColor.FromArgb(-3318692);
    public static Indigo = SColor.FromArgb(-11861886);
    public static Ivory = SColor.FromArgb(-16);
    public static Khaki = SColor.FromArgb(-989556);
    public static Lavender = SColor.FromArgb(-1644806);
    public static LavenderBlush = SColor.FromArgb(-3851);
    public static LawnGreen = SColor.FromArgb(-8586240);
    public static LemonChiffon = SColor.FromArgb(-1331);
    public static LightBlue = SColor.FromArgb(-5383962);
    public static LightCoral = SColor.FromArgb(-1015680);
    public static LightCyan = SColor.FromArgb(-2031617);
    public static LightGoldenrodYellow = SColor.FromArgb(-329006);
    public static LightGreen = SColor.FromArgb(-7278960);
    public static LightGray = SColor.FromArgb(-2894893);
    public static LightPink = SColor.FromArgb(-18751);
    public static LightSalmon = SColor.FromArgb(-24454);
    public static LightSeaGreen = SColor.FromArgb(-14634326);
    public static LightSkyBlue = SColor.FromArgb(-7876870);
    public static LightSlateGray = SColor.FromArgb(-8943463);
    public static LightSteelBlue = SColor.FromArgb(-5192482);
    public static LightYellow = SColor.FromArgb(-32);
    public static Lime = SColor.FromArgb(-16711936);
    public static LimeGreen = SColor.FromArgb(-13447886);
    public static Linen = SColor.FromArgb(-331546);
    public static Magenta = SColor.FromArgb(-65281);
    public static Maroon = SColor.FromArgb(-8388608);
    public static MediumAquamarine = SColor.FromArgb(-10039894);
    public static MediumBlue = SColor.FromArgb(-16777011);
    public static MediumOrchid = SColor.FromArgb(-4565549);
    public static MediumPurple = SColor.FromArgb(-7114533);
    public static MediumSeaGreen = SColor.FromArgb(-12799119);
    public static MediumSlateBlue = SColor.FromArgb(-8689426);
    public static MediumSpringGreen = SColor.FromArgb(-16713062);
    public static MediumTurquoise = SColor.FromArgb(-12004916);
    public static MediumVioletRed = SColor.FromArgb(-3730043);
    public static MidnightBlue = SColor.FromArgb(-15132304);
    public static MintCream = SColor.FromArgb(-655366);
    public static MistyRose = SColor.FromArgb(-6943);
    public static Moccasin = SColor.FromArgb(-6987);
    public static NavajoWhite = SColor.FromArgb(-8531);
    public static Navy = SColor.FromArgb(-16777088);
    public static OldLace = SColor.FromArgb(-133658);
    public static Olive = SColor.FromArgb(-8355840);
    public static OliveDrab = SColor.FromArgb(-9728477);
    public static Orange = SColor.FromArgb(-23296);
    public static OrangeRed = SColor.FromArgb(-47872);
    public static Orchid = SColor.FromArgb(-2461482);
    public static PaleGoldenrod = SColor.FromArgb(-1120086);
    public static PaleGreen = SColor.FromArgb(-6751336);
    public static PaleTurquoise = SColor.FromArgb(-5247250);
    public static PaleVioletRed = SColor.FromArgb(-2396013);
    public static PapayaWhip = SColor.FromArgb(-4139);
    public static PeachPuff = SColor.FromArgb(-9543);
    public static Peru = SColor.FromArgb(-3308225);
    public static Pink = SColor.FromArgb(-16181);
    public static Plum = SColor.FromArgb(-2252579);
    public static PowderBlue = SColor.FromArgb(-5185306);
    public static Purple = SColor.FromArgb(-8388480);
    public static Red = SColor.FromArgb(-65536);
    public static RosyBrown = SColor.FromArgb(-4419697);
    public static RoyalBlue = SColor.FromArgb(-12490271);
    public static SaddleBrown = SColor.FromArgb(-7650029);
    public static Salmon = SColor.FromArgb(-360334);
    public static SandyBrown = SColor.FromArgb(-744352);
    public static SeaGreen = SColor.FromArgb(-13726889);
    public static SeaShell = SColor.FromArgb(-2578);
    public static Sienna = SColor.FromArgb(-6270419);
    public static Silver = SColor.FromArgb(-4144960);
    public static SkyBlue = SColor.FromArgb(-7876885);
    public static SlateBlue = SColor.FromArgb(-9807155);
    public static SlateGray = SColor.FromArgb(-9404272);
    public static Snow = SColor.FromArgb(-1286);
    public static SpringGreen = SColor.FromArgb(-16711809);
    public static SteelBlue = SColor.FromArgb(-12156236);
    public static Tan = SColor.FromArgb(-2968436);
    public static Teal = SColor.FromArgb(-16744320);
    public static Thistle = SColor.FromArgb(-2572328);
    public static Tomato = SColor.FromArgb(-40121);
    public static Turquoise = SColor.FromArgb(-12525360);
    public static Violet = SColor.FromArgb(-1146130);
    public static Wheat = SColor.FromArgb(-663885);
    public static White = SColor.FromArgb(-1);
    public static WhiteSmoke = SColor.FromArgb(-657931);
    public static Yellow = SColor.FromArgb(-256);
    public static YellowGreen = SColor.FromArgb(-6632142);
    
    //[[ GTA HUD COLORS ]]
    public static HUD_None = SColor.FromHudColor(-1);
    public static HUD_Pure_white = SColor.FromHudColor(0);
    public static HUD_White = SColor.FromHudColor(1);
    public static HUD_Black = SColor.FromHudColor(2);
    public static HUD_Grey = SColor.FromHudColor(3);
    public static HUD_Greylight = SColor.FromHudColor(4);
    public static HUD_Greydark = SColor.FromHudColor(5);
    public static HUD_Red = SColor.FromHudColor(6);
    public static HUD_Redlight = SColor.FromHudColor(7);
    public static HUD_Reddark = SColor.FromHudColor(8);
    public static HUD_Blue = SColor.FromHudColor(9);
    public static HUD_Bluelight = SColor.FromHudColor(10);
    public static HUD_Bluedark = SColor.FromHudColor(11);
    public static HUD_Yellow = SColor.FromHudColor(12);
    public static HUD_Yellowlight = SColor.FromHudColor(13);
    public static HUD_Yellowdark = SColor.FromHudColor(14);
    public static HUD_Orange = SColor.FromHudColor(15);
    public static HUD_Orangelight = SColor.FromHudColor(16);
    public static HUD_Orangedark = SColor.FromHudColor(17);
    public static HUD_Green = SColor.FromHudColor(18);
    public static HUD_Greenlight = SColor.FromHudColor(19);
    public static HUD_Greendark = SColor.FromHudColor(20);
    public static HUD_Purple = SColor.FromHudColor(21);
    public static HUD_Purplelight = SColor.FromHudColor(22);
    public static HUD_Purpledark = SColor.FromHudColor(23);
    public static HUD_Pink = SColor.FromHudColor(24);
    public static HUD_Radar_health = SColor.FromHudColor(25);
    public static HUD_Radar_armour = SColor.FromHudColor(26);
    public static HUD_Radar_damage = SColor.FromHudColor(27);
    public static HUD_Net_player1 = SColor.FromHudColor(28);
    public static HUD_Net_player2 = SColor.FromHudColor(29);
    public static HUD_Net_player3 = SColor.FromHudColor(30);
    public static HUD_Net_player4 = SColor.FromHudColor(31);
    public static HUD_Net_player5 = SColor.FromHudColor(32);
    public static HUD_Net_player6 = SColor.FromHudColor(33);
    public static HUD_Net_player7 = SColor.FromHudColor(34);
    public static HUD_Net_player8 = SColor.FromHudColor(35);
    public static HUD_Net_player9 = SColor.FromHudColor(36);
    public static HUD_Net_player10 = SColor.FromHudColor(37);
    public static HUD_Net_player11 = SColor.FromHudColor(38);
    public static HUD_Net_player12 = SColor.FromHudColor(39);
    public static HUD_Net_player13 = SColor.FromHudColor(40);
    public static HUD_Net_player14 = SColor.FromHudColor(41);
    public static HUD_Net_player15 = SColor.FromHudColor(42);
    public static HUD_Net_player16 = SColor.FromHudColor(43);
    public static HUD_Net_player17 = SColor.FromHudColor(44);
    public static HUD_Net_player18 = SColor.FromHudColor(45);
    public static HUD_Net_player19 = SColor.FromHudColor(46);
    public static HUD_Net_player20 = SColor.FromHudColor(47);
    public static HUD_Net_player21 = SColor.FromHudColor(48);
    public static HUD_Net_player22 = SColor.FromHudColor(49);
    public static HUD_Net_player23 = SColor.FromHudColor(50);
    public static HUD_Net_player24 = SColor.FromHudColor(51);
    public static HUD_Net_player25 = SColor.FromHudColor(52);
    public static HUD_Net_player26 = SColor.FromHudColor(53);
    public static HUD_Net_player27 = SColor.FromHudColor(54);
    public static HUD_Net_player28 = SColor.FromHudColor(55);
    public static HUD_Net_player29 = SColor.FromHudColor(56);
    public static HUD_Net_player30 = SColor.FromHudColor(57);
    public static HUD_Net_player31 = SColor.FromHudColor(58);
    public static HUD_Net_player32 = SColor.FromHudColor(59);
    public static HUD_Simpleblip_default = SColor.FromHudColor(60);
    public static HUD_Menu_blue = SColor.FromHudColor(61);
    public static HUD_Menu_grey_light = SColor.FromHudColor(62);
    public static HUD_Menu_blue_extra_dark = SColor.FromHudColor(63);
    public static HUD_Menu_yellow = SColor.FromHudColor(64);
    public static HUD_Menu_yellow_dark = SColor.FromHudColor(65);
    public static HUD_Menu_green = SColor.FromHudColor(66);
    public static HUD_Menu_grey = SColor.FromHudColor(67);
    public static HUD_Menu_grey_dark = SColor.FromHudColor(68);
    public static HUD_Menu_highlight = SColor.FromHudColor(69);
    public static HUD_Menu_standard = SColor.FromHudColor(70);
    public static HUD_Menu_dimmed = SColor.FromHudColor(71);
    public static HUD_Menu_extra_dimmed = SColor.FromHudColor(72);
    public static HUD_Brief_title = SColor.FromHudColor(73);
    public static HUD_Mid_grey_mp = SColor.FromHudColor(74);
    public static HUD_Net_player1_dark = SColor.FromHudColor(75);
    public static HUD_Net_player2_dark = SColor.FromHudColor(76);
    public static HUD_Net_player3_dark = SColor.FromHudColor(77);
    public static HUD_Net_player4_dark = SColor.FromHudColor(78);
    public static HUD_Net_player5_dark = SColor.FromHudColor(79);
    public static HUD_Net_player6_dark = SColor.FromHudColor(80);
    public static HUD_Net_player7_dark = SColor.FromHudColor(81);
    public static HUD_Net_player8_dark = SColor.FromHudColor(82);
    public static HUD_Net_player9_dark = SColor.FromHudColor(83);
    public static HUD_Net_player10_dark = SColor.FromHudColor(84);
    public static HUD_Net_player11_dark = SColor.FromHudColor(85);
    public static HUD_Net_player12_dark = SColor.FromHudColor(86);
    public static HUD_Net_player13_dark = SColor.FromHudColor(87);
    public static HUD_Net_player14_dark = SColor.FromHudColor(88);
    public static HUD_Net_player15_dark = SColor.FromHudColor(89);
    public static HUD_Net_player16_dark = SColor.FromHudColor(90);
    public static HUD_Net_player17_dark = SColor.FromHudColor(91);
    public static HUD_Net_player18_dark = SColor.FromHudColor(92);
    public static HUD_Net_player19_dark = SColor.FromHudColor(93);
    public static HUD_Net_player20_dark = SColor.FromHudColor(94);
    public static HUD_Net_player21_dark = SColor.FromHudColor(95);
    public static HUD_Net_player22_dark = SColor.FromHudColor(96);
    public static HUD_Net_player23_dark = SColor.FromHudColor(97);
    public static HUD_Net_player24_dark = SColor.FromHudColor(98);
    public static HUD_Net_player25_dark = SColor.FromHudColor(99);
    public static HUD_Net_player26_dark = SColor.FromHudColor(100);
    public static HUD_Net_player27_dark = SColor.FromHudColor(101);
    public static HUD_Net_player28_dark = SColor.FromHudColor(102);
    public static HUD_Net_player29_dark = SColor.FromHudColor(103);
    public static HUD_Net_player30_dark = SColor.FromHudColor(104);
    public static HUD_Net_player31_dark = SColor.FromHudColor(105);
    public static HUD_Net_player32_dark = SColor.FromHudColor(106);
    public static HUD_Bronze = SColor.FromHudColor(107);
    public static HUD_Silver = SColor.FromHudColor(108);
    public static HUD_Gold = SColor.FromHudColor(109);
    public static HUD_Platinum = SColor.FromHudColor(110);
    public static HUD_Gang1 = SColor.FromHudColor(111);
    public static HUD_Gang2 = SColor.FromHudColor(112);
    public static HUD_Gang3 = SColor.FromHudColor(113);
    public static HUD_Gang4 = SColor.FromHudColor(114);
    public static HUD_Same_crew = SColor.FromHudColor(115);
    public static HUD_Freemode = SColor.FromHudColor(116);
    public static HUD_Pause_bg = SColor.FromHudColor(117);
    public static HUD_Friendly = SColor.FromHudColor(118);
    public static HUD_Enemy = SColor.FromHudColor(119);
    public static HUD_Location = SColor.FromHudColor(120);
    public static HUD_Pickup = SColor.FromHudColor(121);
    public static HUD_Pause_singleplayer = SColor.FromHudColor(122);
    public static HUD_Freemode_dark = SColor.FromHudColor(123);
    public static HUD_Inactive_mission = SColor.FromHudColor(124);
    public static HUD_Damage = SColor.FromHudColor(125);
    public static HUD_Pinklight = SColor.FromHudColor(126);
    public static HUD_Pm_mitem_highlight = SColor.FromHudColor(127);
    public static HUD_Script_variable = SColor.FromHudColor(128);
    public static HUD_Yoga = SColor.FromHudColor(129);
    public static HUD_Tennis = SColor.FromHudColor(130);
    public static HUD_Golf = SColor.FromHudColor(131);
    public static HUD_Shooting_range = SColor.FromHudColor(132);
    public static HUD_Flight_school = SColor.FromHudColor(133);
    public static HUD_North_blue = SColor.FromHudColor(134);
    public static HUD_Social_club = SColor.FromHudColor(135);
    public static HUD_Platform_blue = SColor.FromHudColor(136);
    public static HUD_Platform_green = SColor.FromHudColor(137);
    public static HUD_Platform_grey = SColor.FromHudColor(138);
    public static HUD_Facebook_blue = SColor.FromHudColor(139);
    public static HUD_Ingame_bg = SColor.FromHudColor(140);
    public static HUD_Darts = SColor.FromHudColor(141);
    public static HUD_Waypoint = SColor.FromHudColor(142);
    public static HUD_Michael = SColor.FromHudColor(143);
    public static HUD_Franklin = SColor.FromHudColor(144);
    public static HUD_Trevor = SColor.FromHudColor(145);
    public static HUD_Golf_p1 = SColor.FromHudColor(146);
    public static HUD_Golf_p2 = SColor.FromHudColor(147);
    public static HUD_Golf_p3 = SColor.FromHudColor(148);
    public static HUD_Golf_p4 = SColor.FromHudColor(149);
    public static HUD_Waypointlight = SColor.FromHudColor(150);
    public static HUD_Waypointdark = SColor.FromHudColor(151);
    public static HUD_Panel_light = SColor.FromHudColor(152);
    public static HUD_Michael_dark = SColor.FromHudColor(153);
    public static HUD_Franklin_dark = SColor.FromHudColor(154);
    public static HUD_Trevor_dark = SColor.FromHudColor(155);
    public static HUD_Objective_route = SColor.FromHudColor(156);
    public static HUD_Pausemap_tint = SColor.FromHudColor(157);
    public static HUD_Pause_deselect = SColor.FromHudColor(158);
    public static HUD_Pm_weapons_purchasable = SColor.FromHudColor(159);
    public static HUD_Pm_weapons_locked = SColor.FromHudColor(160);
    public static HUD_End_screen_bg = SColor.FromHudColor(161);
    public static HUD_Chop = SColor.FromHudColor(162);
    public static HUD_Pausemap_tint_half = SColor.FromHudColor(163);
    public static HUD_North_blue_official = SColor.FromHudColor(164);
    public static HUD_Script_variable_2 = SColor.FromHudColor(165);
    public static HUD_H = SColor.FromHudColor(166);
    public static HUD_Hdark = SColor.FromHudColor(167);
    public static HUD_T = SColor.FromHudColor(168);
    public static HUD_Tdark = SColor.FromHudColor(169);
    public static HUD_Hshard = SColor.FromHudColor(170);
    public static HUD_Controller_michael = SColor.FromHudColor(171);
    public static HUD_Controller_franklin = SColor.FromHudColor(172);
    public static HUD_Controller_trevor = SColor.FromHudColor(173);
    public static HUD_Controller_chop = SColor.FromHudColor(174);
    public static HUD_Video_editor_video = SColor.FromHudColor(175);
    public static HUD_Video_editor_audio = SColor.FromHudColor(176);
    public static HUD_Video_editor_text = SColor.FromHudColor(177);
    public static HUD_Hb_blue = SColor.FromHudColor(178);
    public static HUD_Hb_yellow = SColor.FromHudColor(179);
    public static HUD_Video_editor_score = SColor.FromHudColor(180);
    public static HUD_Video_editor_audio_fadeout = SColor.FromHudColor(181);
    public static HUD_Video_editor_text_fadeout = SColor.FromHudColor(182);
    public static HUD_Video_editor_score_fadeout = SColor.FromHudColor(183);
    public static HUD_Heist_background = SColor.FromHudColor(184);
    public static HUD_Video_editor_ambient = SColor.FromHudColor(185);
    public static HUD_Video_editor_ambient_fadeout = SColor.FromHudColor(186);
    public static HUD_Gb = SColor.FromHudColor(187);
    public static HUD_G = SColor.FromHudColor(188);
    public static HUD_B = SColor.FromHudColor(189);
    public static HUD_Low_flow = SColor.FromHudColor(190);
    public static HUD_Low_flow_dark = SColor.FromHudColor(191);
    public static HUD_G1 = SColor.FromHudColor(192);
    public static HUD_G2 = SColor.FromHudColor(193);
    public static HUD_G3 = SColor.FromHudColor(194);
    public static HUD_G4 = SColor.FromHudColor(195);
    public static HUD_G5 = SColor.FromHudColor(196);
    public static HUD_G6 = SColor.FromHudColor(197);
    public static HUD_G7 = SColor.FromHudColor(198);
    public static HUD_G8 = SColor.FromHudColor(199);
    public static HUD_G9 = SColor.FromHudColor(200);
    public static HUD_G10 = SColor.FromHudColor(201);
    public static HUD_G11 = SColor.FromHudColor(202);
    public static HUD_G12 = SColor.FromHudColor(203);
    public static HUD_G13 = SColor.FromHudColor(204);
    public static HUD_G14 = SColor.FromHudColor(205);
    public static HUD_G15 = SColor.FromHudColor(206);
    public static HUD_Adversary = SColor.FromHudColor(207);
    public static HUD_Degen_red = SColor.FromHudColor(208);
    public static HUD_Degen_yellow = SColor.FromHudColor(209);
    public static HUD_Degen_green = SColor.FromHudColor(210);
    public static HUD_Degen_cyan = SColor.FromHudColor(211);
    public static HUD_Degen_blue = SColor.FromHudColor(212);
    public static HUD_Degen_magenta = SColor.FromHudColor(213);
    public static HUD_Stunt_1 = SColor.FromHudColor(214);
    public static HUD_Stunt_2 = SColor.FromHudColor(215);
    public static HUD_Special_race_series = SColor.FromHudColor(216);
    public static HUD_Special_race_series_dark = SColor.FromHudColor(217);
    public static HUD_Cs = SColor.FromHudColor(218);
    public static HUD_Cs_dark = SColor.FromHudColor(219);
    public static HUD_Tech_green = SColor.FromHudColor(220);
    public static HUD_Tech_green_dark = SColor.FromHudColor(221);
    public static HUD_Tech_red = SColor.FromHudColor(222);
    public static HUD_Tech_green_very_dark = SColor.FromHudColor(223);

}