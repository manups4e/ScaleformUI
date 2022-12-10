using CitizenFX.Core;
using CitizenFX.Core.Native;

namespace ScaleformUI.Scaleforms.RankBar
{
    public class RankBarHandler
    {
        private const int HUD_COMPONENT_ID = 19;
        public Scaleform _sc;

        private int _limitStart = 0;
        private int _limitEnd = 0;
        private int _previousValue = 0;
        private int _currentValue = 0;
        private int _currentRank = 1;

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

        public RankBarHandler() { }

        public async void SetScores(int limitStart, int limitEnd, int previousValue, int currentValue, int currentRank)
        {
            API.RequestHudScaleform(HUD_COMPONENT_ID);
            while (!API.HasHudScaleformLoaded(HUD_COMPONENT_ID))
            {
                await BaseScript.Delay(0);
            }

            // Color has to be set else it will be white by default
            API.BeginScaleformMovieMethodHudComponent(HUD_COMPONENT_ID, "SET_COLOUR");
            API.PushScaleformMovieFunctionParameterInt((int)_rankBarColor);
            API.EndScaleformMovieMethodReturn();

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
            API.EndScaleformMovieMethodReturn();
        }

        public void Show()
        {
            SetScores(_limitStart, _limitEnd, _previousValue, _currentValue, _currentRank);
        }
    }
}
