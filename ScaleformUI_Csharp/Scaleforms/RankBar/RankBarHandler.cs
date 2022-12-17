using CitizenFX.Core;
using CitizenFX.Core.Native;
using System.Threading.Tasks;
using System;

namespace ScaleformUI.Scaleforms.RankBar
{
    public class RankBarHandler
    {
        private const int HUD_COMPONENT_ID = 19;

        private int _limitStart = 0;
        private int _limitEnd = 0;
        private int _previousValue = 0;
        private int _currentValue = 0;
        private int _currentRank = 1;
        private int _nextRank = 2;

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

        public int LimitStart { get => _limitStart; set => _limitStart = value; }
        public int LimitEnd { get => _limitEnd; set => _limitEnd = value; }
        public int PreviousValue { get => _previousValue; set => _previousValue = value; }
        public int CurrentValue { get => _currentValue; set => _currentValue = value; }
        public int CurrentRank { get => _currentRank; set => _currentRank = value; }
        public int NextRank { get => _nextRank; set => _nextRank = value; }

        public RankBarHandler() { }

        public async Task Load()
        {
            var timeout = 1000;
            var start = DateTime.Now;

            API.RequestHudScaleform(HUD_COMPONENT_ID);
            while (!API.HasHudScaleformLoaded(HUD_COMPONENT_ID) && DateTime.Now.Subtract(start).TotalMilliseconds < timeout)
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

            _limitStart = limitStart;
            _limitEnd = limitEnd;
            _previousValue = previousValue;
            _currentValue = currentValue;
            _currentRank = currentRank;

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
