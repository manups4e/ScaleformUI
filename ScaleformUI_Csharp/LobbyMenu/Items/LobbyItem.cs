using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScaleformUI.LobbyMenu
{
    public class LobbyItem
    {
        internal int _type;
        
        /// <summary>
        /// Returns the lobby this item is in.
        /// </summary>
        public MainView ParentLobby { get; internal set; }
    }
}
