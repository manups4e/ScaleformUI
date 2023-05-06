using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Scaleforms.Countdown;
using ScaleformUI.Scaleforms.RankBar;

namespace ScaleformUI
{
    public class ScaleformUI : BaseScript
    {
        /// <summary>
        /// Provides the current game time in milliseconds.
        /// </summary>
        public static int GameTime = API.GetGameTimer();

        public static PauseMenuScaleform PauseMenu { get; set; }
        public static MediumMessageHandler MedMessageInstance { get; set; }
        public static InstructionalButtonsScaleform InstructionalButtons { get; set; }
        public static BigMessageHandler BigMessageInstance { get; set; }
        public static PopupWarning Warning { get; set; }
        public static PlayerListHandler PlayerListInstance { get; set; }
        public static MissionSelectorHandler JobMissionSelection { get; set; }
        public static BigFeedHandler BigFeed { get; set; }
        public static RankBarHandler RankBarInstance { get; set; }
        public static CountdownHandler CountdownInstance { get; set; }

        internal static Scaleform _ui { get; set; }
        public ScaleformUI()
        {
            Warning = new();
            MedMessageInstance = new();
            BigMessageInstance = new();
            PlayerListInstance = new();
            JobMissionSelection = new();
            BigFeed = new();
            PauseMenu = new();
            _ui = new("scaleformui");
            InstructionalButtons = new();
            InstructionalButtons.Load();
            RankBarInstance = new();
            CountdownInstance = new();
            Tick += ScaleformUIThread_Tick;
            Tick += OnUpdateGlobalGameTimerAsync;

            EventHandlers["onResourceStop"] += new Action<string>((resName) =>
            {
                if (resName == API.GetCurrentResourceName())
                {
                    if (Game.IsPaused && API.GetCurrentFrontendMenuVersion() == -2060115030)
                    {
                        API.ActivateFrontendMenu((uint)Game.GenerateHash("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), false, -1);
                        API.AnimpostfxStop("PauseMenuIn");
                        API.AnimpostfxPlay("PauseMenuOut", 800, false);
                    }
                    _ui.CallFunction("CLEAR_ALL");
                    _ui.Dispose();
                    PauseMenu.Dispose();
                }
            });
        }

        private async Task ScaleformUIThread_Tick()
        {
            if (InstructionalButtons._sc != null && InstructionalButtons.Enabled && ((InstructionalButtons.ControlButtons != null || InstructionalButtons.ControlButtons.Count != 0) || InstructionalButtons.IsSaving))
                InstructionalButtons.Update();
            if (Game.IsPaused) return;
            if (Warning._sc != null)
                Warning.Update();
            if (MedMessageInstance._sc != null)
                MedMessageInstance.Update();
            if (BigMessageInstance._sc != null)
                BigMessageInstance.Update();
            if (PlayerListInstance._sc != null && PlayerListInstance.Enabled)
                PlayerListInstance.Update();
            if (JobMissionSelection._sc != null && JobMissionSelection.Enabled)
                JobMissionSelection.Update();
            if (BigFeed._sc != null)
                BigFeed.Update();
            _ui ??= new Scaleform("ScaleformUI");
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
            await BaseScript.Delay(100);
            GameTime = API.GetGameTimer();
        }
    }
}
