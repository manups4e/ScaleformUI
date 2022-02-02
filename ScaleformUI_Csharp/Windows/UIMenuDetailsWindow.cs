using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class UIMenuDetailsWindow : UIMenuWindow
    {
        public string DetailTop;
        public string DetailMid;
        public string DetailBottom;
        public UIDetailImage DetailLeft;
        public bool StatWheelEnabled;
        public List<UIDetailStat> DetailStats;
        public UIMenuDetailsWindow(string top, string mid, string bot, UIDetailImage leftDetail = null)
        {
            id = 1;
            DetailTop = top;
            DetailMid = mid;
            DetailBottom = bot;
            StatWheelEnabled = false;
            DetailLeft = leftDetail ?? new();
        }

        public UIMenuDetailsWindow(string top, string mid, string bot, bool statWheelEnabled, List<UIDetailStat> details)
        {
            id = 1;
            DetailTop = top;
            DetailMid = mid;
            DetailBottom = bot;
            StatWheelEnabled = statWheelEnabled;
            DetailStats = details;
            DetailLeft = new()
            {
                Txd = "statWheel"
            };
        }

        public void UpdateLabels(string top, string mid, string bot, UIDetailImage leftDetail = null)
        {
            DetailTop = top;
            DetailMid = mid;
            DetailBottom = bot;
            DetailLeft = leftDetail ?? new();
            if (ParentMenu is not null)
            {
                var wid = ParentMenu.Windows.IndexOf(this);
                if (!StatWheelEnabled)
                    ScaleformUI._ui.CallFunction("UPDATE_DETAILS_WINDOW_VALUES", wid, DetailBottom, DetailMid, DetailTop, DetailLeft.Txd, DetailLeft.Txn, DetailLeft.Pos.X, DetailLeft.Pos.Y, DetailLeft.Size.Width, DetailLeft.Size.Height);
                else
                    ScaleformUI._ui.CallFunction("UPDATE_DETAILS_WINDOW_VALUES", wid, DetailBottom, DetailMid, DetailTop, "statWheel");
            }
        }

        public void AddStatsListToWheel(List<UIDetailStat> stats)
        {
            if (StatWheelEnabled)
            {
                DetailStats = stats;
                if (ParentMenu is not null)
                {
                    var wid = ParentMenu.Windows.IndexOf(this);
                    foreach (var value in stats)
                    {
                        ScaleformUI._ui.CallFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", wid, value.Percentage, (int)value.HudColor);
                    }
                }
            }
        }

        public void AddStatSingleToWheel(UIDetailStat stat)
        {
            if (StatWheelEnabled)
            {
                DetailStats.Add(stat);
                if (ParentMenu is not null)
                {
                    var wid = ParentMenu.Windows.IndexOf(this);
                    ScaleformUI._ui.CallFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", wid, stat.Percentage, (int)stat.HudColor);
                }
            }
        }

        public void UpdateStatsToWheel()
        {
            UpdateStatsToWheel(DetailStats);
        }
        public void UpdateStatsToWheel(List<UIDetailStat> stats)
        {
            if (StatWheelEnabled)
            {
                if(DetailStats.Count != stats.Count)
                {
                    throw new Exception("You cannot add items using this function");
                }
                DetailStats = stats;
                if (ParentMenu is not null)
                {
                    var wid = ParentMenu.Windows.IndexOf(this);
                    foreach (var value in DetailStats)
                    {
                        ScaleformUI._ui.CallFunction("UPDATE_STATS_DETAILS_WINDOW_STATWHEEL", wid, DetailStats.IndexOf(value), value.Percentage, (int)value.HudColor);
                    }
                }
            }
        }
        public void RemoveStatToWheel(UIDetailStat stat)
        {
            var s = DetailStats.FirstOrDefault(x => x.Percentage == stat.Percentage && x.HudColor == stat.HudColor);
            if (s is not null)
            {
                RemoveStatToWheel(DetailStats.IndexOf(s));
            }
        }
        public void RemoveStatToWheel(int id)
        {
            if (id < 0 || id >= DetailStats.Count) return;
            DetailStats.RemoveAt(id);
            if(ParentMenu is not null)
            {
                var wid = ParentMenu.Windows.IndexOf(this);
                ScaleformUI._ui.CallFunction("REMOVE_STATS_DETAILS_WINDOW_STATWHEEL", wid, id);
            }
        }
    }

    public class UIDetailImage
    {
        public string Txd { get; set; }
        public string Txn { get; set; }
        public PointF Pos { get; set; }
        public SizeF Size { get; set; }

        public UIDetailImage()
        {
            Txd = "";
            Txn = "";
            Pos = new(0, 0);
            Size = new(0, 0);
        }
        public UIDetailImage(string txd, string txn, PointF pos, SizeF size)
        {
            Txd = txd;
            Txn = txn;
            Pos = pos;
            Size = size;
        }
    }

    public class UIDetailStat
    {
        public int Percentage;
        public HudColor HudColor;
        public UIDetailStat(int percentage, HudColor color)
        {
            Percentage = percentage;
            HudColor = color;
        }
    }
}
