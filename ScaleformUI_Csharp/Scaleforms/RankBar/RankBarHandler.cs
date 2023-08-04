using CitizenFX.Core;
using CitizenFX.Core.Native;

namespace ScaleformUI.Scaleforms
{
    public class RankBarHandler
    {
        private const int HUD_COMPONENT_ID = 19;

        private HudColor _rankBarColor = HudColor.HUD_COLOUR_FREEMODE;

        /// <summary>
        /// Set the color of the Rank Bar when displayed
        /// </summary>
        public HudColor Color
        {
            get => _rankBarColor;
            set
            {
                _rankBarColor = value;
            }
        }

        public RankBarHandler() { }

        public async Task Load()
        {
            int timeout = 1000;

            int start = Main.GameTime;
            API.RequestHudScaleform(HUD_COMPONENT_ID);
            while (!API.HasHudScaleformLoaded(HUD_COMPONENT_ID) && Main.GameTime - start < timeout)
            {
                await BaseScript.Delay(0);
            }
        }

        /// <summary>
        /// Shows the rank bar
        /// </summary>
        /// <param name="limitStart">Floor value of experience e.g. 0</param>
        /// <param name="limitEnd">Ceiling value of experience e.g. 800</param>
        /// <param name="previousValue">Previous Experience value </param>
        /// <param name="currentValue">New Experience value</param>
        /// <param name="currentRank">Current rank</param>
        public async void SetScores(int limitStart, int limitEnd, int previousValue, int currentValue, int currentRank)
        {
            await Load();

            // Color has to be set else it will be white by default
            API.BeginScaleformMovieMethodHudComponent(HUD_COMPONENT_ID, "SET_COLOUR");
            API.PushScaleformMovieFunctionParameterInt((int)_rankBarColor);
            API.EndScaleformMovieMethod();

            // this will set an update the score
            API.BeginScaleformMovieMethodHudComponent(HUD_COMPONENT_ID, "SET_RANK_SCORES");
            API.PushScaleformMovieFunctionParameterInt(limitStart);
            API.PushScaleformMovieFunctionParameterInt(limitEnd);
            API.PushScaleformMovieFunctionParameterInt(previousValue);
            API.PushScaleformMovieFunctionParameterInt(currentValue);
            API.PushScaleformMovieFunctionParameterInt(currentRank);
            API.PushScaleformMovieFunctionParameterInt(100);
            API.EndScaleformMovieMethod();
        }

        public void Remove()
        {
            if (API.HasHudScaleformLoaded(HUD_COMPONENT_ID))
            {
                API.BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "REMOVE");
                API.EndScaleformMovieMethod();
            }
        }

        public async void OverrideAnimationSpeed(int speed = 1000)
        {
            await Load();
            API.BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "OVERRIDE_ANIMATION_SPEED");
            API.PushScaleformMovieFunctionParameterInt(speed);
            API.EndScaleformMovieMethod();
        }

        public async void OverrideOnscreenDuration(int duration = 4000)
        {
            await Load();
            API.BeginScaleformScriptHudMovieMethod(HUD_COMPONENT_ID, "OVERRIDE_ONSCREEN_DURATION");
            API.PushScaleformMovieFunctionParameterInt(duration);
            API.EndScaleformMovieMethod();
        }
    }
}
