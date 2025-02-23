using ScaleformUI.Elements;
using System.Drawing;

namespace ScaleformUI.Menu
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
            DetailLeft = leftDetail ?? new()
            {
                Txd = "statWheel"
            };
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
            DetailLeft = leftDetail ?? new()
            {
                Txd = "statWheel"
            };
            ParentMenu?.SetWindows(true);
        }

        public void AddStatsListToWheel(List<UIDetailStat> stats)
        {
            if (StatWheelEnabled)
            {
                DetailStats = stats;
                ParentMenu?.SetWindows(true);
            }
        }

        public void AddStatSingleToWheel(UIDetailStat stat)
        {
            if (StatWheelEnabled)
            {
                DetailStats.Add(stat);
                ParentMenu?.SetWindows(true);
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
                if (DetailStats.Count != stats.Count)
                {
                    throw new Exception("You cannot add items using this function");
                }
                DetailStats = stats;
                ParentMenu?.SetWindows(true);
            }
        }
        public void RemoveStatToWheel(UIDetailStat stat)
        {
            UIDetailStat s = DetailStats.FirstOrDefault(x => x.Percentage == stat.Percentage && x.HudColor == stat.HudColor);
            if (s != null)
            {
                RemoveStatToWheel(DetailStats.IndexOf(s));
            }
        }
        public void RemoveStatToWheel(int id)
        {
            if (id < 0 || id >= DetailStats.Count) return;
            DetailStats.RemoveAt(id);
            ParentMenu?.SetWindows(true);
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
        public SColor HudColor;
        public UIDetailStat(int percentage, SColor color)
        {
            Percentage = percentage;
            HudColor = color;
        }
    }
}
