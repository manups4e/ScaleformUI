using CitizenFX.Core;
using CitizenFX.Core.Native;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public enum JobSelectionCardIcon
    {
        NONE = -1,
        CUSTOM_MISSION,
        DEATHMATCH,
        RACE,
        SURVIVAL,
        TEAM_DEATHMATCH,
        UNUSED1,
        GANG_ATTACK,
        UNUSED2,
        BASE_JUMPING,
        VEHICLE_DEATHMATCH,
        RACE_LAND,
        RACE_FOOT,
        RACE_BICYCLE,
        RACE_WATER,
        RACE_AIR,
        LAST_TEAM_STANDING,
        CAPTURE_THE_FLAG,
        HEIST_PREPARATION,
        HEIST,
        RACE_STUNT,
    }
    public enum JobSelectionCardDetailType
    {
        NORMAL_TEXT = 1,
        WITH_ICON,
        WITH_CREWTAG,
        WITH_BORDER,
        MULTILINE
    }
    public class MissionSelectorHandler
    {
        private Scaleform _sc;
        private bool enabled;
        private bool alreadyVoted;
        public int[] Votes = new int[9];
        public int VotedFor = -1;
        public int MaxVotes = 0;
        public int SelectedCard = 0;
        public JobSelectionData JobData { get; set; }
        public bool Enabled
        {
            get => enabled;
            set
            {
                enabled = value;
                if (enabled)
                    BuildMenu();
                else
                    Dispose();
            }
        }

        public bool AlreadyVoted => alreadyVoted;

        public void Dispose()
        {
            JobData = null;
            _sc.Dispose();
            _sc = null;
        }

        public async void BuildMenu()
        {
            await Load();
            SetTitle(JobData.JobTitle.Title, JobData.JobTitle.Votes);
            foreach (var card in JobData.Cards)
            {
                if (!string.IsNullOrWhiteSpace(card.Txd))
                {
                    while (!API.HasStreamedTextureDictLoaded(card.Txd))
                    {
                        await BaseScript.Delay(0);
                        API.RequestStreamedTextureDict(card.Txd, true);
                    }
                }
                SetGridItem(JobData.Cards.IndexOf(card), card.Title, card.Txd, card.Txn, 1, 0, (int)card.Icon, false, card.RpMultiplier, card.CashMultiplier, false, (int)card.IconColor, card.ApMultiplier);
                API.SetStreamedTextureDictAsNoLongerNeeded(card.Txd);
            }
            foreach (var button in JobData.Buttons)
            {
                SetButtonItem(JobData.Buttons.IndexOf(button) + 6, button.Text);
            }
            SetSelection(0, JobData.Cards[0].Title, JobData.Cards[0].Description);

            foreach (var detail in JobData.Cards[0].Details)
            {
                SetDetailsItem(JobData.Cards.IndexOf(JobData.Cards[0]), 0, 0, (int)detail.Type, 0, 0, detail.LeftText, detail.RightText);
            }
        }

        public void SelectCard(int idx)
        {
            if (idx < 6)
            {

                SetSelection(idx, JobData.Cards[idx].Title, JobData.Cards[idx].Description);

                foreach (var detail in JobData.Cards[idx].Details)
                {
                    SetDetailsItem(JobData.Cards.IndexOf(JobData.Cards[idx]), 0, 0, (int)detail.Type, 0, 0, detail.LeftText, detail.RightText);
                }
            }
            else
            {
                SetSelection(idx, JobData.Buttons[idx - 6].Text, "");
            }
        }

        public void UpdateOwnVote(int idx)
        {
            if (alreadyVoted)
            {
                for (int i = 0; i < 9; i++)
                    _sc.CallFunction("SET_GRID_ITEM_VOTE", i, Votes[VotedFor], 6, false, false);
                _sc.CallFunction("SET_GRID_ITEM_VOTE", VotedFor, Votes[VotedFor]+1, 6, false, false);
            }
            else
            {
                _sc.CallFunction("SET_GRID_ITEM_VOTE", VotedFor, Votes[VotedFor] + 1, 6, false, false);
            }

            int votes = Votes.ToList().Count(x => x != 0);
            JobData.SetVotes(votes, MaxVotes);
            SetTitle(JobData.JobTitle.Title, JobData.JobTitle.Votes);
        }

        public async Task Load()
        {
            if (_sc != null) return;
            _sc = new("MP_NEXT_JOB_SELECTION");
            var timeout = 1000;
            var start = DateTime.Now;
            while (!_sc.IsLoaded && DateTime.Now.Subtract(start).TotalMilliseconds < timeout) await BaseScript.Delay(0);
        }

        public void Update()
        {
            if (!enabled || _sc is null) return;
            _sc.Render2D();
            Game.DisableAllControlsThisFrame(0);
            Game.DisableAllControlsThisFrame(1);
            Game.DisableAllControlsThisFrame(2);
            if(Game.IsDisabledControlJustPressed(2, Control.PhoneUp))
            {
                if ((SelectedCard - 3) >= 0 && (SelectedCard - 3) <= 8)
                {
                    SelectedCard -= 3;
                    SelectCard(SelectedCard);
                }
            }
            if(Game.IsDisabledControlJustPressed(2, Control.PhoneDown))
            {
                if ((SelectedCard + 3) >= 0 && (SelectedCard + 3) <= 8)
                {
                    SelectedCard += 3;
                    SelectCard(SelectedCard);
                }
            }
            if (Game.IsDisabledControlJustPressed(2, Control.PhoneLeft))
            {
                if ((SelectedCard - 1) >= 0 && (SelectedCard - 1) <= 8)
                {
                    SelectedCard -= 1;
                    SelectCard(SelectedCard);
                }

            }
            if (Game.IsDisabledControlJustPressed(2, Control.PhoneRight))
            {
                if ((SelectedCard + 1) >= 0 && (SelectedCard + 1) <= 8)
                {
                    SelectedCard += 1;
                    SelectCard(SelectedCard);
                }
            }
            if (Game.IsDisabledControlJustPressed(2, Control.PhoneSelect))
            {
                if (alreadyVoted)
                    VotedFor = SelectedCard;
                else
                {
                    alreadyVoted = true;
                    VotedFor = SelectedCard;
                }
                UpdateOwnVote(VotedFor);
            }
            /*
        elseif IsControlJustPressed(2, 192) then --TAB
            if player_list_shown then
                player_list_shown = false
            else
                player_list_shown = true
            end
            toggle_player_list()
        elseif IsControlJustPressed(2, 322) then --ESC
            show_next_job_selection = false
            SwitchInPlayer(GetPlayerPed(-1))
           */
        }

        private void SetTitle(string left, string votes)
        {
            _sc.CallFunction("SET_TITLE", left, votes);
        }

        private void SetGridItem(int id, string title, string txd, string txn, int loadtype, int verified_type, int icon, bool check, int rp_multiplier, int cash_multiplier, bool disabled, int iconColor, int ap_multiplier)
        {
            _sc.CallFunction("SET_GRID_ITEM", id, title, txd, txn, loadtype, verified_type, icon, check, rp_multiplier, cash_multiplier, disabled, iconColor, ap_multiplier);
        }

        private void SetButtonItem(int id, string title)
        {
            _sc.CallFunction("SET_GRID_ITEM", id, title, "", "", -1, -1, -1, false, -1, -1, false, 1, -1);
        }

        private void SetSelection(int index, string title, string description, bool hideHighlight = false)
        {
            _sc.CallFunction("SET_SELECTION", index, title, description, hideHighlight);
        }

        private void SetDetailsItem(int id, int menu_id, int unique_id, int type, int initial_index, int is_selectable, string lText, string rText)
        {
            _sc.CallFunction("SET_DETAILS_ITEM", id, menu_id, unique_id, type, initial_index, is_selectable, lText, rText);
        }
    }

    public class JobSelectionData
    {
        public JobSelectionTitle JobTitle = new("", "");
        public List<JobSelectionCard> Cards = new();
        public List<JobSelectionButton> Buttons = new();

        public void SetTitle(string title)
        {
            JobTitle.Title = title;
        }

        public void SetVotes(int actual, int max, string label = "")
        {
            string tot = $"{actual} / {max}";
            if (!string.IsNullOrWhiteSpace(label)) JobTitle.Label = label;
            JobTitle.Votes = tot + " " + JobTitle.Label;
        }

        public void AddCard(JobSelectionCard card)
        {
            if(Cards.Count < 9)
            {
                if(!Cards.Any(x=>x.Title == card.Title))
                {
                    Cards.Add(card);
                }
            }
        }
        public void AddButton(JobSelectionButton button)
        {
            if (Buttons.Count < 3)
            {
                Buttons.Add(button);
            }
        }
    }

    public class JobSelectionTitle
    {
        public string Title { get; set; }
        public string Label { get; set; }
        public string Votes { get; set; }

        public JobSelectionTitle(string title, string label)
        {
            Title = title;
            Label = label;
        }
    }

    public class JobSelectionCard
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Txd { get; set; }
        public string Txn { get; set; }
        public int RpMultiplier { get; set; }
        public int CashMultiplier { get; set; }
        public JobSelectionCardIcon Icon { get; set; }
        public HudColor IconColor { get; set; }
        public int ApMultiplier { get; set; }
        public List<JobSelectionCardDetail> Details { get; set; } // NON PIU DI 4

        public JobSelectionCard(string title, string description, string txd, string txn, int rpMult, int cashMult, JobSelectionCardIcon icon, HudColor iconColor, int apMultiplier, List<JobSelectionCardDetail> details)
        {
            this.Title = title;
            this.Description = description;
            this.Txd = txd;
            this.Txn = txn;
            RpMultiplier = rpMult;
            CashMultiplier = cashMult;
            Icon = icon;
            IconColor = iconColor;
            ApMultiplier = apMultiplier;
            Details = details;
        }
    }

    public class JobSelectionCardDetail
    {
        public JobSelectionCardDetailType Type { get; set; }
        public string LeftText { get; set; }
        public string RightText { get; set; }
        public JobSelectionCardDetail(JobSelectionCardDetailType type, string lText, string rText)
        {
            Type = type;
            LeftText = lText;
            RightText = rText;
        }
    }

    public class JobSelectionButton
    {
        public string Text { get; set; }
        public CallbackDelegate Callback { get; set; }

        public JobSelectionButton(string text, CallbackDelegate action)
        {
            Text = text;
            Callback = action;
        }
    }

}
