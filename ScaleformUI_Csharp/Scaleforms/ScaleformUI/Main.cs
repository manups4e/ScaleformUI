using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Scaleforms;

namespace ScaleformUI
{
    public class Main : BaseScript
    {
        /// <summary>
        /// Provides the current game time in milliseconds.
        /// </summary>
        public static int GameTime = API.GetNetworkTime();

        public static PauseMenuScaleform PauseMenu { get; internal set; }
        public static MediumMessageHandler MedMessageInstance { get; internal set; }
        public static InstructionalButtonsScaleform InstructionalButtons { get; internal set; }
        public static BigMessageHandler BigMessageInstance { get; internal set; }
        public static PopupWarning Warning { get; internal set; }
        public static PlayerListHandler PlayerListInstance { get; internal set; }
        public static MissionSelectorHandler JobMissionSelection { get; internal set; }
        public static BigFeedHandler BigFeed { get; internal set; }
        public static RankBarHandler RankBarInstance { get; internal set; }
        public static CountdownHandler CountdownInstance { get; internal set; }
        public static MultiplayerChatHandler MultiplayerChat { get; internal set; }


        internal static ScaleformWideScreen scaleformUI { get; set; }
        internal static ScaleformWideScreen radialMenu { get; set; }
        internal static ScaleformWideScreen radioMenu { get; set; }
        public Main()
        {
            Warning = new();
            MedMessageInstance = new();
            BigMessageInstance = new();
            PlayerListInstance = new();
            JobMissionSelection = new();
            BigFeed = new();
            PauseMenu = new();
            InstructionalButtons = new();
            InstructionalButtons.Load();
            RankBarInstance = new();
            CountdownInstance = new();
            MultiplayerChat = new();
            scaleformUI = new("scaleformui");
            radialMenu = new("radialmenu");
            radioMenu = new("radiomenu");
            Tick += ScaleformUIThread_Tick;
            Tick += OnUpdateGlobalGameTimerAsync;
            MinimapOverlays.Load();
            EventHandlers["onResourceStop"] += new Action<string>((resName) =>
            {
                if (resName == API.GetCurrentResourceName())
                {
                    if (MenuHandler.IsAnyMenuOpen || MenuHandler.IsAnyPauseMenuOpen)
                        MenuHandler.CloseAndClearHistory();
                    radialMenu?.CallFunction("CLEAR_ALL");
                    radialMenu?.Dispose();
                    radioMenu?.CallFunction("CLEAR_ALL");
                    radioMenu?.Dispose();
                    scaleformUI?.CallFunction("CLEAR_ALL");
                    scaleformUI?.Dispose();
                    PauseMenu?.Dispose();
                    API.N_0x2de6c5e2e996f178(1);
                    API.RaceGalleryFullscreen(false);
                    API.ClearRaceGalleryBlips();
                    API.SetRadarZoom(0);
                    API.SetGpsCustomRouteRender(false, 18, 30);
                    API.SetGpsMultiRouteRender(false);
                    API.UnlockMinimapPosition();
                    API.UnlockMinimapAngle();
                    API.DeleteWaypoint();
                    API.ClearGpsCustomRoute();
                    API.ClearGpsFlags();
                }
            });
        }

        private async Task ScaleformUIThread_Tick()
        {
            if (MenuHandler.ableToDraw && !(API.IsWarningMessageActive() || Warning.IsShowing))
            {
                MenuHandler.ProcessMenus();
                if (API.GetCurrentFrontendMenuVersion() == API.GetHashKey("FE_MENU_VERSION_CORONA"))
                {
                    API.BeginScaleformMovieMethodOnFrontend("INSTRUCTIONAL_BUTTONS");
                    API.ScaleformMovieMethodAddParamPlayerNameString("SET_DATA_SLOT_EMPTY");
                    API.EndScaleformMovieMethod();
                    API.BeginScaleformMovieMethodOnFrontendHeader("SHOW_MENU");
                    API.ScaleformMovieMethodAddParamBool(false);
                    API.EndScaleformMovieMethod();
                    API.BeginScaleformMovieMethodOnFrontendHeader("SHOW_HEADING_DETAILS");
                    API.ScaleformMovieMethodAddParamBool(false);
                    API.EndScaleformMovieMethod();
                }
            }

            if (Warning._sc != null)
                Warning.Update();
            if (InstructionalButtons._sc != null && (InstructionalButtons.ControlButtons != null && InstructionalButtons.ControlButtons.Count != 0))
                InstructionalButtons.Update();
            if (Game.IsPaused) return;
            if (MedMessageInstance._sc != null)
                MedMessageInstance.Update();
            if (BigMessageInstance._sc != null)
                BigMessageInstance.Update();
            if (PlayerListInstance._sc != null && PlayerListInstance.Enabled)
                PlayerListInstance.Update();
            if (JobMissionSelection._sc != null && JobMissionSelection.Enabled)
                JobMissionSelection.Update();
            if (MultiplayerChat.IsTyping())
                MultiplayerChat.Update();
            if (BigFeed._sc != null)
                BigFeed.Update();
            scaleformUI ??= new("ScaleformUI");
            radialMenu ??= new("RadialMenu");
            if (!PauseMenu.Loaded)
                PauseMenu.Load();
            await Task.FromResult(0);
        }

        /// <summary>
        /// Updates the game time.
        /// </summary>
        /// <returns></returns>
        public async Task OnUpdateGlobalGameTimerAsync()
        {
            GameTime = API.GetNetworkTimeAccurate();
        }
    }
}
