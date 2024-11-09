using CitizenFX.Core;

namespace ScaleformUI.PauseMenus.Elements.Items
{
    public class MinimapRaceCheckpoint
    {
        public Vector3 Position;
        public int BlipSprite;
        public float Scale = 0;
        public BlipColor Color = BlipColor.White;
        public bool Number;

        public MinimapRaceCheckpoint() { }
        public MinimapRaceCheckpoint(Vector3 position, int blipSprite)
        {
            Position = position;
            BlipSprite = blipSprite;
        }
        public MinimapRaceCheckpoint(BlipSprite sprite, Vector3 position)
        {
            BlipSprite = (int)sprite;
            Position = position;
        }
    }
}
