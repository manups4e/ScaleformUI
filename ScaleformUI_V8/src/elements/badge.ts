import {isOneOfEnum} from "../helpers/collections";

export enum BadgeStyle {
    NONE = 0,
    LOCK = 1,
    STAR = 2,
    WARNING = 3,
    CROWN = 4,
    MEDAL_BRONZE = 5,
    MEDAL_GOLD = 6,
    MEDAL_SILVER = 7,
    CASH = 8,
    COKE = 9,
    HEROIN = 10,
    METH = 11,
    WEED = 12,
    AMMO = 13,
    ARMOR = 14,
    BARBER = 15,
    CLOTHING = 16,
    FRANKLIN = 17,
    BIKE = 18,
    CAR = 19,
    GUN = 20,
    HEALTH_HEART = 21,
    MAKEUP_BRUSH = 22,
    MASK = 23,
    MICHAEL = 24,
    TATTOO = 25,
    TICK = 26,
    TREVOR = 27,
    FEMALE = 28,
    MALE = 29,
    LOCK_ARENA = 30,
    ADVERSARY = 31,
    BASE_JUMPING = 32,
    BRIEFCASE = 33,
    MISSION_STAR = 34,
    DEATHMATCH = 35,
    CASTLE = 36,
    TROPHY = 37,
    RACE_FLAG = 38,
    RACE_FLAG_PLANE = 39,
    RACE_FLAG_BICYCLE = 40,
    RACE_FLAG_PERSON = 41,
    RACE_FLAG_CAR = 42,
    RACE_FLAG_BOAT_ANCHOR = 43,
    ROCKSTAR = 44,
    STUNT = 45,
    STUNT_PREMIUM = 46,
    RACE_FLAG_STUNT_JUMP = 47,
    SHIELD = 48,
    TEAM_DEATHMATCH = 49,
    VEHICLE_DEATHMATCH = 50,
    MP_AMMO_PICKUP = 51,
    MP_AMMO = 52,
    MP_CASH = 53,
    MP_RP = 54,
    MP_SPECTATING = 55,
    SALE = 56,
    GLOBE_WHITE = 57,
    GLOBE_RED = 58,
    GLOBE_BLUE = 59,
    GLOBE_YELLOW = 60,
    GLOBE_GREEN = 61,
    GLOBE_ORANGE = 62,
    INV_ARM_WRESTLING = 63,
    INV_BASEJUMP = 64,
    INV_MISSION = 65,
    INV_DARTS = 66,
    INV_DEATHMATCH = 67,
    INV_DRUG = 68,
    INV_CASTLE = 69,
    INV_GOLF = 70,
    INV_BIKE = 71,
    INV_BOAT = 72,
    INV_ANCHOR = 73,
    INV_CAR = 74,
    INV_DOLLAR = 75,
    INV_COKE = 76,
    INV_KEY = 77,
    INV_DATA = 78,
    INV_HELI = 79,
    INV_HEORIN = 80,
    INV_KEYCARD = 81,
    INV_METH = 82,
    INV_BRIEFCASE = 83,
    INV_LINK = 84,
    INV_PERSON = 85,
    INV_PLANE = 86,
    INV_PLANE2 = 87,
    INV_QUESTIONMARK = 88,
    INV_REMOTE = 89,
    INV_SAFE = 90,
    INV_STEER_WHEEL = 91,
    INV_WEAPON = 92,
    INV_WEED = 93,
    INV_RACE_FLAG_PLANE = 94,
    INV_RACE_FLAG_BICYCLE = 95,
    INV_RACE_FLAG_BOAT_ANCHOR = 96,
    INV_RACE_FLAG_PERSON = 97,
    INV_RACE_FLAG_CAR = 98,
    INV_RACE_FLAG_HELMET = 99,
    INV_SHOOTING_RANGE = 100,
    INV_SURVIVAL = 101,
    INV_TEAM_DEATHMATCH = 102,
    INV_TENNIS = 103,
    INV_VEHICLE_DEATHMATCH = 104,
    AUDIO_MUTE = 105,
    AUDIO_INACTIVE = 106,
    AUDIO_VOL1 = 107,
    AUDIO_VOL2 = 108,
    AUDIO_VOL3 = 109,
    COUNTRY_USA = 110,
    COUNTRY_UK = 111,
    COUNTRY_SWEDEN = 112,
    COUNTRY_KOREA = 113,
    COUNTRY_JAPAN = 114,
    COUNTRY_ITALY = 115,
    COUNTRY_GERMANY = 116,
    COUNTRY_FRANCE = 117,
    BRAND_ALBANY = 118,
    BRAND_ANNIS = 119,
    BRAND_BANSHEE = 120,
    BRAND_BENEFACTOR = 121,
    BRAND_BF = 122,
    BRAND_BOLLOKAN = 123,
    BRAND_BRAVADO = 124,
    BRAND_BRUTE = 125,
    BRAND_BUCKINGHAM = 126,
    BRAND_CANIS = 127,
    BRAND_CHARIOT = 128,
    BRAND_CHEVAL = 129,
    BRAND_CLASSIQUE = 130,
    BRAND_COIL = 131,
    BRAND_DECLASSE = 132,
    BRAND_DEWBAUCHEE = 133,
    BRAND_DILETTANTE = 134,
    BRAND_DINKA = 135,
    BRAND_DUNDREARY = 136,
    BRAND_EMPORER = 137,
    BRAND_ENUS = 138,
    BRAND_FATHOM = 139,
    BRAND_GALIVANTER = 140,
    BRAND_GROTTI = 141,
    BRAND_GROTTI2 = 142,
    BRAND_HIJAK = 143,
    BRAND_HVY = 144,
    BRAND_IMPONTE = 145,
    BRAND_INVETERO = 146,
    BRAND_JACKSHEEPE = 147,
    BRAND_LCC = 148,
    BRAND_JOBUILT = 149,
    BRAND_KARIN = 150,
    BRAND_LAMPADATI = 151,
    BRAND_MAIBATSU = 152,
    BRAND_MAMMOTH = 153,
    BRAND_MTL = 154,
    BRAND_NAGASAKI = 155,
    BRAND_OBEY = 156,
    BRAND_OCELOT = 157,
    BRAND_OVERFLOD = 158,
    BRAND_PED = 159,
    BRAND_PEGASSI = 160,
    BRAND_PFISTER = 161,
    BRAND_PRINCIPE = 162,
    BRAND_PROGEN = 163,
    BRAND_PROGEN2 = 164,
    BRAND_RUNE = 165,
    BRAND_SCHYSTER = 166,
    BRAND_SHITZU = 167,
    BRAND_SPEEDOPHILE = 168,
    BRAND_STANLEY = 169,
    BRAND_TRUFFADE = 170,
    BRAND_UBERMACHT = 171,
    BRAND_VAPID = 172,
    BRAND_VULCAR = 173,
    BRAND_WEENY = 174,
    BRAND_WESTERN = 175,
    BRAND_WESTERNMOTORCYCLE = 176,
    BRAND_WILLARD = 177,
    BRAND_ZIRCONIUM = 178,
    INFO = 179
}
export function getSpriteDictionary(icon: BadgeStyle): string {
    if (isOneOfEnum(icon, [BadgeStyle.MALE, BadgeStyle.FEMALE, BadgeStyle.AUDIO_MUTE, BadgeStyle.AUDIO_INACTIVE, BadgeStyle.AUDIO_VOL1, BadgeStyle.AUDIO_VOL2, BadgeStyle.AUDIO_VOL3])) {
        return "mpleaderboard";
    } else if (isOneOfEnum(icon, [BadgeStyle.INV_ARM_WRESTLING, BadgeStyle.INV_BASEJUMP, BadgeStyle.INV_MISSION, BadgeStyle.INV_DARTS, BadgeStyle.INV_DEATHMATCH, BadgeStyle.INV_DRUG, BadgeStyle.INV_CASTLE, BadgeStyle.INV_GOLF, BadgeStyle.INV_BIKE, BadgeStyle.INV_BOAT, BadgeStyle.INV_ANCHOR, BadgeStyle.INV_CAR, BadgeStyle.INV_DOLLAR, BadgeStyle.INV_COKE, BadgeStyle.INV_KEY, BadgeStyle.INV_DATA, BadgeStyle.INV_HELI, BadgeStyle.INV_HEORIN, BadgeStyle.INV_KEYCARD, BadgeStyle.INV_METH, BadgeStyle.INV_BRIEFCASE, BadgeStyle.INV_LINK, BadgeStyle.INV_PERSON, BadgeStyle.INV_PLANE, BadgeStyle.INV_PLANE2, BadgeStyle.INV_QUESTIONMARK, BadgeStyle.INV_REMOTE, BadgeStyle.INV_SAFE, BadgeStyle.INV_STEER_WHEEL, BadgeStyle.INV_WEAPON, BadgeStyle.INV_WEED, BadgeStyle.INV_RACE_FLAG_PLANE, BadgeStyle.INV_RACE_FLAG_BICYCLE, BadgeStyle.INV_RACE_FLAG_BOAT_ANCHOR, BadgeStyle.INV_RACE_FLAG_PERSON, BadgeStyle.INV_RACE_FLAG_CAR, BadgeStyle.INV_RACE_FLAG_HELMET, BadgeStyle.INV_SHOOTING_RANGE, BadgeStyle.INV_SURVIVAL, BadgeStyle.INV_TEAM_DEATHMATCH, BadgeStyle.INV_TENNIS, BadgeStyle.INV_VEHICLE_DEATHMATCH])) {
        return "mpinventory";
    } else if (isOneOfEnum(icon, [BadgeStyle.ADVERSARY, BadgeStyle.BASE_JUMPING, BadgeStyle.BRIEFCASE, BadgeStyle.MISSION_STAR, BadgeStyle.DEATHMATCH, BadgeStyle.CASTLE, BadgeStyle.TROPHY, BadgeStyle.RACE_FLAG, BadgeStyle.RACE_FLAG_PLANE, BadgeStyle.RACE_FLAG_BICYCLE, BadgeStyle.RACE_FLAG_PERSON, BadgeStyle.RACE_FLAG_CAR, BadgeStyle.RACE_FLAG_BOAT_ANCHOR, BadgeStyle.ROCKSTAR, BadgeStyle.STUNT, BadgeStyle.STUNT_PREMIUM, BadgeStyle.RACE_FLAG_STUNT_JUMP, BadgeStyle.SHIELD, BadgeStyle.TEAM_DEATHMATCH, BadgeStyle.VEHICLE_DEATHMATCH])) {
        return "commonmenutu";
    } else if (isOneOfEnum(icon, [BadgeStyle.MP_AMMO_PICKUP, BadgeStyle.MP_AMMO, BadgeStyle.MP_CASH, BadgeStyle.MP_RP, BadgeStyle.MP_SPECTATING])) {
        return "mphud";
    } else if (isOneOfEnum(icon, [BadgeStyle.SALE])) {
        return "mpshopsale";
    } else if (isOneOfEnum(icon, [BadgeStyle.GLOBE_WHITE, BadgeStyle.GLOBE_RED, BadgeStyle.GLOBE_BLUE, BadgeStyle.GLOBE_YELLOW, BadgeStyle.GLOBE_GREEN, BadgeStyle.GLOBE_ORANGE])) {
        return "mprankbadge";
    } else if (isOneOfEnum(icon, [BadgeStyle.COUNTRY_USA, BadgeStyle.COUNTRY_UK, BadgeStyle.COUNTRY_SWEDEN, BadgeStyle.COUNTRY_KOREA, BadgeStyle.COUNTRY_JAPAN, BadgeStyle.COUNTRY_ITALY, BadgeStyle.COUNTRY_GERMANY, BadgeStyle.COUNTRY_FRANCE, BadgeStyle.BRAND_ALBANY, BadgeStyle.BRAND_ANNIS, BadgeStyle.BRAND_BANSHEE, BadgeStyle.BRAND_BENEFACTOR, BadgeStyle.BRAND_BF, BadgeStyle.BRAND_BOLLOKAN, BadgeStyle.BRAND_BRAVADO, BadgeStyle.BRAND_BRUTE, BadgeStyle.BRAND_BUCKINGHAM, BadgeStyle.BRAND_CANIS, BadgeStyle.BRAND_CHARIOT, BadgeStyle.BRAND_CHEVAL, BadgeStyle.BRAND_CLASSIQUE, BadgeStyle.BRAND_COIL, BadgeStyle.BRAND_DECLASSE, BadgeStyle.BRAND_DEWBAUCHEE, BadgeStyle.BRAND_DILETTANTE, BadgeStyle.BRAND_DINKA, BadgeStyle.BRAND_DUNDREARY, BadgeStyle.BRAND_EMPORER, BadgeStyle.BRAND_ENUS, BadgeStyle.BRAND_FATHOM, BadgeStyle.BRAND_GALIVANTER, BadgeStyle.BRAND_GROTTI, BadgeStyle.BRAND_HIJAK, BadgeStyle.BRAND_HVY, BadgeStyle.BRAND_IMPONTE, BadgeStyle.BRAND_INVETERO, BadgeStyle.BRAND_JACKSHEEPE, BadgeStyle.BRAND_JOBUILT, BadgeStyle.BRAND_KARIN, BadgeStyle.BRAND_LAMPADATI, BadgeStyle.BRAND_MAIBATSU, BadgeStyle.BRAND_MAMMOTH, BadgeStyle.BRAND_MTL, BadgeStyle.BRAND_NAGASAKI, BadgeStyle.BRAND_OBEY, BadgeStyle.BRAND_OCELOT, BadgeStyle.BRAND_OVERFLOD, BadgeStyle.BRAND_PED, BadgeStyle.BRAND_PEGASSI, BadgeStyle.BRAND_PFISTER, BadgeStyle.BRAND_PRINCIPE, BadgeStyle.BRAND_PROGEN, BadgeStyle.BRAND_SCHYSTER, BadgeStyle.BRAND_SHITZU, BadgeStyle.BRAND_SPEEDOPHILE, BadgeStyle.BRAND_STANLEY, BadgeStyle.BRAND_TRUFFADE, BadgeStyle.BRAND_UBERMACHT, BadgeStyle.BRAND_VAPID, BadgeStyle.BRAND_VULCAR, BadgeStyle.BRAND_WEENY, BadgeStyle.BRAND_WESTERN, BadgeStyle.BRAND_WESTERNMOTORCYCLE, BadgeStyle.BRAND_WILLARD, BadgeStyle.BRAND_ZIRCONIUM])) {
        return "mpcarhud";
    } else if (isOneOfEnum(icon, [BadgeStyle.BRAND_GROTTI2, BadgeStyle.BRAND_LCC, BadgeStyle.BRAND_PROGEN2, BadgeStyle.BRAND_RUNE])) {
        return "mpcarhud2";
    } else if (isOneOfEnum(icon, [BadgeStyle.INFO])) {
        return "shared";
    } else {
        return "commonmenu";
    }
}

export function getSpriteName(icon: BadgeStyle, selected: boolean): string {
    switch (icon) {
        case BadgeStyle.AMMO:
            return selected ? "shop_ammo_icon_b" : "shop_ammo_icon_a";
        case BadgeStyle.ARMOR:
            return selected ? "shop_armour_icon_b" : "shop_armour_icon_a";
        case BadgeStyle.BARBER:
            return selected ? "shop_barber_icon_b" : "shop_barber_icon_a";
        case BadgeStyle.BIKE:
            return selected ? "shop_garage_bike_icon_b" : "shop_garage_bike_icon_a";
        case BadgeStyle.CAR:
            return selected ? "shop_garage_icon_b" : "shop_garage_icon_a";
        case BadgeStyle.CASH:
            return "mp_specitem_cash";
        case BadgeStyle.CLOTHING:
            return selected ? "shop_clothing_icon_b" : "shop_clothing_icon_a";
        case BadgeStyle.COKE:
            return "mp_specitem_coke";
        case BadgeStyle.CROWN:
            return "mp_hostcrown";
        case BadgeStyle.FRANKLIN:
            return selected ? "shop_franklin_icon_b" : "shop_franklin_icon_a";
        case BadgeStyle.GUN:
            return selected ? "shop_gunclub_icon_b" : "shop_gunclub_icon_a";
        case BadgeStyle.HEALTH_HEART:
            return selected ? "shop_health_icon_b" : "shop_health_icon_a";
        case BadgeStyle.HEROIN:
            return "mp_specitem_heroin";
        case BadgeStyle.LOCK:
            return "shop_lock";
        case BadgeStyle.MAKEUP_BRUSH:
            return selected ? "shop_makeup_icon_b" : "shop_makeup_icon_a";
        case BadgeStyle.MASK:
            return selected ? "shop_mask_icon_b" : "shop_mask_icon_a";
        case BadgeStyle.MEDAL_BRONZE:
            return "mp_medal_bronze";
        case BadgeStyle.MEDAL_GOLD:
            return "mp_medal_gold";
        case BadgeStyle.MEDAL_SILVER:
            return "mp_medal_silver";
        case BadgeStyle.METH:
            return "mp_specitem_meth";
        case BadgeStyle.MICHAEL:
            return selected ? "shop_michael_icon_b" : "shop_michael_icon_a";
        case BadgeStyle.STAR:
            return "shop_new_star";
        case BadgeStyle.TATTOO:
            return selected ? "shop_tattoos_icon_b" : "shop_tattoos_icon_a";
        case BadgeStyle.TICK:
            return "shop_tick_icon";
        case BadgeStyle.TREVOR:
            return selected ? "shop_trevor_icon_b" : "shop_trevor_icon_a";
        case BadgeStyle.WARNING:
            return "mp_alerttriangle";
        case BadgeStyle.WEED:
            return "mp_specitem_weed";
        case BadgeStyle.MALE:
            return "leaderboard_male_icon";
        case BadgeStyle.FEMALE:
            return "leaderboard_female_icon";
        case BadgeStyle.LOCK_ARENA:
            return "shop_lock_arena";
        case BadgeStyle.ADVERSARY:
            return "adversary";
        case BadgeStyle.BASE_JUMPING:
            return "base_jumping";
        case BadgeStyle.BRIEFCASE:
            return "capture_the_flag";
        case BadgeStyle.MISSION_STAR:
            return "custom_mission";
        case BadgeStyle.DEATHMATCH:
            return "deathmatch";
        case BadgeStyle.CASTLE:
            return "gang_attack";
        case BadgeStyle.TROPHY:
            return "last_team_standing";
        case BadgeStyle.RACE_FLAG:
            return "race";
        case BadgeStyle.RACE_FLAG_PLANE:
            return "race_air";
        case BadgeStyle.RACE_FLAG_BICYCLE:
            return "race_bicycle";
        case BadgeStyle.RACE_FLAG_PERSON:
            return "race_foot";
        case BadgeStyle.RACE_FLAG_CAR:
            return "race_land";
        case BadgeStyle.RACE_FLAG_BOAT_ANCHOR:
            return "race_water";
        case BadgeStyle.ROCKSTAR:
            return "rockstar";
        case BadgeStyle.STUNT:
            return "stunt";
        case BadgeStyle.STUNT_PREMIUM:
            return "stunt_premium";
        case BadgeStyle.RACE_FLAG_STUNT_JUMP:
            return "stunt_race";
        case BadgeStyle.SHIELD:
            return "survival";
        case BadgeStyle.TEAM_DEATHMATCH:
            return "team_deathmatch";
        case BadgeStyle.VEHICLE_DEATHMATCH:
            return "vehicle_deathmatch";
        case BadgeStyle.MP_AMMO_PICKUP:
            return "ammo_pickup";
        case BadgeStyle.MP_AMMO:
            return "mp_anim_ammo";
        case BadgeStyle.MP_CASH:
            return "mp_anim_cash";
        case BadgeStyle.MP_RP:
            return "mp_anim_rp";
        case BadgeStyle.MP_SPECTATING:
            return "spectating";
        case BadgeStyle.SALE:
            return "saleicon";
        case BadgeStyle.GLOBE_WHITE:
        case BadgeStyle.GLOBE_RED:
        case BadgeStyle.GLOBE_BLUE:
        case BadgeStyle.GLOBE_YELLOW:
        case BadgeStyle.GLOBE_GREEN:
        case BadgeStyle.GLOBE_ORANGE:
            return "globe";
        case BadgeStyle.INV_ARM_WRESTLING:
            return "arm_wrestling";
        case BadgeStyle.INV_BASEJUMP:
            return "basejump";
        case BadgeStyle.INV_MISSION:
            return "custom_mission";
        case BadgeStyle.INV_DARTS:
            return "darts";
        case BadgeStyle.INV_DEATHMATCH:
            return "deathmatch";
        case BadgeStyle.INV_DRUG:
            return "drug_trafficking";
        case BadgeStyle.INV_CASTLE:
            return "gang_attack";
        case BadgeStyle.INV_GOLF:
            return "golf";
        case BadgeStyle.INV_BIKE:
            return "mp_specitem_bike";
        case BadgeStyle.INV_BOAT:
            return "mp_specitem_boat";
        case BadgeStyle.INV_ANCHOR:
            return "mp_specitem_boatpickup";
        case BadgeStyle.INV_CAR:
            return "mp_specitem_car";
        case BadgeStyle.INV_DOLLAR:
            return "mp_specitem_cash";
        case BadgeStyle.INV_COKE:
            return "mp_specitem_coke";
        case BadgeStyle.INV_KEY:
            return "mp_specitem_cuffkeys";
        case BadgeStyle.INV_DATA:
            return "mp_specitem_data";
        case BadgeStyle.INV_HELI:
            return "mp_specitem_heli";
        case BadgeStyle.INV_HEORIN:
            return "mp_specitem_heroin";
        case BadgeStyle.INV_KEYCARD:
            return "mp_specitem_keycard";
        case BadgeStyle.INV_METH:
            return "mp_specitem_meth";
        case BadgeStyle.INV_BRIEFCASE:
            return "mp_specitem_package";
        case BadgeStyle.INV_LINK:
            return "mp_specitem_partnericon";
        case BadgeStyle.INV_PERSON:
            return "mp_specitem_ped";
        case BadgeStyle.INV_PLANE:
            return "mp_specitem_plane";
        case BadgeStyle.INV_PLANE2:
            return "mp_specitem_plane2";
        case BadgeStyle.INV_QUESTIONMARK:
            return "mp_specitem_randomobject";
        case BadgeStyle.INV_REMOTE:
            return "mp_specitem_remote";
        case BadgeStyle.INV_SAFE:
            return "mp_specitem_safe";
        case BadgeStyle.INV_STEER_WHEEL:
            return "mp_specitem_steer_wheel";
        case BadgeStyle.INV_WEAPON:
            return "mp_specitem_weapons";
        case BadgeStyle.INV_WEED:
            return "mp_specitem_weed";
        case BadgeStyle.INV_RACE_FLAG_PLANE:
            return "race_air";
        case BadgeStyle.INV_RACE_FLAG_BICYCLE:
            return "race_bike";
        case BadgeStyle.INV_RACE_FLAG_BOAT_ANCHOR:
            return "race_boat";
        case BadgeStyle.INV_RACE_FLAG_PERSON:
            return "race_foot";
        case BadgeStyle.INV_RACE_FLAG_CAR:
            return "race_land";
        case BadgeStyle.INV_RACE_FLAG_HELMET:
            return "race_offroad";
        case BadgeStyle.INV_SHOOTING_RANGE:
            return "shooting_range";
        case BadgeStyle.INV_SURVIVAL:
            return "survival";
        case BadgeStyle.INV_TEAM_DEATHMATCH:
            return "team_deathmatch";
        case BadgeStyle.INV_TENNIS:
            return "tennis";
        case BadgeStyle.INV_VEHICLE_DEATHMATCH:
            return "vehicle_deathmatch";
        case BadgeStyle.AUDIO_MUTE:
            return "leaderboard_audio_mute";
        case BadgeStyle.AUDIO_INACTIVE:
            return "leaderboard_audio_inactive";
        case BadgeStyle.AUDIO_VOL1:
            return "leaderboard_audio_1";
        case BadgeStyle.AUDIO_VOL2:
            return "leaderboard_audio_2";
        case BadgeStyle.AUDIO_VOL3:
            return "leaderboard_audio_3";
        case BadgeStyle.COUNTRY_USA:
            return "vehicle_card_icons_flag_usa";
        case BadgeStyle.COUNTRY_UK:
            return "vehicle_card_icons_flag_uk";
        case BadgeStyle.COUNTRY_SWEDEN:
            return "vehicle_card_icons_flag_sweden";
        case BadgeStyle.COUNTRY_KOREA:
            return "vehicle_card_icons_flag_korea";
        case BadgeStyle.COUNTRY_JAPAN:
            return "vehicle_card_icons_flag_japan";
        case BadgeStyle.COUNTRY_ITALY:
            return "vehicle_card_icons_flag_italy";
        case BadgeStyle.COUNTRY_GERMANY:
            return "vehicle_card_icons_flag_germany";
        case BadgeStyle.COUNTRY_FRANCE:
            return "vehicle_card_icons_flag_france";
        case BadgeStyle.BRAND_ALBANY:
            return "albany";
        case BadgeStyle.BRAND_ANNIS:
            return "annis";
        case BadgeStyle.BRAND_BANSHEE:
            return "banshee";
        case BadgeStyle.BRAND_BENEFACTOR:
            return "benefactor";
        case BadgeStyle.BRAND_BF:
            return "bf";
        case BadgeStyle.BRAND_BOLLOKAN:
            return "bollokan";
        case BadgeStyle.BRAND_BRAVADO:
            return "bravado";
        case BadgeStyle.BRAND_BRUTE:
            return "brute";
        case BadgeStyle.BRAND_BUCKINGHAM:
            return "buckingham";
        case BadgeStyle.BRAND_CANIS:
            return "canis";
        case BadgeStyle.BRAND_CHARIOT:
            return "chariot";
        case BadgeStyle.BRAND_CHEVAL:
            return "cheval";
        case BadgeStyle.BRAND_CLASSIQUE:
            return "classique";
        case BadgeStyle.BRAND_COIL:
            return "coil";
        case BadgeStyle.BRAND_DECLASSE:
            return "declasse";
        case BadgeStyle.BRAND_DEWBAUCHEE:
            return "dewbauchee";
        case BadgeStyle.BRAND_DILETTANTE:
            return "dilettante";
        case BadgeStyle.BRAND_DINKA:
            return "dinka";
        case BadgeStyle.BRAND_DUNDREARY:
            return "dundreary";
        case BadgeStyle.BRAND_EMPORER:
            return "emporer";
        case BadgeStyle.BRAND_ENUS:
            return "enus";
        case BadgeStyle.BRAND_FATHOM:
            return "fathom";
        case BadgeStyle.BRAND_GALIVANTER:
            return "galivanter";
        case BadgeStyle.BRAND_GROTTI:
            return "grotti";
        case BadgeStyle.BRAND_HIJAK:
            return "hijak";
        case BadgeStyle.BRAND_HVY:
            return "hvy";
        case BadgeStyle.BRAND_IMPONTE:
            return "imponte";
        case BadgeStyle.BRAND_INVETERO:
            return "invetero";
        case BadgeStyle.BRAND_JACKSHEEPE:
            return "jacksheepe";
        case BadgeStyle.BRAND_JOBUILT:
            return "jobuilt";
        case BadgeStyle.BRAND_KARIN:
            return "karin";
        case BadgeStyle.BRAND_LAMPADATI:
            return "lampadati";
        case BadgeStyle.BRAND_MAIBATSU:
            return "maibatsu";
        case BadgeStyle.BRAND_MAMMOTH:
            return "mammoth";
        case BadgeStyle.BRAND_MTL:
            return "mtl";
        case BadgeStyle.BRAND_NAGASAKI:
            return "nagasaki";
        case BadgeStyle.BRAND_OBEY:
            return "obey";
        case BadgeStyle.BRAND_OCELOT:
            return "ocelot";
        case BadgeStyle.BRAND_OVERFLOD:
            return "overflod";
        case BadgeStyle.BRAND_PED:
            return "ped";
        case BadgeStyle.BRAND_PEGASSI:
            return "pegassi";
        case BadgeStyle.BRAND_PFISTER:
            return "pfister";
        case BadgeStyle.BRAND_PRINCIPE:
            return "principe";
        case BadgeStyle.BRAND_PROGEN:
            return "progen";
        case BadgeStyle.BRAND_SCHYSTER:
            return "schyster";
        case BadgeStyle.BRAND_SHITZU:
            return "shitzu";
        case BadgeStyle.BRAND_SPEEDOPHILE:
            return "speedophile";
        case BadgeStyle.BRAND_STANLEY:
            return "stanley";
        case BadgeStyle.BRAND_TRUFFADE:
            return "truffade";
        case BadgeStyle.BRAND_UBERMACHT:
            return "ubermacht";
        case BadgeStyle.BRAND_VAPID:
            return "vapid";
        case BadgeStyle.BRAND_VULCAR:
            return "vulcar";
        case BadgeStyle.BRAND_WEENY:
            return "weeny";
        case BadgeStyle.BRAND_WESTERN:
            return "western";
        case BadgeStyle.BRAND_WESTERNMOTORCYCLE:
            return "westernmotorcycle";
        case BadgeStyle.BRAND_WILLARD:
            return "willard";
        case BadgeStyle.BRAND_ZIRCONIUM:
            return "zirconium";
        case BadgeStyle.BRAND_GROTTI2:
            return "grotti_2";
        case BadgeStyle.BRAND_LCC:
            return "lcc";
        case BadgeStyle.BRAND_PROGEN2:
            return "progen";
        case BadgeStyle.BRAND_RUNE:
            return "rune";
        case BadgeStyle.INFO:
            return "info_icon_32";
        default:
            return "";
    }
}

