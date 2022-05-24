using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class PauseMenuBase
    {
        public virtual bool Visible { get; set; }
        /// <summary>
        /// Players won't be able to close the menu if this is false! Make sure players can close the menu in some way!!!!!!
        /// </summary>
        public bool CanPlayerCloseMenu = true;

        public virtual void ProcessControls()
        {

        }
        public virtual void ProcessMouse()
        {

        }
        public virtual void Draw()
        {

        }

    }
}
