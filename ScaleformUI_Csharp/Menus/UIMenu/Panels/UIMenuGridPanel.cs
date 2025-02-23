using CitizenFX.Core;
using CitizenFX.Core.Native;
using System.Drawing;

namespace ScaleformUI.Menu
{
    public enum GridType
    {
        Full,
        Horizontal
    }

    public class UIMenuGridPanel : UIMenuPanel
    {
        public string TopLabel { get; set; }
        public string LeftLabel { get; set; }
        public string RightLabel { get; set; }
        public string BottomLabel { get; set; }
        public event GridPanelChangedEvent OnGridPanelChange;
        public GridType GridType = GridType.Full;

        private UIMenuGridAudio Audio;
        internal PointF _value;
        public PointF CirclePosition
        {
            get
            {
                return _value;
            }
            set
            {
                _value = value;
                if (ParentItem != null && ParentItem.Parent != null && ParentItem.Parent.Visible)
                {
                    int it = ParentItem.Parent.MenuItems.IndexOf(ParentItem);
                    ParentItem.Parent.SendPanelsToItemScaleform(it, true);
                    OnGridChange();
                    ParentItem.Parent.GridPanelChange(ParentItem, this, _value);
                }
            }
        }

        /// <summary>
        /// Creates <see langword="abstract"/>full grid panels with x,y values
        /// </summary>
        /// <param name="TopText"></param>
        /// <param name="LeftText"></param>
        /// <param name="RightText"></param>
        /// <param name="BottomText"></param>
        /// <param name="circlePosition"></param>
        public UIMenuGridPanel(string TopText, string LeftText, string RightText, string BottomText, PointF circlePosition)
        {
            TopLabel = TopText ?? "Up";
            LeftLabel = LeftText ?? "Left";
            RightLabel = RightText ?? "Right";
            BottomLabel = BottomText ?? "Down";
            GridType = GridType.Full;
            _value = circlePosition;
        }

        /// <summary>
        /// Creates an horizontal Panel with y fixed at 0.5 and variable x
        /// </summary>
        /// <param name="LeftText"></param>
        /// <param name="RightText"></param>
        /// <param name="circlePosition"></param>
        public UIMenuGridPanel(string LeftText, string RightText, PointF circlePosition)
        {
            TopLabel = "";
            BottomLabel = "";
            LeftLabel = LeftText ?? "Left";
            RightLabel = RightText ?? "Right";
            GridType = GridType.Horizontal;
            _value = circlePosition;
        }

        internal void OnGridChange()
        {
            OnGridPanelChange?.Invoke(ParentItem, this, CirclePosition);
        }
    }


    public class UIMenuGridAudio
    {
        public string Slider;
        public string Library;
        public int Id;
        public UIMenuGridAudio(string slider, string library, int id)
        {
            Slider = slider;
            Library = library;
            Id = id;
        }
    }
}
