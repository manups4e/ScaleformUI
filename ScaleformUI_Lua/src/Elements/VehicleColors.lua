VehicleColors = setmetatable({}, VehicleColors)
VehicleColors.__index = VehicleColors
VehicleColors.__call = function()
    return "VehicleColors"
end

---@class VehicleColors
---@field public GetColorById fun(self: VehicleColors, id:integer)
---@field public GetColorByRGB fun(self: VehicleColors, r:integer, g:integer, b:integer)
---@field public IsCustomColor fun(self: VehicleColors, r:integer, g:integer, b:integer)
---@field public GetColorBySColor fun(self: VehicleColors, color:SColor)
---@field public Metallic_Black SColor
---@field public Metallic_Graphite_Black SColor
---@field public Metallic_Black_Steal SColor
---@field public Metallic_Dark_Silver SColor
---@field public Metallic_Silver SColor
---@field public Metallic_Blue_Silver SColor
---@field public Metallic_Steel_Gray SColor
---@field public Metallic_Shadow_Silver SColor
---@field public Metallic_Stone_Silver SColor
---@field public Metallic_Midnight_Silver SColor
---@field public Metallic_Gun_Metal SColor
---@field public Metallic_Anthracite_Grey SColor
---@field public Matte_Black SColor
---@field public Matte_Gray SColor
---@field public Matte_Light_Grey SColor
---@field public Util_Black SColor
---@field public Util_Black_Poly SColor
---@field public Util_Dark_silver SColor
---@field public Util_Silver SColor
---@field public Util_Gun_Metal SColor
---@field public Util_Shadow_Silver SColor
---@field public Worn_Black SColor
---@field public Worn_Graphite SColor
---@field public Worn_Silver_Grey SColor
---@field public Worn_Silver SColor
---@field public Worn_Blue_Silver SColor
---@field public Worn_Shadow_Silver SColor
---@field public Metallic_Red SColor
---@field public Metallic_Torino_Red SColor
---@field public Metallic_Formula_Red SColor
---@field public Metallic_Blaze_Red SColor
---@field public Metallic_Graceful_Red SColor
---@field public Metallic_Garnet_Red SColor
---@field public Metallic_Desert_Red SColor
---@field public Metallic_Cabernet_Red SColor
---@field public Metallic_Candy_Red SColor
---@field public Metallic_Sunrise_Orange SColor
---@field public Metallic_Classic_Gold SColor
---@field public Metallic_Orange SColor
---@field public Matte_Red SColor
---@field public Matte_Dark_Red SColor
---@field public Matte_Orange SColor
---@field public Matte_Yellow SColor
---@field public Util_Red SColor
---@field public Util_Bright_Red SColor
---@field public Util_Garnet_Red SColor
---@field public Worn_Red SColor
---@field public Worn_Golden_Red SColor
---@field public Worn_Dark_Red SColor
---@field public Metallic_Dark_Green SColor
---@field public Metallic_Racing_Green SColor
---@field public Metallic_Sea_Green SColor
---@field public Metallic_Olive_Green SColor
---@field public Metallic_Green SColor
---@field public Metallic_Gasoline_Blue_Green SColor
---@field public Matte_Lime_Green SColor
---@field public Util_Dark_Green SColor
---@field public Util_Green SColor
---@field public Worn_Dark_Green SColor
---@field public Worn_Green SColor
---@field public Worn_Sea_Wash SColor
---@field public Metallic_Midnight_Blue SColor
---@field public Metallic_Dark_Blue SColor
---@field public Metallic_Saxony_Blue SColor
---@field public Metallic_Blue SColor
---@field public Metallic_Mariner_Blue SColor
---@field public Metallic_Harbor_Blue SColor
---@field public Metallic_Diamond_Blue SColor
---@field public Metallic_Surf_Blue SColor
---@field public Metallic_Nautical_Blue SColor
---@field public Metallic_Bright_Blue SColor
---@field public Metallic_Purple_Blue SColor
---@field public Metallic_Spinnaker_Blue SColor
---@field public Metallic_Ultra_Blue SColor
---@field public Dark_Pastel_Blue SColor
---@field public Util_Dark_Blue SColor
---@field public Util_Midnight_Blue SColor
---@field public Util_Blue SColor
---@field public Util_Sea_Foam_Blue SColor
---@field public Util_Lightning_blue SColor
---@field public Util_Maui_Blue_Poly SColor
---@field public Util_Bright_Blue SColor
---@field public Matte_Dark_Blue SColor
---@field public Matte_Blue SColor
---@field public Matte_Midnight_Blue SColor
---@field public Worn_Dark_blue SColor
---@field public Worn_Blue SColor
---@field public Worn_Light_blue SColor
---@field public Metallic_Taxi_Yellow SColor
---@field public Metallic_Race_Yellow SColor
---@field public Metallic_Bronze SColor
---@field public Metallic_Yellow_Bird SColor
---@field public Metallic_Lime SColor
---@field public Metallic_Champagne SColor
---@field public Metallic_Pueblo_Beige SColor
---@field public Metallic_Dark_Ivory SColor
---@field public Metallic_Choco_Brown SColor
---@field public Metallic_Golden_Brown SColor
---@field public Metallic_Light_Brown SColor
---@field public Metallic_Straw_Beige SColor
---@field public Metallic_Moss_Brown SColor
---@field public Metallic_Biston_Brown SColor
---@field public Metallic_Beechwood SColor
---@field public Metallic_Dark_Beechwood SColor
---@field public Metallic_Choco_Orange SColor
---@field public Metallic_Beach_Sand SColor
---@field public Metallic_Sun_Bleeched_Sand SColor
---@field public Metallic_Cream SColor
---@field public Util_Brown SColor
---@field public Util_Medium_Brown SColor
---@field public Util_Light_Brown SColor
---@field public Metallic_White SColor
---@field public Metallic_Frost_White SColor
---@field public Worn_Honey_Beige SColor
---@field public Worn_Brown SColor
---@field public Worn_Dark_Brown SColor
---@field public Worn_straw_beige SColor
---@field public Brushed_Steel SColor
---@field public Brushed_Black_steel SColor
---@field public Brushed_Aluminium SColor
---@field public Chrome SColor
---@field public Worn_Off_White SColor
---@field public Util_Off_White SColor
---@field public Worn_Orange SColor
---@field public Worn_Light_Orange SColor
---@field public Metallic_Securicor_Green SColor
---@field public Worn_Taxi_Yellow SColor
---@field public Police_Car_Blue SColor
---@field public Matte_Green SColor
---@field public Matte_Brown SColor
---@field public Texas_Rose SColor
---@field public Matte_White SColor
---@field public Worn_White SColor
---@field public Worn_Olive_Army_Green SColor
---@field public Pure_White SColor
---@field public Hot_Pink SColor
---@field public Salmon_pink SColor
---@field public Metallic_Vermillion_Pink SColor
---@field public Orange_ SColor
---@field public Green_ SColor
---@field public Blue_ SColor
---@field public Mettalic_Black_Blue SColor
---@field public Metallic_Black_Purple SColor
---@field public Metallic_Black_Red SColor
---@field public Hunter_Green SColor
---@field public Metallic_Purple SColor
---@field public Metaillic_V_Dark_Blue SColor
---@field public MODSHOP_BLACK1 SColor
---@field public Matte_Purple SColor
---@field public Matte_Dark_Purple SColor
---@field public Metallic_Lava_Red SColor
---@field public Matte_Forest_Green SColor
---@field public Matte_Olive_Drab SColor
---@field public Matte_Desert_Brown SColor
---@field public Matte_Desert_Tan SColor
---@field public Matte_Foilage_Green SColor
---@field public DEFAULT_ALLOY_COLOR SColor
---@field public Epsilon_Blue SColor
---@field public Pure_Gold SColor
---@field public Brushed_Gold SColor

Metallic_Black = SColor.FromArgb(255, 13, 17, 22);                 --i: 0
Metallic_Graphite_Black = SColor.FromArgb(255, 28, 29, 33);        --i: 1
Metallic_Black_Steal = SColor.FromArgb(255, 50, 56, 61);           --i: 2
Metallic_Dark_Silver = SColor.FromArgb(255, 69, 75, 79);           --i: 3
Metallic_Silver = SColor.FromArgb(255, 153, 157, 160);             --i: 4
Metallic_Blue_Silver = SColor.FromArgb(255, 194, 196, 198);        --i: 5
Metallic_Steel_Gray = SColor.FromArgb(255, 151, 154, 151);         --i: 6
Metallic_Shadow_Silver = SColor.FromArgb(255, 99, 115, 128);       --i: 7
Metallic_Stone_Silver = SColor.FromArgb(255, 99, 98, 92);          --i: 8
Metallic_Midnight_Silver = SColor.FromArgb(255, 60, 63, 71);       --i: 9
Metallic_Gun_Metal = SColor.FromArgb(255, 68, 78, 84);             --i: 10
Metallic_Anthracite_Grey = SColor.FromArgb(255, 29, 33, 41);       --i: 11
Matte_Black = SColor.FromArgb(255, 19, 24, 31);                    --i: 12
Matte_Gray = SColor.FromArgb(255, 38, 40, 42);                     --i: 13
Matte_Light_Grey = SColor.FromArgb(255, 81, 85, 84);               --i: 14
Util_Black = SColor.FromArgb(255, 21, 25, 33);                     --i: 15
Util_Black_Poly = SColor.FromArgb(255, 30, 36, 41);                --i: 16
Util_Dark_silver = SColor.FromArgb(255, 51, 58, 60);               --i: 17
Util_Silver = SColor.FromArgb(255, 140, 144, 149);                 --i: 18
Util_Gun_Metal = SColor.FromArgb(255, 57, 67, 77);                 --i: 19
Util_Shadow_Silver = SColor.FromArgb(255, 80, 98, 114);            --i: 20
Worn_Black = SColor.FromArgb(255, 30, 35, 47);                     --i: 21
Worn_Graphite = SColor.FromArgb(255, 54, 58, 63);                  --i: 22
Worn_Silver_Grey = SColor.FromArgb(255, 160, 161, 153);            --i: 23
Worn_Silver = SColor.FromArgb(255, 211, 211, 211);                 --i: 24
Worn_Blue_Silver = SColor.FromArgb(255, 183, 191, 202);            --i: 25
Worn_Shadow_Silver = SColor.FromArgb(255, 119, 135, 148);          --i: 26
Metallic_Red = SColor.FromArgb(255, 192, 14, 26);                  --i: 27
Metallic_Torino_Red = SColor.FromArgb(255, 218, 25, 24);           --i: 28
Metallic_Formula_Red = SColor.FromArgb(255, 182, 17, 27);          --i: 29
Metallic_Blaze_Red = SColor.FromArgb(255, 165, 30, 35);            --i: 30
Metallic_Graceful_Red = SColor.FromArgb(255, 123, 26, 34);         --i: 31
Metallic_Garnet_Red = SColor.FromArgb(255, 142, 27, 31);           --i: 32
Metallic_Desert_Red = SColor.FromArgb(255, 111, 24, 24);           --i: 33
Metallic_Cabernet_Red = SColor.FromArgb(255, 73, 17, 29);          --i: 34
Metallic_Candy_Red = SColor.FromArgb(255, 182, 15, 37);            --i: 35
Metallic_Sunrise_Orange = SColor.FromArgb(255, 212, 74, 23);       --i: 36
Metallic_Classic_Gold = SColor.FromArgb(255, 194, 148, 79);        --i: 37
Metallic_Orange = SColor.FromArgb(255, 247, 134, 22);              --i: 38
Matte_Red = SColor.FromArgb(255, 207, 31, 33);                     --i: 39
Matte_Dark_Red = SColor.FromArgb(255, 115, 32, 33);                --i: 40
Matte_Orange = SColor.FromArgb(255, 242, 125, 32);                 --i: 41
Matte_Yellow = SColor.FromArgb(255, 255, 201, 31);                 --i: 42
Util_Red = SColor.FromArgb(255, 156, 16, 22);                      --i: 43
Util_Bright_Red = SColor.FromArgb(255, 222, 15, 24);               --i: 44
Util_Garnet_Red = SColor.FromArgb(255, 143, 30, 23);               --i: 45
Worn_Red = SColor.FromArgb(255, 169, 71, 68);                      --i: 46
Worn_Golden_Red = SColor.FromArgb(255, 177, 108, 81);              --i: 47
Worn_Dark_Red = SColor.FromArgb(255, 55, 28, 37);                  --i: 48
Metallic_Dark_Green = SColor.FromArgb(255, 19, 36, 40);            --i: 49
Metallic_Racing_Green = SColor.FromArgb(255, 18, 46, 43);          --i: 50
Metallic_Sea_Green = SColor.FromArgb(255, 18, 56, 60);             --i: 51
Metallic_Olive_Green = SColor.FromArgb(255, 49, 66, 63);           --i: 52
Metallic_Green = SColor.FromArgb(255, 21, 92, 45);                 --i: 53
Metallic_Gasoline_Blue_Green = SColor.FromArgb(255, 27, 103, 112); --i: 54
Matte_Lime_Green = SColor.FromArgb(255, 102, 184, 31);             --i: 55
Util_Dark_Green = SColor.FromArgb(255, 34, 56, 62);                --i: 56
Util_Green = SColor.FromArgb(255, 29, 90, 63);                     --i: 57
Worn_Dark_Green = SColor.FromArgb(255, 45, 66, 63);                --i: 58
Worn_Green = SColor.FromArgb(255, 69, 89, 75);                     --i: 59
Worn_Sea_Wash = SColor.FromArgb(255, 101, 134, 127);               --i: 60
Metallic_Midnight_Blue = SColor.FromArgb(255, 34, 46, 70);         --i: 61
Metallic_Dark_Blue = SColor.FromArgb(255, 35, 49, 85);             --i: 62
Metallic_Saxony_Blue = SColor.FromArgb(255, 48, 76, 126);          --i: 63
Metallic_Blue = SColor.FromArgb(255, 71, 87, 143);                 --i: 64
Metallic_Mariner_Blue = SColor.FromArgb(255, 99, 123, 167);        --i: 65
Metallic_Harbor_Blue = SColor.FromArgb(255, 57, 71, 98);           --i: 66
Metallic_Diamond_Blue = SColor.FromArgb(255, 214, 231, 241);       --i: 67
Metallic_Surf_Blue = SColor.FromArgb(255, 118, 175, 190);          --i: 68
Metallic_Nautical_Blue = SColor.FromArgb(255, 52, 94, 114);        --i: 69
Metallic_Bright_Blue = SColor.FromArgb(255, 11, 156, 241);         --i: 70
Metallic_Purple_Blue = SColor.FromArgb(255, 47, 45, 82);           --i: 71
Metallic_Spinnaker_Blue = SColor.FromArgb(255, 40, 44, 77);        --i: 72
Metallic_Ultra_Blue = SColor.FromArgb(255, 35, 84, 161);           --i: 73
Dark_Pastel_Blue = SColor.FromArgb(255, 110, 163, 198);            --i: 74
Util_Dark_Blue = SColor.FromArgb(255, 17, 37, 82);                 --i: 75
Util_Midnight_Blue = SColor.FromArgb(255, 27, 32, 62);             --i: 76
Util_Blue = SColor.FromArgb(255, 39, 81, 144);                     --i: 77
Util_Sea_Foam_Blue = SColor.FromArgb(255, 96, 133, 146);           --i: 78
Util_Lightning_blue = SColor.FromArgb(255, 36, 70, 168);           --i: 79
Util_Maui_Blue_Poly = SColor.FromArgb(255, 66, 113, 225);          --i: 80
Util_Bright_Blue = SColor.FromArgb(255, 59, 57, 224);              --i: 81
Matte_Dark_Blue = SColor.FromArgb(255, 31, 40, 82);                --i: 82
Matte_Blue = SColor.FromArgb(255, 37, 58, 167);                    --i: 83
Matte_Midnight_Blue = SColor.FromArgb(255, 28, 53, 81);            --i: 84
Worn_Dark_blue = SColor.FromArgb(255, 76, 95, 129);                --i: 85
Worn_Blue = SColor.FromArgb(255, 88, 104, 142);                    --i: 86
Worn_Light_blue = SColor.FromArgb(255, 116, 181, 216);             --i: 87
Metallic_Taxi_Yellow = SColor.FromArgb(255, 255, 207, 32);         --i: 88
Metallic_Race_Yellow = SColor.FromArgb(255, 251, 226, 18);         --i: 89
Metallic_Bronze = SColor.FromArgb(255, 145, 101, 50);              --i: 90
Metallic_Yellow_Bird = SColor.FromArgb(255, 224, 225, 61);         --i: 91
Metallic_Lime = SColor.FromArgb(255, 152, 210, 35);                --i: 92
Metallic_Champagne = SColor.FromArgb(255, 155, 140, 120);          --i: 93
Metallic_Pueblo_Beige = SColor.FromArgb(255, 80, 50, 24);          --i: 94
Metallic_Dark_Ivory = SColor.FromArgb(255, 71, 63, 43);            --i: 95
Metallic_Choco_Brown = SColor.FromArgb(255, 34, 27, 25);           --i: 96
Metallic_Golden_Brown = SColor.FromArgb(255, 101, 63, 35);         --i: 97
Metallic_Light_Brown = SColor.FromArgb(255, 119, 92, 62);          --i: 98
Metallic_Straw_Beige = SColor.FromArgb(255, 172, 153, 117);        --i: 99
Metallic_Moss_Brown = SColor.FromArgb(255, 108, 107, 75);          --i: 100
Metallic_Biston_Brown = SColor.FromArgb(255, 64, 46, 43);          --i: 101
Metallic_Beechwood = SColor.FromArgb(255, 164, 150, 95);           --i: 102
Metallic_Dark_Beechwood = SColor.FromArgb(255, 70, 35, 26);        --i: 103
Metallic_Choco_Orange = SColor.FromArgb(255, 117, 43, 25);         --i: 104
Metallic_Beach_Sand = SColor.FromArgb(255, 191, 174, 123);         --i: 105
Metallic_Sun_Bleeched_Sand = SColor.FromArgb(255, 223, 213, 178);  --i: 106
Metallic_Cream = SColor.FromArgb(255, 247, 237, 213);              --i: 107
Util_Brown = SColor.FromArgb(255, 58, 42, 27);                     --i: 108
Util_Medium_Brown = SColor.FromArgb(255, 120, 95, 51);             --i: 109
Util_Light_Brown = SColor.FromArgb(255, 181, 160, 121);            --i: 110
Metallic_White = SColor.FromArgb(255, 255, 255, 246);              --i: 111
Metallic_Frost_White = SColor.FromArgb(255, 234, 234, 234);        --i: 112
Worn_Honey_Beige = SColor.FromArgb(255, 176, 171, 148);            --i: 113
Worn_Brown = SColor.FromArgb(255, 69, 56, 49);                     --i: 114
Worn_Dark_Brown = SColor.FromArgb(255, 42, 40, 43);                --i: 115
Worn_straw_beige = SColor.FromArgb(255, 114, 108, 87);             --i: 116
Brushed_Steel = SColor.FromArgb(255, 106, 116, 124);               --i: 117
Brushed_Black_steel = SColor.FromArgb(255, 53, 65, 88);            --i: 118
Brushed_Aluminium = SColor.FromArgb(255, 155, 160, 168);           --i: 119
Chrome = SColor.FromArgb(255, 88, 112, 161);                       --i: 120
Worn_Off_White = SColor.FromArgb(255, 234, 230, 222);              --i: 121
Util_Off_White = SColor.FromArgb(255, 223, 221, 208);              --i: 122
Worn_Orange = SColor.FromArgb(255, 242, 173, 46);                  --i: 123
Worn_Light_Orange = SColor.FromArgb(255, 249, 164, 88);            --i: 124
Metallic_Securicor_Green = SColor.FromArgb(255, 131, 197, 102);    --i: 125
Worn_Taxi_Yellow = SColor.FromArgb(255, 241, 204, 64);             --i: 126
Police_Car_Blue = SColor.FromArgb(255, 76, 195, 218);              --i: 127
Matte_Green = SColor.FromArgb(255, 78, 100, 67);                   --i: 128
Matte_Brown = SColor.FromArgb(255, 188, 172, 143);                 --i: 129
Texas_Rose = SColor.FromArgb(255, 248, 182, 88);                   --i: 130
Matte_White = SColor.FromArgb(255, 252, 249, 241);                 --i: 131
Worn_White = SColor.FromArgb(255, 255, 255, 251);                  --i: 132
Worn_Olive_Army_Green = SColor.FromArgb(255, 129, 132, 76);        --i: 133
Pure_White = SColor.FromArgb(255, 255, 255, 255);                  --i: 134
Hot_Pink = SColor.FromArgb(255, 242, 31, 153);                     --i: 135
Salmon_pink = SColor.FromArgb(255, 253, 214, 205);                 --i: 136
Metallic_Vermillion_Pink = SColor.FromArgb(255, 223, 88, 145);     --i: 137
Orange_ = SColor.FromArgb(255, 246, 174, 32);                      --i: 138
Green_ = SColor.FromArgb(255, 176, 238, 110);                      --i: 139
Blue_ = SColor.FromArgb(255, 8, 233, 250);                         --i: 140
Mettalic_Black_Blue = SColor.FromArgb(255, 10, 12, 23);            --i: 141
Metallic_Black_Purple = SColor.FromArgb(255, 12, 13, 24);          --i: 142
Metallic_Black_Red = SColor.FromArgb(255, 14, 13, 20);             --i: 143
Hunter_green = SColor.FromArgb(255, 159, 158, 138);                --i: 144
Metallic_Purple = SColor.FromArgb(255, 98, 18, 118);               --i: 145
Metaillic_V_Dark_Blue = SColor.FromArgb(255, 11, 20, 33);          --i: 146
MODSHOP_BLACK1 = SColor.FromArgb(255, 17, 20, 26);                 --i: 147
Matte_Purple = SColor.FromArgb(255, 107, 31, 123);                 --i: 148
Matte_Dark_Purple = SColor.FromArgb(255, 30, 29, 34);              --i: 149
Metallic_Lava_Red = SColor.FromArgb(255, 188, 25, 23);             --i: 150
Matte_Forest_Green = SColor.FromArgb(255, 45, 54, 42);             --i: 151
Matte_Olive_Drab = SColor.FromArgb(255, 105, 103, 72);             --i: 152
Matte_Desert_Brown = SColor.FromArgb(255, 122, 108, 85);           --i: 153
Matte_Desert_Tan = SColor.FromArgb(255, 195, 180, 146);            --i: 154
Matte_Foilage_Green = SColor.FromArgb(255, 90, 99, 82);            --i: 155
DEFAULT_ALLOY_COLOR = SColor.FromArgb(255, 129, 130, 127);         --i: 156
Epsilon_Blue = SColor.FromArgb(255, 175, 214, 228);                --i: 157
Pure_Gold = SColor.FromArgb(255, 122, 100, 64);                    --i: 158
Brushed_Gold = SColor.FromArgb(255, 127, 106, 72);                 --i: 159

local vehColors = {
    [0] = SColor.FromArgb(255, 13, 17, 22),
    [1] = SColor.FromArgb(255, 28, 29, 33),
    [2] = SColor.FromArgb(255, 50, 56, 61),
    [3] = SColor.FromArgb(255, 69, 75, 79),
    [4] = SColor.FromArgb(255, 153, 157, 160),
    [5] = SColor.FromArgb(255, 194, 196, 198),
    [6] = SColor.FromArgb(255, 151, 154, 151),
    [7] = SColor.FromArgb(255, 99, 115, 128),
    [8] = SColor.FromArgb(255, 99, 98, 92),
    [9] = SColor.FromArgb(255, 60, 63, 71),
    [10] = SColor.FromArgb(255, 68, 78, 84),
    [11] = SColor.FromArgb(255, 29, 33, 41),
    [12] = SColor.FromArgb(255, 19, 24, 31),
    [13] = SColor.FromArgb(255, 38, 40, 42),
    [14] = SColor.FromArgb(255, 81, 85, 84),
    [15] = SColor.FromArgb(255, 21, 25, 33),
    [16] = SColor.FromArgb(255, 30, 36, 41),
    [17] = SColor.FromArgb(255, 51, 58, 60),
    [18] = SColor.FromArgb(255, 140, 144, 149),
    [19] = SColor.FromArgb(255, 57, 67, 77),
    [20] = SColor.FromArgb(255, 80, 98, 114),
    [21] = SColor.FromArgb(255, 30, 35, 47),
    [22] = SColor.FromArgb(255, 54, 58, 63),
    [23] = SColor.FromArgb(255, 160, 161, 153),
    [24] = SColor.FromArgb(255, 211, 211, 211),
    [25] = SColor.FromArgb(255, 183, 191, 202),
    [26] = SColor.FromArgb(255, 119, 135, 148),
    [27] = SColor.FromArgb(255, 192, 14, 26),
    [28] = SColor.FromArgb(255, 218, 25, 24),
    [29] = SColor.FromArgb(255, 182, 17, 27),
    [30] = SColor.FromArgb(255, 165, 30, 35),
    [31] = SColor.FromArgb(255, 123, 26, 34),
    [32] = SColor.FromArgb(255, 142, 27, 31),
    [33] = SColor.FromArgb(255, 111, 24, 24),
    [34] = SColor.FromArgb(255, 73, 17, 29),
    [35] = SColor.FromArgb(255, 182, 15, 37),
    [36] = SColor.FromArgb(255, 212, 74, 23),
    [37] = SColor.FromArgb(255, 194, 148, 79),
    [38] = SColor.FromArgb(255, 247, 134, 22),
    [39] = SColor.FromArgb(255, 207, 31, 33),
    [40] = SColor.FromArgb(255, 115, 32, 33),
    [41] = SColor.FromArgb(255, 242, 125, 32),
    [42] = SColor.FromArgb(255, 255, 201, 31),
    [43] = SColor.FromArgb(255, 156, 16, 22),
    [44] = SColor.FromArgb(255, 222, 15, 24),
    [45] = SColor.FromArgb(255, 143, 30, 23),
    [46] = SColor.FromArgb(255, 169, 71, 68),
    [47] = SColor.FromArgb(255, 177, 108, 81),
    [48] = SColor.FromArgb(255, 55, 28, 37),
    [49] = SColor.FromArgb(255, 19, 36, 40),
    [50] = SColor.FromArgb(255, 18, 46, 43),
    [51] = SColor.FromArgb(255, 18, 56, 60),
    [52] = SColor.FromArgb(255, 49, 66, 63),
    [53] = SColor.FromArgb(255, 21, 92, 45),
    [54] = SColor.FromArgb(255, 27, 103, 112),
    [55] = SColor.FromArgb(255, 102, 184, 31),
    [56] = SColor.FromArgb(255, 34, 56, 62),
    [57] = SColor.FromArgb(255, 29, 90, 63),
    [58] = SColor.FromArgb(255, 45, 66, 63),
    [59] = SColor.FromArgb(255, 69, 89, 75),
    [60] = SColor.FromArgb(255, 101, 134, 127),
    [61] = SColor.FromArgb(255, 34, 46, 70),
    [62] = SColor.FromArgb(255, 35, 49, 85),
    [63] = SColor.FromArgb(255, 48, 76, 126),
    [64] = SColor.FromArgb(255, 71, 87, 143),
    [65] = SColor.FromArgb(255, 99, 123, 167),
    [66] = SColor.FromArgb(255, 57, 71, 98),
    [67] = SColor.FromArgb(255, 214, 231, 241),
    [68] = SColor.FromArgb(255, 118, 175, 190),
    [69] = SColor.FromArgb(255, 52, 94, 114),
    [70] = SColor.FromArgb(255, 11, 156, 241),
    [71] = SColor.FromArgb(255, 47, 45, 82),
    [72] = SColor.FromArgb(255, 40, 44, 77),
    [73] = SColor.FromArgb(255, 35, 84, 161),
    [74] = SColor.FromArgb(255, 110, 163, 198),
    [75] = SColor.FromArgb(255, 17, 37, 82),
    [76] = SColor.FromArgb(255, 27, 32, 62),
    [77] = SColor.FromArgb(255, 39, 81, 144),
    [78] = SColor.FromArgb(255, 96, 133, 146),
    [79] = SColor.FromArgb(255, 36, 70, 168),
    [80] = SColor.FromArgb(255, 66, 113, 225),
    [81] = SColor.FromArgb(255, 59, 57, 224),
    [82] = SColor.FromArgb(255, 31, 40, 82),
    [83] = SColor.FromArgb(255, 37, 58, 167),
    [84] = SColor.FromArgb(255, 28, 53, 81),
    [85] = SColor.FromArgb(255, 76, 95, 129),
    [86] = SColor.FromArgb(255, 88, 104, 142),
    [87] = SColor.FromArgb(255, 116, 181, 216),
    [88] = SColor.FromArgb(255, 255, 207, 32),
    [89] = SColor.FromArgb(255, 251, 226, 18),
    [90] = SColor.FromArgb(255, 145, 101, 50),
    [91] = SColor.FromArgb(255, 224, 225, 61),
    [92] = SColor.FromArgb(255, 152, 210, 35),
    [93] = SColor.FromArgb(255, 155, 140, 120),
    [94] = SColor.FromArgb(255, 80, 50, 24),
    [95] = SColor.FromArgb(255, 71, 63, 43),
    [96] = SColor.FromArgb(255, 34, 27, 25),
    [97] = SColor.FromArgb(255, 101, 63, 35),
    [98] = SColor.FromArgb(255, 119, 92, 62),
    [99] = SColor.FromArgb(255, 172, 153, 117),
    [100] = SColor.FromArgb(255, 108, 107, 75),
    [101] = SColor.FromArgb(255, 64, 46, 43),
    [102] = SColor.FromArgb(255, 164, 150, 95),
    [103] = SColor.FromArgb(255, 70, 35, 26),
    [104] = SColor.FromArgb(255, 117, 43, 25),
    [105] = SColor.FromArgb(255, 191, 174, 123),
    [106] = SColor.FromArgb(255, 223, 213, 178),
    [107] = SColor.FromArgb(255, 247, 237, 213),
    [108] = SColor.FromArgb(255, 58, 42, 27),
    [109] = SColor.FromArgb(255, 120, 95, 51),
    [110] = SColor.FromArgb(255, 181, 160, 121),
    [111] = SColor.FromArgb(255, 255, 255, 246),
    [112] = SColor.FromArgb(255, 234, 234, 234),
    [113] = SColor.FromArgb(255, 176, 171, 148),
    [114] = SColor.FromArgb(255, 69, 56, 49),
    [115] = SColor.FromArgb(255, 42, 40, 43),
    [116] = SColor.FromArgb(255, 114, 108, 87),
    [117] = SColor.FromArgb(255, 106, 116, 124),
    [118] = SColor.FromArgb(255, 53, 65, 88),
    [119] = SColor.FromArgb(255, 155, 160, 168),
    [120] = SColor.FromArgb(255, 88, 112, 161),
    [121] = SColor.FromArgb(255, 234, 230, 222),
    [122] = SColor.FromArgb(255, 223, 221, 208),
    [123] = SColor.FromArgb(255, 242, 173, 46),
    [124] = SColor.FromArgb(255, 249, 164, 88),
    [125] = SColor.FromArgb(255, 131, 197, 102),
    [126] = SColor.FromArgb(255, 241, 204, 64),
    [127] = SColor.FromArgb(255, 76, 195, 218),
    [128] = SColor.FromArgb(255, 78, 100, 67),
    [129] = SColor.FromArgb(255, 188, 172, 143),
    [130] = SColor.FromArgb(255, 248, 182, 88),
    [131] = SColor.FromArgb(255, 252, 249, 241),
    [132] = SColor.FromArgb(255, 255, 255, 251),
    [133] = SColor.FromArgb(255, 129, 132, 76),
    [134] = SColor.FromArgb(255, 255, 255, 255),
    [135] = SColor.FromArgb(255, 242, 31, 153),
    [136] = SColor.FromArgb(255, 253, 214, 205),
    [137] = SColor.FromArgb(255, 223, 88, 145),
    [138] = SColor.FromArgb(255, 246, 174, 32),
    [139] = SColor.FromArgb(255, 176, 238, 110),
    [140] = SColor.FromArgb(255, 8, 233, 250),
    [141] = SColor.FromArgb(255, 10, 12, 23),
    [142] = SColor.FromArgb(255, 12, 13, 24),
    [143] = SColor.FromArgb(255, 14, 13, 20),
    [144] = SColor.FromArgb(255, 159, 158, 138),
    [145] = SColor.FromArgb(255, 98, 18, 118),
    [146] = SColor.FromArgb(255, 11, 20, 33),
    [147] = SColor.FromArgb(255, 17, 20, 26),
    [148] = SColor.FromArgb(255, 107, 31, 123),
    [149] = SColor.FromArgb(255, 30, 29, 34),
    [150] = SColor.FromArgb(255, 188, 25, 23),
    [151] = SColor.FromArgb(255, 45, 54, 42),
    [152] = SColor.FromArgb(255, 105, 103, 72),
    [153] = SColor.FromArgb(255, 122, 108, 85),
    [154] = SColor.FromArgb(255, 195, 180, 146),
    [155] = SColor.FromArgb(255, 90, 99, 82),
    [156] = SColor.FromArgb(255, 129, 130, 127),
    [157] = SColor.FromArgb(255, 175, 214, 228),
    [158] = SColor.FromArgb(255, 122, 100, 64),
    [159] = SColor.FromArgb(255, 127, 106, 72)
};

function VehicleColors:GetColorById(id)
    return vehColors[id];
end

function VehicleColors:GetColorByRGB(r, g, b)
    if (IsCustomColor(r, g, b)) then
        return -1;
    end
    for k, v in pairs(vehColors) do
        if v.R == color.R and v.G == color.G and v.B == color.B then
            return k
        end
    end
end

function VehicleColors:IsCustomColor(r, g, b)
    for k, v in pairs(vehColors) do
        if v.R == color.R and v.G == color.G and v.B == color.B then
            return false
        end
    end
    return true
end

function VehicleColors:GetColorBySColor(color)
    if (IsCustomColor(color.R, color.G, color.B)) then
        return -1;
    end
    for k, v in pairs(vehColors) do
        if v.R == color.R and v.G == color.G and v.B == color.B then
            return k
        end
    end
end