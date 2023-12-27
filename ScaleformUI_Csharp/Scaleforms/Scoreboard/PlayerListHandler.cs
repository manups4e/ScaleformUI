using CitizenFX.Core;
using CitizenFX.Core.Native;

namespace ScaleformUI.Scaleforms
{
    public enum ScoreDisplayType
    {
        NUMBER_ONLY = 0,
        ICON = 1,
        NONE = 2
    };

    public enum ScoreRightIconType
    {
        NONE = 0,
        INACTIVE_HEADSET = 48,
        MUTED_HEADSET = 49,
        ACTIVE_HEADSET = 47,
        RANK_FREEMODE = 65,
        KICK = 64,
        LOBBY_DRIVER = 79,
        LOBBY_CODRIVER = 80,
        SPECTATOR = 66,
        BOUNTY = 115,
        DEAD = 116,
        DPAD_GANG_CEO = 121,
        DPAD_GANG_BIKER = 122,
        DPAD_DOWN_TARGET = 123
    };

    public class PlayerListHandler
    {
        private int _start;
        private int _timer;
        private int currentPage = 0;

        /// <summary> Initializes player rows </summary>
        public PlayerListHandler() => PlayerRows = new List<PlayerRow>();

        public int CurrentPage
        {
            get => currentPage;
            set
            {
                if (PlayerRows.Count == 0)
                {
                    currentPage = 0;
                    return;
                }
                currentPage = value;
                if (currentPage > 0)
                {
                    Enabled = true;
                    NextPage();
                }
            }
        }

        /// <summary>Visible</summary>
        public bool Enabled { get; set; }

        /// <summary> Value set by <see cref="UpdateMaxPages(float)"/> depending on player count</summary>
        public int MaxPages { get; set; } = 1;

        /// <summary> Player rows that displayed in list</summary>
        public List<PlayerRow> PlayerRows { get; set; }

        public int TitleIcon { get; set; }
        public string TitleLeftText { get; set; }
        public string TitleRightText { get; set; }
        internal ScaleformWideScreen _sc { get; set; }
        private int Index { get; set; } = 0;

        /// <summary> Adds a row to <see cref="PlayerRows"/> </summary>
        /// <param name="row"></param>
        public void AddRow(PlayerRow row) => PlayerRows.Add(row);

        /// <summary>Loads the Scaleform using `Load` and builds the menu. Add PlayerRows first then BuildMenu.<para/>
        /// Title is added then all of the <see cref="PlayerRows"/> </summary>
        /// <param name="showTitle">Show title header?</param>
        public async void BuildMenu(bool showTitle = true)
        {
            await Load();
            List<PlayerRow> rows = new();

            if (!showTitle)
            {
                _sc.CallFunction("SET_DATA_SLOT_EMPTY");
                _sc.CallFunction("SET_TITLE", TitleLeftText, TitleRightText, TitleIcon);
            }

            Index = 0;
            foreach (PlayerRow row in PlayerRows)
            {
                if (IsRowSupposedToShow(Index))
                    rows.Add(row);
                Index++;
            }

            Index = 0;
            foreach (PlayerRow row in rows)
            {
                if (string.IsNullOrWhiteSpace(row.CrewLabelText))
                    _sc.CallFunction("SET_DATA_SLOT", Index, row.RightText, row.Name, row.Color, (int)row.RightIcon, row.IconOverlayText, row.JobPointsText, "", (int)row.JobPointsDisplayType, row.TextureString, row.TextureString, row.FriendType);
                else
                    _sc.CallFunction("SET_DATA_SLOT", Index, row.RightText, row.Name, row.Color, (int)row.RightIcon, row.IconOverlayText, row.JobPointsText, $"..+{row.CrewLabelText}", (int)row.JobPointsDisplayType, row.TextureString, row.TextureString, row.FriendType);
                Index++;

            }
            _sc.CallFunction("DISPLAY_VIEW");
        }

        /// <summary> Display mic for row </summary>
        /// <param name="idx">row id</param>
        /// <param name="unk"></param>
        public void DisplayMic(int idx, int unk) => _sc.CallFunction("DISPLAY_MIC", idx, unk);

        /// <summary> Cleans up and frees up all ped headshot texture handles </summary>
        public void Dispose()
        {
            if (_sc is null) return;
            Enabled = false;
            Index = 0;
            MaxPages = 1;
            CurrentPage = 0;
            TitleLeftText = "";
            TitleRightText = "";
            TitleIcon = 0;
            _sc.CallFunction("SET_DATA_SLOT_EMPTY");
            _sc.Dispose();
            _sc = null;
            for (int x = 0; x < 1024; x++) // cleaning up in case of a reload, this frees up all ped headshot handles :)
                API.UnregisterPedheadshot(x);
        }

        /// <summary> Moves the next page and runs BuildMenu. The Menu is disposed when the current page exceeds MaxPages</summary>
        public void NextPage()
        {
            UpdateMaxPages();
            _start = Main.GameTime;
            _timer = 8000;
            BuildMenu();
            if (CurrentPage > MaxPages)
            {
                CurrentPage = 0;
                Enabled = false;
                _start = 0;
                Dispose();
                return;
            }
        }

        /// <summary> Removes a PlayerRow by existing PlayeRow</summary>
        /// <param name="row"></param>
        public void RemoveRow(PlayerRow row)
        {
            PlayerRow r = PlayerRows.FirstOrDefault(x => x.ServerId == row.ServerId);
            if (r != null)
            {
                PlayerRows.Remove(r);
                if (PlayerRows.Any(x => x.RightText.ToLower() == "lobby")) return;
                PlayerRows.Sort((row1, row2) => Convert.ToInt32(row1.RightText).CompareTo(Convert.ToInt32(row2.RightText)));
            }
        }

        /// <summary> Removes a PlayerRow by player server id</summary>
        /// <param name="serverId"></param>
        public void RemoveRow(int serverId)
        {
            PlayerRow r = PlayerRows.FirstOrDefault(x => x.ServerId == serverId);
            if (r != null)
            {
                PlayerRows.Remove(r);
                PlayerRows.Sort((row1, row2) => Convert.ToInt32(row1.RightText).CompareTo(Convert.ToInt32(row2.RightText)));
            }
        }

        /// <summary> Hightlights the row SET_HIGHLIGHT </summary>
        /// <param name="idx">row id</param>
        public void SetHighlight(int idx) =>
            _sc.CallFunction("SET_HIGHLIGHT", idx);

        /// <summary>Sets the icon of the given player row index</summary>
        /// <param name="index"></param>
        /// <param name="icon"></param>
        /// <param name="txt"></param>
        public void SetIcon(int index, ScoreRightIconType icon, string txt)
        {
            PlayerRow row = PlayerRows[index];
            if (row != null)
            {
                _sc.CallFunction("SET_ICON", index, (int)icon, txt);
            }
        }

        /// <summary> Sets the Title for the page header </summary>
        /// <param name="left"></param>
        /// <param name="right"></param>
        /// <param name="icon"></param>
        public void SetTitle(string left, string right, int icon)
        {
            TitleLeftText = left;
            TitleRightText = right;
            TitleIcon = icon;
        }

        /// <summary>Update slot for an existing player row</summary>
        /// <param name="row"></param>
        public void UpdateSlot(PlayerRow row)
        {
            PlayerRow r = PlayerRows.FirstOrDefault(x => Convert.ToInt32(x.RightText) == Convert.ToInt32(row.RightText));
            //var r = PlayerRows.FirstOrDefault(x => x.ServerId == row.ServerId);
            if (r != null)
            {
                PlayerRows[PlayerRows.IndexOf(r)] = row;
                if (row.CrewLabelText != "")
                    _sc.CallFunction("UPDATE_SLOT", PlayerRows.IndexOf(r), row.RightText, row.Name, row.Color, (int)row.RightIcon, row.IconOverlayText, row.JobPointsText, $"..+{row.CrewLabelText}", (int)row.JobPointsDisplayType, row.TextureString, row.TextureString, row.FriendType);
                else
                    _sc.CallFunction("UPDATE_SLOT", PlayerRows.IndexOf(r), row.RightText, row.Name, row.Color, (int)row.RightIcon, row.IconOverlayText, row.JobPointsText, "", (int)row.JobPointsDisplayType, row.TextureString, row.TextureString, row.FriendType);
            }
        }

        internal void Update()
        {
            API.DrawScaleformMovie(_sc.Handle, 0.122f, 0.3f, 0.28f, 0.6f, 255, 255, 255, 255, 0);
            if (_start != 0 && Main.GameTime - _start > _timer)
            {
                CurrentPage = 0;
                Enabled = false;
                _start = 0;
                Dispose();
                return;
            }
        }

        /// <summary>Used to check if the row from the loop is supposed to be displayed based on the current page view.</summary>
        /// <param name="row"></param>
        /// <returns></returns>
        private bool IsRowSupposedToShow(int row)
        {
            if (CurrentPage > 0)
            {
                int max = CurrentPage * 16;
                int min = CurrentPage * 16 - 16;

                if (row >= min && row < max) return true;
            }
            return false;
        }

        /// <summary> Loads the widescreen scaleform `MP_MM_CARD_FREEMODE` </summary>
        /// <returns>wait for scaleform to load with timeout</returns>
        private async Task Load()
        {
            if (_sc is not null) return;
            _sc = new ScaleformWideScreen("MP_MM_CARD_FREEMODE");
            int timeout = 1000;
            int start = Main.GameTime;
            while (!_sc.IsLoaded && Main.GameTime - start < timeout) await BaseScript.Delay(0);
        }

        /// <summary>Updates the max pages to display based on the rows count. <para/>
        /// Rows per page 16</summary>
        private void UpdateMaxPages(float pageCnt = 16f) =>
            MaxPages = (int)Math.Ceiling(PlayerRows.Count / pageCnt);
    }

    /// <summary>
    /// Struct used for the player info row options.
    /// </summary>
    public class PlayerRow
    {
        /// <summary>Color of row</summary>
        public int Color = (int)HudColor.HUD_COLOUR_MID_GREY_MP;

        /// <summary>Crew name</summary>
        public string CrewLabelText = string.Empty;

        /// <summary></summary>
        public char FriendType = '1';

        /// <summary> Job points icon </summary>
        public string IconOverlayText = string.Empty;

        /// <summary> None, Icon, Number</summary>
        public ScoreDisplayType JobPointsDisplayType = ScoreDisplayType.NONE;

        /// <summary> A number of job points </summary>
        public string JobPointsText = string.Empty;

        /// <summary> Player name or name</summary>
        public string Name = string.Empty;

        /// <summary>Right icon, none default</summary>
        public ScoreRightIconType RightIcon = ScoreRightIconType.NONE;

        /// <summary> Right text is required </summary>
        public string RightText = string.Empty;

        /// <summary> Player server id</summary>
        public int ServerId;

        /// <summary> Image texture, usually from the players ped mugshot </summary>
        public string TextureString = string.Empty;
    }

    /// <summary> TODO: </summary>
    public class PlayerRowConfig
    {
        public string crewName;
        public int jobPoints;
        public bool showJobPointsIcon;
    }
}
