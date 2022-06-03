using CitizenFX.Core.Native;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI
{
    public class PauseMenuBase
    {
        internal MenuPool _poolcontainer;
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
            API.DisableControlAction(0, 199, true);
            API.DisableControlAction(0, 200, true);
            API.DisableControlAction(1, 199, true);
            API.DisableControlAction(1, 200, true);
            API.DisableControlAction(2, 199, true);
            API.DisableControlAction(2, 200, true);
        }
    }
}
