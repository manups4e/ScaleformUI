SColor = setmetatable({ A = 0, R = 0, G = 0, B = 0 }, SColor)
SColor.__index = SColor
SColor.__call = function()
    return "SColor"
end

---@class SColor
---@field private MinMaxRgb function
---@field private __eq function
---@field private __tostring function
---@field private __newindex function
---@field public A number
---@field public R number
---@field public G number
---@field public B number
---@field public FromHex fun(self: SColor, hexColor: string)
---@field public FromHudColor fun(self: SColor, color: HudColours)
---@field public FromRandomValues fun(self: SColor)
---@field public FromArgb fun(self: SColor, ...:number|number)
---@field public FromRgb fun(self: SColor, red: number, green: number, blue: number)
---@field public GetBrightness function
---@field public GetHue function
---@field public GetSaturation function
---@field public ToArgb function
---@field public ToHex function
---@field public ToString function
---@field public Transparent SColor
---@field public AliceBlue SColor
---@field public AntiqueWhite SColor
---@field public Aqua SColor
---@field public Aquamarine SColor
---@field public Azure SColor
---@field public Beige SColor
---@field public Bisque SColor
---@field public Black SColor
---@field public BlanchedAlmond SColor
---@field public Blue SColor
---@field public BlueViolet SColor
---@field public Brown SColor
---@field public BurlyWood SColor
---@field public CadetBlue SColor
---@field public Chartreuse SColor
---@field public Chocolate SColor
---@field public Coral SColor
---@field public CornflowerBlue SColor
---@field public Cornsilk SColor
---@field public Crimson SColor
---@field public Cyan SColor
---@field public DarkBlue SColor
---@field public DarkCyan SColor
---@field public DarkGoldenrod SColor
---@field public DarkGray SColor
---@field public DarkGreen SColor
---@field public DarkKhaki SColor
---@field public DarkMagenta SColor
---@field public DarkOliveGreen SColor
---@field public DarkOrange SColor
---@field public DarkOrchid SColor
---@field public DarkRed SColor
---@field public DarkSalmon SColor
---@field public DarkSeaGreen SColor
---@field public DarkSlateBlue SColor
---@field public DarkSlateGray SColor
---@field public DarkTurquoise SColor
---@field public DarkViolet SColor
---@field public DeepPink SColor
---@field public DeepSkyBlue SColor
---@field public DimGray SColor
---@field public DodgerBlue SColor
---@field public Firebrick SColor
---@field public FloralWhite SColor
---@field public ForestGreen SColor
---@field public Fuchsia SColor
---@field public Gainsboro SColor
---@field public GhostWhite SColor
---@field public Gold SColor
---@field public Goldenrod SColor
---@field public Gray SColor
---@field public Green SColor
---@field public GreenYellow SColor
---@field public Honeydew SColor
---@field public HotPink SColor
---@field public IndianRed SColor
---@field public Indigo SColor
---@field public Ivory SColor
---@field public Khaki SColor
---@field public Lavender SColor
---@field public LavenderBlush SColor
---@field public LawnGreen SColor
---@field public LemonChiffon SColor
---@field public LightBlue SColor
---@field public LightCoral SColor
---@field public LightCyan SColor
---@field public LightGoldenrodYellow SColor
---@field public LightGreen SColor
---@field public LightGray SColor
---@field public LightPink SColor
---@field public LightSalmon SColor
---@field public LightSeaGreen SColor
---@field public LightSkyBlue SColor
---@field public LightSlateGray SColor
---@field public LightSteelBlue SColor
---@field public LightYellow SColor
---@field public Lime SColor
---@field public LimeGreen SColor
---@field public Linen SColor
---@field public Magenta SColor
---@field public Maroon SColor
---@field public MediumAquamarine SColor
---@field public MediumBlue SColor
---@field public MediumOrchid SColor
---@field public MediumPurple SColor
---@field public MediumSeaGreen SColor
---@field public MediumSlateBlue SColor
---@field public MediumSpringGreen SColor
---@field public MediumTurquoise SColor
---@field public MediumVioletRed SColor
---@field public MidnightBlue SColor
---@field public MintCream SColor
---@field public MistyRose SColor
---@field public Moccasin SColor
---@field public NavajoWhite SColor
---@field public Navy SColor
---@field public OldLace SColor
---@field public Olive SColor
---@field public OliveDrab SColor
---@field public Orange SColor
---@field public OrangeRed SColor
---@field public Orchid SColor
---@field public PaleGoldenrod SColor
---@field public PaleGreen SColor
---@field public PaleTurquoise SColor
---@field public PaleVioletRed SColor
---@field public PapayaWhip SColor
---@field public PeachPuff SColor
---@field public Peru SColor
---@field public Pink SColor
---@field public Plum SColor
---@field public PowderBlue SColor
---@field public Purple SColor
---@field public Red SColor
---@field public RosyBrown SColor
---@field public RoyalBlue SColor
---@field public SaddleBrown SColor
---@field public Salmon SColor
---@field public SandyBrown SColor
---@field public SeaGreen SColor
---@field public SeaShell SColor
---@field public Sienna SColor
---@field public Silver SColor
---@field public SkyBlue SColor
---@field public SlateBlue SColor
---@field public SlateGray SColor
---@field public Snow SColor
---@field public SpringGreen SColor
---@field public SteelBlue SColor
---@field public Tan SColor
---@field public Teal SColor
---@field public Thistle SColor
---@field public Tomato SColor
---@field public Turquoise SColor
---@field public Violet SColor
---@field public Wheat SColor
---@field public White SColor
---@field public WhiteSmoke SColor
---@field public Yellow SColor
---@field public YellowGreen SColor
---@field public HUD_None SColor
---@field public HUD_Pure_white SColor
---@field public HUD_White SColor
---@field public HUD_Black SColor
---@field public HUD_Grey SColor
---@field public HUD_Greylight SColor
---@field public HUD_Greydark SColor
---@field public HUD_Red SColor
---@field public HUD_Redlight SColor
---@field public HUD_Reddark SColor
---@field public HUD_Blue SColor
---@field public HUD_Bluelight SColor
---@field public HUD_Bluedark SColor
---@field public HUD_Yellow SColor
---@field public HUD_Yellowlight SColor
---@field public HUD_Yellowdark SColor
---@field public HUD_Orange SColor
---@field public HUD_Orangelight SColor
---@field public HUD_Orangedark SColor
---@field public HUD_Green SColor
---@field public HUD_Greenlight SColor
---@field public HUD_Greendark SColor
---@field public HUD_Purple SColor
---@field public HUD_Purplelight SColor
---@field public HUD_Purpledark SColor
---@field public HUD_Pink SColor
---@field public HUD_Radar_health SColor
---@field public HUD_Radar_armour SColor
---@field public HUD_Radar_damage SColor
---@field public HUD_Net_player1 SColor
---@field public HUD_Net_player2 SColor
---@field public HUD_Net_player3 SColor
---@field public HUD_Net_player4 SColor
---@field public HUD_Net_player5 SColor
---@field public HUD_Net_player6 SColor
---@field public HUD_Net_player7 SColor
---@field public HUD_Net_player8 SColor
---@field public HUD_Net_player9 SColor
---@field public HUD_Net_player10 SColor
---@field public HUD_Net_player11 SColor
---@field public HUD_Net_player12 SColor
---@field public HUD_Net_player13 SColor
---@field public HUD_Net_player14 SColor
---@field public HUD_Net_player15 SColor
---@field public HUD_Net_player16 SColor
---@field public HUD_Net_player17 SColor
---@field public HUD_Net_player18 SColor
---@field public HUD_Net_player19 SColor
---@field public HUD_Net_player20 SColor
---@field public HUD_Net_player21 SColor
---@field public HUD_Net_player22 SColor
---@field public HUD_Net_player23 SColor
---@field public HUD_Net_player24 SColor
---@field public HUD_Net_player25 SColor
---@field public HUD_Net_player26 SColor
---@field public HUD_Net_player27 SColor
---@field public HUD_Net_player28 SColor
---@field public HUD_Net_player29 SColor
---@field public HUD_Net_player30 SColor
---@field public HUD_Net_player31 SColor
---@field public HUD_Net_player32 SColor
---@field public HUD_Simpleblip_default SColor
---@field public HUD_Menu_blue SColor
---@field public HUD_Menu_grey_light SColor
---@field public HUD_Menu_blue_extra_dark SColor
---@field public HUD_Menu_yellow SColor
---@field public HUD_Menu_yellow_dark SColor
---@field public HUD_Menu_green SColor
---@field public HUD_Menu_grey SColor
---@field public HUD_Menu_grey_dark SColor
---@field public HUD_Menu_highlight SColor
---@field public HUD_Menu_standard SColor
---@field public HUD_Menu_dimmed SColor
---@field public HUD_Menu_extra_dimmed SColor
---@field public HUD_Brief_title SColor
---@field public HUD_Mid_grey_mp SColor
---@field public HUD_Net_player1_dark SColor
---@field public HUD_Net_player2_dark SColor
---@field public HUD_Net_player3_dark SColor
---@field public HUD_Net_player4_dark SColor
---@field public HUD_Net_player5_dark SColor
---@field public HUD_Net_player6_dark SColor
---@field public HUD_Net_player7_dark SColor
---@field public HUD_Net_player8_dark SColor
---@field public HUD_Net_player9_dark SColor
---@field public HUD_Net_player10_dark SColor
---@field public HUD_Net_player11_dark SColor
---@field public HUD_Net_player12_dark SColor
---@field public HUD_Net_player13_dark SColor
---@field public HUD_Net_player14_dark SColor
---@field public HUD_Net_player15_dark SColor
---@field public HUD_Net_player16_dark SColor
---@field public HUD_Net_player17_dark SColor
---@field public HUD_Net_player18_dark SColor
---@field public HUD_Net_player19_dark SColor
---@field public HUD_Net_player20_dark SColor
---@field public HUD_Net_player21_dark SColor
---@field public HUD_Net_player22_dark SColor
---@field public HUD_Net_player23_dark SColor
---@field public HUD_Net_player24_dark SColor
---@field public HUD_Net_player25_dark SColor
---@field public HUD_Net_player26_dark SColor
---@field public HUD_Net_player27_dark SColor
---@field public HUD_Net_player28_dark SColor
---@field public HUD_Net_player29_dark SColor
---@field public HUD_Net_player30_dark SColor
---@field public HUD_Net_player31_dark SColor
---@field public HUD_Net_player32_dark SColor
---@field public HUD_Bronze SColor
---@field public HUD_Silver SColor
---@field public HUD_Gold SColor
---@field public HUD_Platinum SColor
---@field public HUD_Gang1 SColor
---@field public HUD_Gang2 SColor
---@field public HUD_Gang3 SColor
---@field public HUD_Gang4 SColor
---@field public HUD_Same_crew SColor
---@field public HUD_Freemode SColor
---@field public HUD_Pause_bg SColor
---@field public HUD_Friendly SColor
---@field public HUD_Enemy SColor
---@field public HUD_Location SColor
---@field public HUD_Pickup SColor
---@field public HUD_Pause_singleplayer SColor
---@field public HUD_Freemode_dark SColor
---@field public HUD_Inactive_mission SColor
---@field public HUD_Damage SColor
---@field public HUD_Pinklight SColor
---@field public HUD_Pm_mitem_highlight SColor
---@field public HUD_Script_variable SColor
---@field public HUD_Yoga SColor
---@field public HUD_Tennis SColor
---@field public HUD_Golf SColor
---@field public HUD_Shooting_range SColor
---@field public HUD_Flight_school SColor
---@field public HUD_North_blue SColor
---@field public HUD_Social_club SColor
---@field public HUD_Platform_blue SColor
---@field public HUD_Platform_green SColor
---@field public HUD_Platform_grey SColor
---@field public HUD_Facebook_blue SColor
---@field public HUD_Ingame_bg SColor
---@field public HUD_Darts SColor
---@field public HUD_Waypoint SColor
---@field public HUD_Michael SColor
---@field public HUD_Franklin SColor
---@field public HUD_Trevor SColor
---@field public HUD_Golf_p1 SColor
---@field public HUD_Golf_p2 SColor
---@field public HUD_Golf_p3 SColor
---@field public HUD_Golf_p4 SColor
---@field public HUD_Waypointlight SColor
---@field public HUD_Waypointdark SColor
---@field public HUD_Panel_light SColor
---@field public HUD_Michael_dark SColor
---@field public HUD_Franklin_dark SColor
---@field public HUD_Trevor_dark SColor
---@field public HUD_Objective_route SColor
---@field public HUD_Pausemap_tint SColor
---@field public HUD_Pause_deselect SColor
---@field public HUD_Pm_weapons_purchasable SColor
---@field public HUD_Pm_weapons_locked SColor
---@field public HUD_End_screen_bg SColor
---@field public HUD_Chop SColor
---@field public HUD_Pausemap_tint_half SColor
---@field public HUD_North_blue_official SColor
---@field public HUD_Script_variable_2 SColor
---@field public HUD_H SColor
---@field public HUD_Hdark SColor
---@field public HUD_T SColor
---@field public HUD_Tdark SColor
---@field public HUD_Hshard SColor
---@field public HUD_Controller_michael SColor
---@field public HUD_Controller_franklin SColor
---@field public HUD_Controller_trevor SColor
---@field public HUD_Controller_chop SColor
---@field public HUD_Video_editor_video SColor
---@field public HUD_Video_editor_audio SColor
---@field public HUD_Video_editor_text SColor
---@field public HUD_Hb_blue SColor
---@field public HUD_Hb_yellow SColor
---@field public HUD_Video_editor_score SColor
---@field public HUD_Video_editor_audio_fadeout SColor
---@field public HUD_Video_editor_text_fadeout SColor
---@field public HUD_Video_editor_score_fadeout SColor
---@field public HUD_Heist_background SColor
---@field public HUD_Video_editor_ambient SColor
---@field public HUD_Video_editor_ambient_fadeout SColor
---@field public HUD_Gb SColor
---@field public HUD_G SColor
---@field public HUD_B SColor
---@field public HUD_Low_flow SColor
---@field public HUD_Low_flow_dark SColor
---@field public HUD_G1 SColor
---@field public HUD_G2 SColor
---@field public HUD_G3 SColor
---@field public HUD_G4 SColor
---@field public HUD_G5 SColor
---@field public HUD_G6 SColor
---@field public HUD_G7 SColor
---@field public HUD_G8 SColor
---@field public HUD_G9 SColor
---@field public HUD_G10 SColor
---@field public HUD_G11 SColor
---@field public HUD_G12 SColor
---@field public HUD_G13 SColor
---@field public HUD_G14 SColor
---@field public HUD_G15 SColor
---@field public HUD_Adversary SColor
---@field public HUD_Degen_red SColor
---@field public HUD_Degen_yellow SColor
---@field public HUD_Degen_green SColor
---@field public HUD_Degen_cyan SColor
---@field public HUD_Degen_blue SColor
---@field public HUD_Degen_magenta SColor
---@field public HUD_Stunt_1 SColor
---@field public HUD_Stunt_2 SColor
---@field public HUD_Special_race_series SColor
---@field public HUD_Special_race_series_dark SColor
---@field public HUD_Cs SColor
---@field public HUD_Cs_dark SColor
---@field public HUD_Tech_green SColor
---@field public HUD_Tech_green_dark SColor
---@field public HUD_Tech_red SColor
---@field public HUD_Tech_green_very_dark SColor



---@comment Loads from hex color string
---@param hexColor string
---@return table
function SColor.FromHex(hexColor)
    assert(hexColor:sub(1, 1) == "#", "Invalid Hex value")
    local color = { A = 0, R = 0, G = 0, B = 0 }
    if hexColor:sub(1, 1) == "#" then
        local hex = hexColor:gsub("#", "")       -- Remove "#" symbol if present
        local a = tonumber("0x" .. hex:sub(1, 2)) -- Convert first two characters to decimal (alpha channel)
        local r = tonumber("0x" .. hex:sub(3, 4)) -- Convert next two characters to decimal (red channel)
        local g = tonumber("0x" .. hex:sub(5, 6)) -- Convert next two characters to decimal (green channel)
        local b = tonumber("0x" .. hex:sub(7, 8)) -- Convert last two characters to decimal (blue channel)

        color = {
            A = a,
            R = r,
            G = g,
            B = b
        }
    end
    return setmetatable(color, SColor)
end

---@param color HudColours
---@return table
function SColor.FromHudColor(color)
    assert(color ~= nil, "Invalid HUD color value")
    local _color = { A = 0, R = 0, G = 0, B = 0 }
    local r, g, b, a = GetHudColour(color)
    _color = {
        A = a,
        R = r,
        G = g,
        B = b
    }
    return setmetatable(_color, SColor)
end

function SColor.FromRandomValues()
    local color = {
        A = 255,
        R = GetRandomIntInRange(1, 255),
        G = GetRandomIntInRange(1, 255),
        B = GetRandomIntInRange(1, 255)
    }
    return setmetatable(color, SColor)
end

---@comment Loads from a ColorInt or A,R,G,B paramereters, accept 1 or 4 parameters only.
---@param ... number
---@return table|unknown
function SColor.FromArgb(...)
    local args = { ... }
    local color = {}
    assert(args ~= nil, "nil values are not accepted")
    assert(#args == 1 or #args == 4, "accepted args are ARGB Int value or Alpha, Red, Green, Blue values")
    if #args == 1 then
        local argb = args[1]
        local isNegative = false
        if argb < 0 then
            isNegative = true
            argb = math.abs(argb) -- Convert negative value to positive
        end

        local a = (argb >> 24) & 255
        local r = (argb >> 16) & 255
        local g = (argb >> 8) & 255
        local b = argb & 255

        if isNegative then
            a = 255 - a
            r = 255 - r
            g = 255 - g
            b = 255 - b
        end

        color = { A = a, R = r, G = g, B = b }
    elseif #args == 4 then
        local alpha, red, green, blue = table.unpack(args)
        assert(alpha ~= nil, "alpha cannot be nil")
        assert(red ~= nil, "red cannot be nil")
        assert(green ~= nil, "green cannot be nil")
        assert(blue ~= nil, "blue cannot be nil")
        color = { A = alpha, R = red, G = green, B = blue }
    end
    return setmetatable(color, SColor)
end

---@comment Loads from R,G,B parameters
---@param red number
---@param green number
---@param blue number
---@return table
function SColor.FromRgb(red, green, blue)
    local color = { A = 255, R = red, G = green, B = blue }
    return setmetatable(color, SColor)
end

---@comment Returns color Brightness from 0 to 1
---@return number
function SColor:GetBrightness()
    local min, max = self:MinMaxRgb(self.R, self.G, self.B)
    return (max + min) / (255 * 2)
end

---@comment Returns color HUE from 0 to 360
---@return number
function SColor:GetHue()
    if (self.R == self.G and self.G == self.B) then
        return 0.0
    end
    local min, max = self:MinMaxRgb(self.R, self.G, self.B)
    local delta = max - min
    local hue

    if self.R == max then
        hue = (self.G - self.B) / delta
    elseif self.G == max then
        hue = (self.B - self.R) / delta + 2.0
    else
        hue = (self.R - self.G) / delta + 4.0
    end

    hue = hue * 60.0
    if hue < 0 then
        hue = hue + 360.0
    end

    return hue
end

---@comment Returns color Saturation from 0 to 1
---@return number
function SColor:GetSaturation()
    if (self.R == self.G and self.G == self.B) then
        return 0.0
    end

    local min, max = self:MinMaxRgb(self.R, self.G, self.B)

    local div = max + min
    if (div > 255) then
        div = 255 * 2 - max - min
    end

    return (max - min) / div
end

function SColor:MinMaxRgb(r, g, b)
    local min, max = 0, 0
    if r > g then
        max = r
        min = g
    else
        max = g
        min = r
    end
    if b > max then
        max = b
    elseif (b < min) then
        min = b
    end
    return min, max
end

---@comment Returns color in ARGBInt format
---@return number
function SColor:ToArgb()
    local result = (self.A << 24) | (self.R << 16) | (self.G << 8) | self.B
    if result > 2147483647 then
        result = result - 4294967296
    end
    return result
end

---@comment Returns color as Hex string
---@return string
function SColor:ToHex()
    return string.format("#%02X%02X%02X%02X", self.A, self.R, self.G, self.B)
end

---@comment Returns this color information as string
---@return string
function SColor:ToString()
    return "Color [A=" .. self.A .. ", R=:" .. self.R .. ", G=" .. self.G .. ", B=" .. self.B .. "] - INT=" .. self:ToArgb() .. " - HEX=" .. self:ToHex()
end

function SColor:__eq(other)
    return self:ToArgb() == other:ToArgb()
end

function SColor:__tostring()
    return self:ToString()
end

function SColor:__newindex(key, value)
    error("Cannot modify SColor")
end

--[[ WINDOWS SYSTEM COLORS ]]
SColor.Transparent = SColor.FromArgb(16777215)
SColor.AliceBlue = SColor.FromArgb(-984833)
SColor.AntiqueWhite = SColor.FromArgb(-332841)
SColor.Aqua = SColor.FromArgb(-16711681)
SColor.Aquamarine = SColor.FromArgb(-8388652)
SColor.Azure = SColor.FromArgb(-983041)
SColor.Beige = SColor.FromArgb(-657956)
SColor.Bisque = SColor.FromArgb(-6972)
SColor.Black = SColor.FromArgb(-16777216)
SColor.BlanchedAlmond = SColor.FromArgb(-5171)
SColor.Blue = SColor.FromArgb(-16776961)
SColor.BlueViolet = SColor.FromArgb(-7722014)
SColor.Brown = SColor.FromArgb(-5952982)
SColor.BurlyWood = SColor.FromArgb(-2180985)
SColor.CadetBlue = SColor.FromArgb(-10510688)
SColor.Chartreuse = SColor.FromArgb(-8388864)
SColor.Chocolate = SColor.FromArgb(-2987746)
SColor.Coral = SColor.FromArgb(-32944)
SColor.CornflowerBlue = SColor.FromArgb(-10185235)
SColor.Cornsilk = SColor.FromArgb(-1828)
SColor.Crimson = SColor.FromArgb(-2354116)
SColor.Cyan = SColor.FromArgb(-16711681)
SColor.DarkBlue = SColor.FromArgb(-16777077)
SColor.DarkCyan = SColor.FromArgb(-16741493)
SColor.DarkGoldenrod = SColor.FromArgb(-4684277)
SColor.DarkGray = SColor.FromArgb(-5658199)
SColor.DarkGreen = SColor.FromArgb(-16751616)
SColor.DarkKhaki = SColor.FromArgb(-4343957)
SColor.DarkMagenta = SColor.FromArgb(-7667573)
SColor.DarkOliveGreen = SColor.FromArgb(-11179217)
SColor.DarkOrange = SColor.FromArgb(-29696)
SColor.DarkOrchid = SColor.FromArgb(-6737204)
SColor.DarkRed = SColor.FromArgb(-7667712)
SColor.DarkSalmon = SColor.FromArgb(-1468806)
SColor.DarkSeaGreen = SColor.FromArgb(-7357301)
SColor.DarkSlateBlue = SColor.FromArgb(-12042869)
SColor.DarkSlateGray = SColor.FromArgb(-13676721)
SColor.DarkTurquoise = SColor.FromArgb(-16724271)
SColor.DarkViolet = SColor.FromArgb(-7077677)
SColor.DeepPink = SColor.FromArgb(-60269)
SColor.DeepSkyBlue = SColor.FromArgb(-16728065)
SColor.DimGray = SColor.FromArgb(-9868951)
SColor.DodgerBlue = SColor.FromArgb(-14774017)
SColor.Firebrick = SColor.FromArgb(-5103070)
SColor.FloralWhite = SColor.FromArgb(-1296)
SColor.ForestGreen = SColor.FromArgb(-14513374)
SColor.Fuchsia = SColor.FromArgb(-65281)
SColor.Gainsboro = SColor.FromArgb(-2302756)
SColor.GhostWhite = SColor.FromArgb(-460545)
SColor.Gold = SColor.FromArgb(-10496)
SColor.Goldenrod = SColor.FromArgb(-2448096)
SColor.Gray = SColor.FromArgb(-8355712)
SColor.Green = SColor.FromArgb(-16744448)
SColor.GreenYellow = SColor.FromArgb(-5374161)
SColor.Honeydew = SColor.FromArgb(-983056)
SColor.HotPink = SColor.FromArgb(-38476)
SColor.IndianRed = SColor.FromArgb(-3318692)
SColor.Indigo = SColor.FromArgb(-11861886)
SColor.Ivory = SColor.FromArgb(-16)
SColor.Khaki = SColor.FromArgb(-989556)
SColor.Lavender = SColor.FromArgb(-1644806)
SColor.LavenderBlush = SColor.FromArgb(-3851)
SColor.LawnGreen = SColor.FromArgb(-8586240)
SColor.LemonChiffon = SColor.FromArgb(-1331)
SColor.LightBlue = SColor.FromArgb(-5383962)
SColor.LightCoral = SColor.FromArgb(-1015680)
SColor.LightCyan = SColor.FromArgb(-2031617)
SColor.LightGoldenrodYellow = SColor.FromArgb(-329006)
SColor.LightGreen = SColor.FromArgb(-7278960)
SColor.LightGray = SColor.FromArgb(-2894893)
SColor.LightPink = SColor.FromArgb(-18751)
SColor.LightSalmon = SColor.FromArgb(-24454)
SColor.LightSeaGreen = SColor.FromArgb(-14634326)
SColor.LightSkyBlue = SColor.FromArgb(-7876870)
SColor.LightSlateGray = SColor.FromArgb(-8943463)
SColor.LightSteelBlue = SColor.FromArgb(-5192482)
SColor.LightYellow = SColor.FromArgb(-32)
SColor.Lime = SColor.FromArgb(-16711936)
SColor.LimeGreen = SColor.FromArgb(-13447886)
SColor.Linen = SColor.FromArgb(-331546)
SColor.Magenta = SColor.FromArgb(-65281)
SColor.Maroon = SColor.FromArgb(-8388608)
SColor.MediumAquamarine = SColor.FromArgb(-10039894)
SColor.MediumBlue = SColor.FromArgb(-16777011)
SColor.MediumOrchid = SColor.FromArgb(-4565549)
SColor.MediumPurple = SColor.FromArgb(-7114533)
SColor.MediumSeaGreen = SColor.FromArgb(-12799119)
SColor.MediumSlateBlue = SColor.FromArgb(-8689426)
SColor.MediumSpringGreen = SColor.FromArgb(-16713062)
SColor.MediumTurquoise = SColor.FromArgb(-12004916)
SColor.MediumVioletRed = SColor.FromArgb(-3730043)
SColor.MidnightBlue = SColor.FromArgb(-15132304)
SColor.MintCream = SColor.FromArgb(-655366)
SColor.MistyRose = SColor.FromArgb(-6943)
SColor.Moccasin = SColor.FromArgb(-6987)
SColor.NavajoWhite = SColor.FromArgb(-8531)
SColor.Navy = SColor.FromArgb(-16777088)
SColor.OldLace = SColor.FromArgb(-133658)
SColor.Olive = SColor.FromArgb(-8355840)
SColor.OliveDrab = SColor.FromArgb(-9728477)
SColor.Orange = SColor.FromArgb(-23296)
SColor.OrangeRed = SColor.FromArgb(-47872)
SColor.Orchid = SColor.FromArgb(-2461482)
SColor.PaleGoldenrod = SColor.FromArgb(-1120086)
SColor.PaleGreen = SColor.FromArgb(-6751336)
SColor.PaleTurquoise = SColor.FromArgb(-5247250)
SColor.PaleVioletRed = SColor.FromArgb(-2396013)
SColor.PapayaWhip = SColor.FromArgb(-4139)
SColor.PeachPuff = SColor.FromArgb(-9543)
SColor.Peru = SColor.FromArgb(-3308225)
SColor.Pink = SColor.FromArgb(-16181)
SColor.Plum = SColor.FromArgb(-2252579)
SColor.PowderBlue = SColor.FromArgb(-5185306)
SColor.Purple = SColor.FromArgb(-8388480)
SColor.Red = SColor.FromArgb(-65536)
SColor.RosyBrown = SColor.FromArgb(-4419697)
SColor.RoyalBlue = SColor.FromArgb(-12490271)
SColor.SaddleBrown = SColor.FromArgb(-7650029)
SColor.Salmon = SColor.FromArgb(-360334)
SColor.SandyBrown = SColor.FromArgb(-744352)
SColor.SeaGreen = SColor.FromArgb(-13726889)
SColor.SeaShell = SColor.FromArgb(-2578)
SColor.Sienna = SColor.FromArgb(-6270419)
SColor.Silver = SColor.FromArgb(-4144960)
SColor.SkyBlue = SColor.FromArgb(-7876885)
SColor.SlateBlue = SColor.FromArgb(-9807155)
SColor.SlateGray = SColor.FromArgb(-9404272)
SColor.Snow = SColor.FromArgb(-1286)
SColor.SpringGreen = SColor.FromArgb(-16711809)
SColor.SteelBlue = SColor.FromArgb(-12156236)
SColor.Tan = SColor.FromArgb(-2968436)
SColor.Teal = SColor.FromArgb(-16744320)
SColor.Thistle = SColor.FromArgb(-2572328)
SColor.Tomato = SColor.FromArgb(-40121)
SColor.Turquoise = SColor.FromArgb(-12525360)
SColor.Violet = SColor.FromArgb(-1146130)
SColor.Wheat = SColor.FromArgb(-663885)
SColor.White = SColor.FromArgb(-1)
SColor.WhiteSmoke = SColor.FromArgb(-657931)
SColor.Yellow = SColor.FromArgb(-256)
SColor.YellowGreen = SColor.FromArgb(-6632142)

--[[ GTA HUD COLORS ]]
SColor.HUD_None = SColor.FromArgb(-1)
SColor.HUD_Pure_white = SColor.FromHudColor(0)
SColor.HUD_White = SColor.FromHudColor(1)
SColor.HUD_Black = SColor.FromHudColor(2)
SColor.HUD_Grey = SColor.FromHudColor(3)
SColor.HUD_Greylight = SColor.FromHudColor(4)
SColor.HUD_Greydark = SColor.FromHudColor(5)
SColor.HUD_Red = SColor.FromHudColor(6)
SColor.HUD_Redlight = SColor.FromHudColor(7)
SColor.HUD_Reddark = SColor.FromHudColor(8)
SColor.HUD_Blue = SColor.FromHudColor(9)
SColor.HUD_Bluelight = SColor.FromHudColor(10)
SColor.HUD_Bluedark = SColor.FromHudColor(11)
SColor.HUD_Yellow = SColor.FromHudColor(12)
SColor.HUD_Yellowlight = SColor.FromHudColor(13)
SColor.HUD_Yellowdark = SColor.FromHudColor(14)
SColor.HUD_Orange = SColor.FromHudColor(15)
SColor.HUD_Orangelight = SColor.FromHudColor(16)
SColor.HUD_Orangedark = SColor.FromHudColor(17)
SColor.HUD_Green = SColor.FromHudColor(18)
SColor.HUD_Greenlight = SColor.FromHudColor(19)
SColor.HUD_Greendark = SColor.FromHudColor(20)
SColor.HUD_Purple = SColor.FromHudColor(21)
SColor.HUD_Purplelight = SColor.FromHudColor(22)
SColor.HUD_Purpledark = SColor.FromHudColor(23)
SColor.HUD_Pink = SColor.FromHudColor(24)
SColor.HUD_Radar_health = SColor.FromHudColor(25)
SColor.HUD_Radar_armour = SColor.FromHudColor(26)
SColor.HUD_Radar_damage = SColor.FromHudColor(27)
SColor.HUD_Net_player1 = SColor.FromHudColor(28)
SColor.HUD_Net_player2 = SColor.FromHudColor(29)
SColor.HUD_Net_player3 = SColor.FromHudColor(30)
SColor.HUD_Net_player4 = SColor.FromHudColor(31)
SColor.HUD_Net_player5 = SColor.FromHudColor(32)
SColor.HUD_Net_player6 = SColor.FromHudColor(33)
SColor.HUD_Net_player7 = SColor.FromHudColor(34)
SColor.HUD_Net_player8 = SColor.FromHudColor(35)
SColor.HUD_Net_player9 = SColor.FromHudColor(36)
SColor.HUD_Net_player10 = SColor.FromHudColor(37)
SColor.HUD_Net_player11 = SColor.FromHudColor(38)
SColor.HUD_Net_player12 = SColor.FromHudColor(39)
SColor.HUD_Net_player13 = SColor.FromHudColor(40)
SColor.HUD_Net_player14 = SColor.FromHudColor(41)
SColor.HUD_Net_player15 = SColor.FromHudColor(42)
SColor.HUD_Net_player16 = SColor.FromHudColor(43)
SColor.HUD_Net_player17 = SColor.FromHudColor(44)
SColor.HUD_Net_player18 = SColor.FromHudColor(45)
SColor.HUD_Net_player19 = SColor.FromHudColor(46)
SColor.HUD_Net_player20 = SColor.FromHudColor(47)
SColor.HUD_Net_player21 = SColor.FromHudColor(48)
SColor.HUD_Net_player22 = SColor.FromHudColor(49)
SColor.HUD_Net_player23 = SColor.FromHudColor(50)
SColor.HUD_Net_player24 = SColor.FromHudColor(51)
SColor.HUD_Net_player25 = SColor.FromHudColor(52)
SColor.HUD_Net_player26 = SColor.FromHudColor(53)
SColor.HUD_Net_player27 = SColor.FromHudColor(54)
SColor.HUD_Net_player28 = SColor.FromHudColor(55)
SColor.HUD_Net_player29 = SColor.FromHudColor(56)
SColor.HUD_Net_player30 = SColor.FromHudColor(57)
SColor.HUD_Net_player31 = SColor.FromHudColor(58)
SColor.HUD_Net_player32 = SColor.FromHudColor(59)
SColor.HUD_Simpleblip_default = SColor.FromHudColor(60)
SColor.HUD_Menu_blue = SColor.FromHudColor(61)
SColor.HUD_Menu_grey_light = SColor.FromHudColor(62)
SColor.HUD_Menu_blue_extra_dark = SColor.FromHudColor(63)
SColor.HUD_Menu_yellow = SColor.FromHudColor(64)
SColor.HUD_Menu_yellow_dark = SColor.FromHudColor(65)
SColor.HUD_Menu_green = SColor.FromHudColor(66)
SColor.HUD_Menu_grey = SColor.FromHudColor(67)
SColor.HUD_Menu_grey_dark = SColor.FromHudColor(68)
SColor.HUD_Menu_highlight = SColor.FromHudColor(69)
SColor.HUD_Menu_standard = SColor.FromHudColor(70)
SColor.HUD_Menu_dimmed = SColor.FromHudColor(71)
SColor.HUD_Menu_extra_dimmed = SColor.FromHudColor(72)
SColor.HUD_Brief_title = SColor.FromHudColor(73)
SColor.HUD_Mid_grey_mp = SColor.FromHudColor(74)
SColor.HUD_Net_player1_dark = SColor.FromHudColor(75)
SColor.HUD_Net_player2_dark = SColor.FromHudColor(76)
SColor.HUD_Net_player3_dark = SColor.FromHudColor(77)
SColor.HUD_Net_player4_dark = SColor.FromHudColor(78)
SColor.HUD_Net_player5_dark = SColor.FromHudColor(79)
SColor.HUD_Net_player6_dark = SColor.FromHudColor(80)
SColor.HUD_Net_player7_dark = SColor.FromHudColor(81)
SColor.HUD_Net_player8_dark = SColor.FromHudColor(82)
SColor.HUD_Net_player9_dark = SColor.FromHudColor(83)
SColor.HUD_Net_player10_dark = SColor.FromHudColor(84)
SColor.HUD_Net_player11_dark = SColor.FromHudColor(85)
SColor.HUD_Net_player12_dark = SColor.FromHudColor(86)
SColor.HUD_Net_player13_dark = SColor.FromHudColor(87)
SColor.HUD_Net_player14_dark = SColor.FromHudColor(88)
SColor.HUD_Net_player15_dark = SColor.FromHudColor(89)
SColor.HUD_Net_player16_dark = SColor.FromHudColor(90)
SColor.HUD_Net_player17_dark = SColor.FromHudColor(91)
SColor.HUD_Net_player18_dark = SColor.FromHudColor(92)
SColor.HUD_Net_player19_dark = SColor.FromHudColor(93)
SColor.HUD_Net_player20_dark = SColor.FromHudColor(94)
SColor.HUD_Net_player21_dark = SColor.FromHudColor(95)
SColor.HUD_Net_player22_dark = SColor.FromHudColor(96)
SColor.HUD_Net_player23_dark = SColor.FromHudColor(97)
SColor.HUD_Net_player24_dark = SColor.FromHudColor(98)
SColor.HUD_Net_player25_dark = SColor.FromHudColor(99)
SColor.HUD_Net_player26_dark = SColor.FromHudColor(100)
SColor.HUD_Net_player27_dark = SColor.FromHudColor(101)
SColor.HUD_Net_player28_dark = SColor.FromHudColor(102)
SColor.HUD_Net_player29_dark = SColor.FromHudColor(103)
SColor.HUD_Net_player30_dark = SColor.FromHudColor(104)
SColor.HUD_Net_player31_dark = SColor.FromHudColor(105)
SColor.HUD_Net_player32_dark = SColor.FromHudColor(106)
SColor.HUD_Bronze = SColor.FromHudColor(107)
SColor.HUD_Silver = SColor.FromHudColor(108)
SColor.HUD_Gold = SColor.FromHudColor(109)
SColor.HUD_Platinum = SColor.FromHudColor(110)
SColor.HUD_Gang1 = SColor.FromHudColor(111)
SColor.HUD_Gang2 = SColor.FromHudColor(112)
SColor.HUD_Gang3 = SColor.FromHudColor(113)
SColor.HUD_Gang4 = SColor.FromHudColor(114)
SColor.HUD_Same_crew = SColor.FromHudColor(115)
SColor.HUD_Freemode = SColor.FromHudColor(116)
SColor.HUD_Pause_bg = SColor.FromHudColor(117)
SColor.HUD_Friendly = SColor.FromHudColor(118)
SColor.HUD_Enemy = SColor.FromHudColor(119)
SColor.HUD_Location = SColor.FromHudColor(120)
SColor.HUD_Pickup = SColor.FromHudColor(121)
SColor.HUD_Pause_singleplayer = SColor.FromHudColor(122)
SColor.HUD_Freemode_dark = SColor.FromHudColor(123)
SColor.HUD_Inactive_mission = SColor.FromHudColor(124)
SColor.HUD_Damage = SColor.FromHudColor(125)
SColor.HUD_Pinklight = SColor.FromHudColor(126)
SColor.HUD_Pm_mitem_highlight = SColor.FromHudColor(127)
SColor.HUD_Script_variable = SColor.FromHudColor(128)
SColor.HUD_Yoga = SColor.FromHudColor(129)
SColor.HUD_Tennis = SColor.FromHudColor(130)
SColor.HUD_Golf = SColor.FromHudColor(131)
SColor.HUD_Shooting_range = SColor.FromHudColor(132)
SColor.HUD_Flight_school = SColor.FromHudColor(133)
SColor.HUD_North_blue = SColor.FromHudColor(134)
SColor.HUD_Social_club = SColor.FromHudColor(135)
SColor.HUD_Platform_blue = SColor.FromHudColor(136)
SColor.HUD_Platform_green = SColor.FromHudColor(137)
SColor.HUD_Platform_grey = SColor.FromHudColor(138)
SColor.HUD_Facebook_blue = SColor.FromHudColor(139)
SColor.HUD_Ingame_bg = SColor.FromHudColor(140)
SColor.HUD_Darts = SColor.FromHudColor(141)
SColor.HUD_Waypoint = SColor.FromHudColor(142)
SColor.HUD_Michael = SColor.FromHudColor(143)
SColor.HUD_Franklin = SColor.FromHudColor(144)
SColor.HUD_Trevor = SColor.FromHudColor(145)
SColor.HUD_Golf_p1 = SColor.FromHudColor(146)
SColor.HUD_Golf_p2 = SColor.FromHudColor(147)
SColor.HUD_Golf_p3 = SColor.FromHudColor(148)
SColor.HUD_Golf_p4 = SColor.FromHudColor(149)
SColor.HUD_Waypointlight = SColor.FromHudColor(150)
SColor.HUD_Waypointdark = SColor.FromHudColor(151)
SColor.HUD_Panel_light = SColor.FromHudColor(152)
SColor.HUD_Michael_dark = SColor.FromHudColor(153)
SColor.HUD_Franklin_dark = SColor.FromHudColor(154)
SColor.HUD_Trevor_dark = SColor.FromHudColor(155)
SColor.HUD_Objective_route = SColor.FromHudColor(156)
SColor.HUD_Pausemap_tint = SColor.FromHudColor(157)
SColor.HUD_Pause_deselect = SColor.FromHudColor(158)
SColor.HUD_Pm_weapons_purchasable = SColor.FromHudColor(159)
SColor.HUD_Pm_weapons_locked = SColor.FromHudColor(160)
SColor.HUD_End_screen_bg = SColor.FromHudColor(161)
SColor.HUD_Chop = SColor.FromHudColor(162)
SColor.HUD_Pausemap_tint_half = SColor.FromHudColor(163)
SColor.HUD_North_blue_official = SColor.FromHudColor(164)
SColor.HUD_Script_variable_2 = SColor.FromHudColor(165)
SColor.HUD_H = SColor.FromHudColor(166)
SColor.HUD_Hdark = SColor.FromHudColor(167)
SColor.HUD_T = SColor.FromHudColor(168)
SColor.HUD_Tdark = SColor.FromHudColor(169)
SColor.HUD_Hshard = SColor.FromHudColor(170)
SColor.HUD_Controller_michael = SColor.FromHudColor(171)
SColor.HUD_Controller_franklin = SColor.FromHudColor(172)
SColor.HUD_Controller_trevor = SColor.FromHudColor(173)
SColor.HUD_Controller_chop = SColor.FromHudColor(174)
SColor.HUD_Video_editor_video = SColor.FromHudColor(175)
SColor.HUD_Video_editor_audio = SColor.FromHudColor(176)
SColor.HUD_Video_editor_text = SColor.FromHudColor(177)
SColor.HUD_Hb_blue = SColor.FromHudColor(178)
SColor.HUD_Hb_yellow = SColor.FromHudColor(179)
SColor.HUD_Video_editor_score = SColor.FromHudColor(180)
SColor.HUD_Video_editor_audio_fadeout = SColor.FromHudColor(181)
SColor.HUD_Video_editor_text_fadeout = SColor.FromHudColor(182)
SColor.HUD_Video_editor_score_fadeout = SColor.FromHudColor(183)
SColor.HUD_Heist_background = SColor.FromHudColor(184)
SColor.HUD_Video_editor_ambient = SColor.FromHudColor(185)
SColor.HUD_Video_editor_ambient_fadeout = SColor.FromHudColor(186)
SColor.HUD_Gb = SColor.FromHudColor(187)
SColor.HUD_G = SColor.FromHudColor(188)
SColor.HUD_B = SColor.FromHudColor(189)
SColor.HUD_Low_flow = SColor.FromHudColor(190)
SColor.HUD_Low_flow_dark = SColor.FromHudColor(191)
SColor.HUD_G1 = SColor.FromHudColor(192)
SColor.HUD_G2 = SColor.FromHudColor(193)
SColor.HUD_G3 = SColor.FromHudColor(194)
SColor.HUD_G4 = SColor.FromHudColor(195)
SColor.HUD_G5 = SColor.FromHudColor(196)
SColor.HUD_G6 = SColor.FromHudColor(197)
SColor.HUD_G7 = SColor.FromHudColor(198)
SColor.HUD_G8 = SColor.FromHudColor(199)
SColor.HUD_G9 = SColor.FromHudColor(200)
SColor.HUD_G10 = SColor.FromHudColor(201)
SColor.HUD_G11 = SColor.FromHudColor(202)
SColor.HUD_G12 = SColor.FromHudColor(203)
SColor.HUD_G13 = SColor.FromHudColor(204)
SColor.HUD_G14 = SColor.FromHudColor(205)
SColor.HUD_G15 = SColor.FromHudColor(206)
SColor.HUD_Adversary = SColor.FromHudColor(207)
SColor.HUD_Degen_red = SColor.FromHudColor(208)
SColor.HUD_Degen_yellow = SColor.FromHudColor(209)
SColor.HUD_Degen_green = SColor.FromHudColor(210)
SColor.HUD_Degen_cyan = SColor.FromHudColor(211)
SColor.HUD_Degen_blue = SColor.FromHudColor(212)
SColor.HUD_Degen_magenta = SColor.FromHudColor(213)
SColor.HUD_Stunt_1 = SColor.FromHudColor(214)
SColor.HUD_Stunt_2 = SColor.FromHudColor(215)
SColor.HUD_Special_race_series = SColor.FromHudColor(216)
SColor.HUD_Special_race_series_dark = SColor.FromHudColor(217)
SColor.HUD_Cs = SColor.FromHudColor(218)
SColor.HUD_Cs_dark = SColor.FromHudColor(219)
SColor.HUD_Tech_green = SColor.FromHudColor(220)
SColor.HUD_Tech_green_dark = SColor.FromHudColor(221)
SColor.HUD_Tech_red = SColor.FromHudColor(222)
SColor.HUD_Tech_green_very_dark = SColor.FromHudColor(223)
--[[ END COLORS DECLARATION ]]
