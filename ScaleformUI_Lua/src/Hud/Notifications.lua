Notifications = setmetatable({}, Notifications)
Notifications.__index = Notifications
Notifications.__call = function()
    return "Notifications", "Notifications"
end

function Notifications.New()
    local _notif = {
        _handle = 0,
        Type = {
            Default = 0,
            Bubble = 1,
            Mail = 2,
            FriendRequest = 3,
            Default2 = 4,
            Reply = 7,
            ReputationPoints = 8,
            Money = 9
        },
        Color = {
            Red = 27,
            Yellow = 50,
            Gold = 12,
            GreenLight = 46,
            GreenDark = 47,
            Cyan = 48,
            Blue = 51,
            Purple = 49,
            Rose = 45
        },
        NotificationIcon = {
            ChatBox = 1,
            Email = 2,
            AdDFriendRequest = 3,
            RightJumpingArrow = 7,
            RPIcon = 8,
            DollarIcon = 9
        },
        IconChars = {
            Abigail = "CHAR_ABIGAIL",
            Amanda = "CHAR_AMANDA",
            Ammunation = "CHAR_AMMUNATION",
            Andreas = "CHAR_ANDREAS",
            Antonia = "CHAR_ANTONIA",
            Ashley = "CHAR_ASHLEY",
            BankOfLiberty = "CHAR_BANK_BOL",
            BankFleeca = "CHAR_BANK_FLEECA",
            BankMaze = "CHAR_BANK_MAZE",
            Barry = "CHAR_BARRY",
            Beverly = "CHAR_BEVERLY",
            BikeSite = "CHAR_BIKESITE",
            BlankEntry = "CHAR_BLANK_ENTRY",
            Blimp = "CHAR_BLIMP",
            Blocked = "CHAR_BLOCKED",
            BoatSite = "CHAR_BOATSITE",
            BrokenDownGirl = "CHAR_BROKEN_DOWN_GIRL",
            BugStars = "CHAR_BUGSTARS",
            Call911 = "CHAR_CALL911",
            LegendaryMotorsport = "CHAR_CARSITE",
            SSASuperAutos = "CHAR_CARSITE2",
            Castro = "CHAR_CASTRO",
            ChatCall = "CHAR_CHAT_CALL",
            Chef = "CHAR_CHEF",
            Cheng = "CHAR_CHENG",
            ChengSenior = "CHAR_CHENGSR",
            Chop = "CHAR_CHOP",
            Cris = "CHAR_CRIS",
            Dave = "CHAR_DAVE",
            Default = "CHAR_DEFAULT",
            Denise = "CHAR_DENISE",
            DetonateBomb = "CHAR_DETONATEBOMB",
            DetonatePhone = "CHAR_DETONATEPHONE",
            Devin = "CHAR_DEVIN",
            SubMarine = "CHAR_DIAL_A_SUB",
            Dom = "CHAR_DOM",
            DomesticGirl = "CHAR_DOMESTIC_GIRL",
            Dreyfuss = "CHAR_DREYFUSS",
            DrFriedlander = "CHAR_DR_FRIEDLANDER",
            Epsilon = "CHAR_EPSILON",
            EstateAgent = "CHAR_ESTATE_AGENT",
            Facebook = "CHAR_FACEBOOK",
            FilmNoire = "CHAR_FILMNOIR",
            Floyd = "CHAR_FLOYD",
            Franklin = "CHAR_FRANKLIN",
            FranklinTrevor = "CHAR_FRANK_TREV_CONF",
            GayMilitary = "CHAR_GAYMILITARY",
            Hao = "CHAR_HAO",
            HitcherGirl = "CHAR_HITCHER_GIRL",
            Hunter = "CHAR_HUNTER",
            Jimmy = "CHAR_JIMMY",
            JimmyBoston = "CHAR_JIMMY_BOSTON",
            Joe = "CHAR_JOE",
            Josef = "CHAR_JOSEF",
            Josh = "CHAR_JOSH",
            LamarDog = "CHAR_LAMAR",
            Lester = "CHAR_LESTER",
            Skull = "CHAR_LESTER_DEATHWISH",
            LesterFranklin = "CHAR_LEST_FRANK_CONF",
            LesterMichael = "CHAR_LEST_MIKE_CONF",
            LifeInvader = "CHAR_LIFEINVADER",
            LsCustoms = "CHAR_LS_CUSTOMS",
            LSTI = "CHAR_LS_TOURIST_BOARD",
            Manuel = "CHAR_MANUEL",
            Marnie = "CHAR_MARNIE",
            Martin = "CHAR_MARTIN",
            MaryAnn = "CHAR_MARY_ANN",
            Maude = "CHAR_MAUDE",
            Mechanic = "CHAR_MECHANIC",
            Michael = "CHAR_MICHAEL",
            MichaelFranklin = "CHAR_MIKE_FRANK_CONF",
            MichaelTrevor = "CHAR_MIKE_TREV_CONF",
            WarStock = "CHAR_MILSITE",
            Minotaur = "CHAR_MINOTAUR",
            Molly = "CHAR_MOLLY",
            MorsMutual = "CHAR_MP_MORS_MUTUAL",
            ArmyContact = "CHAR_MP_ARMY_CONTACT",
            Brucie = "CHAR_MP_BRUCIE",
            FibContact = "CHAR_MP_FIB_CONTACT",
            RockStarLogo = "CHAR_MP_FM_CONTACT",
            Gerald = "CHAR_MP_GERALD",
            Julio = "CHAR_MP_JULIO",
            MechanicChinese = "CHAR_MP_MECHANIC",
            MerryWeather = "CHAR_MP_MERRYWEATHER",
            Unicorn = "CHAR_MP_STRIPCLUB_PR",
            Mom = "CHAR_MRS_THORNHILL",
            MrsThornhill = "CHAR_MRS_THORNHILL",
            PatriciaTrevor = "CHAR_PATRICIA",
            PegasusDelivery = "CHAR_PEGASUS_DELIVERY",
            ElitasTravel = "CHAR_PLANESITE",
            Sasquatch = "CHAR_SASQUATCH",
            Simeon = "CHAR_SIMEON",
            SocialClub = "CHAR_SOCIAL_CLUB",
            Solomon = "CHAR_SOLOMON",
            Taxi = "CHAR_TAXI",
            Trevor = "CHAR_TREVOR",
            YouTube = "CHAR_YOUTUBE",
            Wade = "CHAR_WADE",
        }
    }
    return setmetatable(_notif, Notifications)
end

function Notifications:Hide()
    ThefeedRemoveItem(self._handle)
end

function Notifications:ShowNotification(msg, blink, showBrief)
    AddTextEntry("ScaleformUINotification", msg)
    BeginTextCommandThefeedPost("ScaleformUINotification")
    EndTextCommandThefeedPostTicker(blink, showBrief)
end

function Notifications:ShowNotificationWithColor(msg, color, blink, showBrief)
    AddTextEntry("ScaleformUINotification", msg)
    BeginTextCommandThefeedPost("ScaleformUINotification")
    ThefeedSetNextPostBackgroundColor(color)
    EndTextCommandThefeedPostTicker(blink, showBrief)
end

function Notifications:ShowHelpNotification(helpText, time)
    AddTextEntry("ScaleformUIHelpText", helpText)
    if (time ~= nil) then
        if (time > 5000) then time = 5000 end
        BeginTextCommandDisplayHelp("ScaleformUIHelpText")
        EndTextCommandDisplayHelp(0, false, true, time)
    else
        DisplayHelpTextThisFrame("ScaleformUIHelpText", false)
    end
end

function Notifications:ShowFloatingHelpNotification(msg, coords, time)
    if (time == nil) then time = -1 end
    AddTextEntry("ScaleformUIFloatingHelpText", msg)
    SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp("ScaleformUIFloatingHelpText")
    EndTextCommandDisplayHelp(2, false, false, time)
end

function Notifications:ShowAdvancedNotification(title, subtitle, text, iconSet, icon, bgColor, flashColor, blink, type,
                                                sound)
    if (type == nil) then type = self.Type.Default end
    if (iconSet == nil) then iconSet = self.IconChars.Default end
    if (icon == nil) then icon = self.NotificationIcon.Default end
    if (bgColor == nil) then bgColor = -1 end
    if (blink == nil) then blink = false end
    AddTextEntry("ScaleformUIAdvancedNotification", text)
    BeginTextCommandThefeedPost("ScaleformUIAdvancedNotification")
    AddTextComponentSubstringPlayerName(text)
    if (bgColor and bgColor ~= -1) then
        ThefeedSetNextPostBackgroundColor(bgColor)
    end
    if (flashColor and not blink) then
        ThefeedSetAnimpostfxColor(flashColor.R, flashColor.G, flashColor.B, flashColor.A)
    end
    if (sound) then PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", true); end
    return EndTextCommandThefeedPostMessagetext(iconSet, icon, true, type, title, subtitle)
end

function Notifications:ShowStatNotification(newProgress, oldProgress, title, blink, showBrief)
    if (blink == nil) then blink = false end
    if (showBrief == nil) then showBrief = false end
    AddTextEntry("ScaleformUIStatsNotification", title)
    local handle = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
    local txd = GetPedheadshotTxdString(handle)
    BeginTextCommandThefeedPost("PS_UPDATE")
    AddTextComponentInteger(newProgress)
    EndTextCommandThefeedPostStats("ScaleformUIStatsNotification", 2, newProgress, oldProgress, false, txd, txd)
    EndTextCommandThefeedPostTicker(blink, showBrief)
    UnregisterPedheadshot(handle)
end

function Notifications:ShowVSNotification(ped1, ped2, color1, color2)
    local handle_1 = RegisterPedheadshot(ped1)
    while not IsPedheadshotReady(handle_1) or not IsPedheadshotValid(handle_1) do Citizen.Wait(0) end
    local txd_1 = GetPedheadshotTxdString(handle_1)

    local handle_2 = RegisterPedheadshot(ped2)
    while not IsPedheadshotReady(handle_2) or not IsPedheadshotValid(handle_2) do Citizen.Wait(0) end
    local txd_2 = GetPedheadshotTxdString(handle_2)

    BeginTextCommandThefeedPost("")
    ---@diagnostic disable-next-line: redundant-parameter -- This is a bug in the linter
    EndTextCommandThefeedPostVersusTu(txd_1, txd_1, 12, txd_2, txd_2, 1, color1, color2)

    UnregisterPedheadshot(handle_1)
    UnregisterPedheadshot(handle_2)
end

function Notifications:DrawText3D(coords, color, text, font, size)
    local cam = GetGameplayCamCoord()
    local dist = #(coords - cam)
    local scaleInternal = (1 / dist) * size
    local fov = (1 / GetGameplayCamFov()) * 100
    local _scale = scaleInternal * fov
    SetTextScale(0.1 * _scale, 0.15 * _scale)
    SetTextFont(font)
    SetTextProportional(true)
    SetTextColour(color.R, color.G, color.B, color.A)
    SetTextDropshadow(5, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0, 0)
    ClearDrawOrigin()
end

function Notifications:DrawText(x, y, text, color, font, textAlignment, shadow, outline, wrap)
    if (color == nil) then color = { r = 255, g = 255, b = 255, a = 255 } end
    if (font == nil) then font = 4 end
    if (textAlignment == nil) then textAlignment = 1 end
    if (shadow == nil) then shadow = false end
    if (outline == nil) then outline = false end
    if (wrap == nil) then wrap = 0 end

    local screenw, screenh = GetActiveScreenResolution()
    local height = 1080
    local ratio = screenw / screenh
    local width = height * ratio

    SetTextFont(font)
    SetTextScale(0.0, 0.5)
    SetTextColour(color.r, color.g, color.b, color.a)
    if (shadow) then SetTextDropShadow() end
    if (outline) then SetTextOutline() end
    if (wrap ~= 0) then
        local xsize = (x + wrap) / width
        SetTextWrap(x, xsize)
    end
    if (textAlignment == 0) then
        SetTextCentre(true)
    elseif (textAlignment == 2) then
        SetTextRightJustify(true)
        SetTextWrap(0, x)
    end
    BeginTextCommandDisplayText("jamyfafi")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

function Notifications:ShowSubtitle(msg, time)
    if (time == nil) then time = 2500 end
    AddTextEntry("ScaleformUISubtitle", msg)
    BeginTextCommandPrint("ScaleformUISubtitle")
    EndTextCommandPrint(time, true)
end
