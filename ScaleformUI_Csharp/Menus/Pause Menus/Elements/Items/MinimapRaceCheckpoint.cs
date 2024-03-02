using CitizenFX.Core;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public class MinimapRaceCheckpoint
    {
        public Vector3 Position;
        public int BlipSprite;

        public MinimapRaceCheckpoint() { }
        public MinimapRaceCheckpoint(Vector3 position, int blipSprite)
        {
            Position = position;
            BlipSprite = blipSprite;
        }
    }
}
