using System;
using System.Collections.Generic;
using System.Drawing;

namespace ScaleformUI.PauseMenu
{
    public class BaseTab
    {
        public BaseTab(string name)
        {
            Title = name;
        }

        public virtual bool Visible { get; set; }
        public virtual bool Focused { get; set; }
        public string Title { get; set; }
        public bool Active { get; set; }
        public TabView Parent { get; set; }

        public List<TabLeftItem> LeftItemList = new List<TabLeftItem>();

        public event EventHandler Activated;
        public event EventHandler DrawInstructionalButtons;

        public void OnActivated()
        {
            Activated?.Invoke(this, EventArgs.Empty);
        }
    }
}