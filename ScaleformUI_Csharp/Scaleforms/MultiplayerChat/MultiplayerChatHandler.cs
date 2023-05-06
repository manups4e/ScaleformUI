using CitizenFX.Core;

namespace ScaleformUI.Scaleforms.MultiplayerChat
{
    public class MultiplayerChatHandler
    {
        private const string SCALEFORM_NAME = "MULTIPLAYER_CHAT";
        private Scaleform _sc;

        private bool _isTyping;
        private int _start = 0;
        private int _duration = 5000;

        public MultiplayerChatHandler() { Load(); }

        private async void Load()
        {
            if (_sc is not null) return;
            _sc = new Scaleform(SCALEFORM_NAME);
            int timeout = 1000;
            int start = ScaleformUI.GameTime;
            while (!_sc.IsLoaded && ScaleformUI.GameTime - start < timeout) await BaseScript.Delay(0);
            if (!_sc.IsLoaded) return;
            _sc.CallFunction("RESET");
            _sc.CallFunction("SET_FOCUS", ChatVisibility.Hidden, ChatScope.All, "All", Game.Player.Name, HudColor.HUD_COLOUR_WHITE);
        }

        private void Dispose()
        {
            _sc.Dispose();
            _sc = null;
        }

        public void SetFocus(ChatVisibility visibility, ChatScope? scope = null, string? scopeText = null, string? playerName = null, HudColor? color = null)
        {
            if (visibility == ChatVisibility.Typing)
                _isTyping = true;
            else if (visibility == ChatVisibility.Hidden)
                _isTyping = false;
            else if (visibility == ChatVisibility.Default)
                _start = ScaleformUI.GameTime;

            _sc.CallFunction("SET_FOCUS", visibility, scope, scopeText, playerName, color);
        }

        public void AddMessage(string playerName, string message, ChatScope scope, bool teamOnly, HudColor color)
        {
            _sc.CallFunction("ADD_MESSAGE", playerName, message, scope, teamOnly, color);
        }

        public void Close()
        {
            SetFocus(ChatVisibility.Hidden);
            _start = 0;
            _isTyping = false;
        }

        public void Show() => SetFocus(ChatVisibility.Default);
        public void StartTyping() => SetFocus(ChatVisibility.Typing);
        public void Hide() => SetFocus(ChatVisibility.Hidden);
        public void Reset() => _sc.CallFunction("RESET");
        public void PageUp() => _sc.CallFunction("PAGE_UP");
        public void PageDown() => _sc.CallFunction("PAGE_DOWN");
        public void DeleteText() => _sc.CallFunction("DELETE_TEXT");
        public void AddText(string text) => _sc.CallFunction("ADD_TEXT", text);
        public void CompleteText() => _sc.CallFunction("COMPLETE_TEXT");
        public void AbortText() => _sc.CallFunction("ABORT_TEXT");
        public bool IsTyping() => _isTyping;
        public void SetDuration(int duration) => _duration = duration;

        public void Update()
        {
            if (_sc is null || !_sc.IsLoaded) return;
            _sc.Render2D();

            if (!_isTyping && ScaleformUI.GameTime - _start > _duration)
                Close();
        }
    }

    public enum ChatScope
    {
        Global = 0,
        Team = 1,
        All = 2,
        Clan = 3,
    }

    public enum ChatVisibility
    {
        Hidden = 0,
        Default = 1,
        Typing = 2,
    }
}
