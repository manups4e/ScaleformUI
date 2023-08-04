using CitizenFX.Core;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.Scaleforms
{
    public static class MinimapOverlays
    {
        internal static Dictionary<int, KeyValuePair<string, string>> minimaps = new();
        internal static int overlay = 0;

        private static async Task Load()
        {
            overlay = AddMinimapOverlay("MINIMAP_LOADER.gfx");
            while (!HasMinimapOverlayLoaded(overlay)) await BaseScript.Delay(0);
            SetMinimapOverlayDisplay(overlay, 0f, 0f, 100f, 100f, 100f);
        }

        /// <summary>
        /// Adds a custom minimap in any place of the map specified
        /// </summary>
        /// <param name="textureDict">The texture dictionary</param>
        /// <param name="textureName">The texture name</param>
        /// <param name="x">X position</param>
        /// <param name="y">Y Position</param>
        /// <returns>The overlay ID in Dictionary</returns>
        public static async Task<int> AddOverlayToMinimap(string textureDict, string textureName, float x, float y, float width = -1, float height = -1, int alpha = -1, bool centered = false)
        {
            if (overlay == 0) await Load();

            if (!HasStreamedTextureDictLoaded(textureDict))
            {
                RequestStreamedTextureDict(textureDict, false);
                while (!HasStreamedTextureDictLoaded(textureDict)) await BaseScript.Delay(0);
            }

            CallMinimapScaleformFunction(overlay, "ADD_OVERLAY");
            ScaleformMovieMethodAddParamTextureNameString(textureDict);
            ScaleformMovieMethodAddParamTextureNameString(textureName);
            ScaleformMovieMethodAddParamFloat(x);
            ScaleformMovieMethodAddParamFloat(y);
            ScaleformMovieMethodAddParamFloat(width);
            ScaleformMovieMethodAddParamFloat(height);
            ScaleformMovieMethodAddParamInt(alpha);
            ScaleformMovieMethodAddParamBool(centered);
            EndScaleformMovieMethod();

            SetStreamedTextureDictAsNoLongerNeeded(textureDict);

            minimaps.Add(minimaps.Count + 1, new(textureDict, textureName));
            return minimaps.Count;
        }

        /// <summary>
        /// Remove an overlay from the ingame Map
        /// </summary>
        /// <param name="overlayId">Id of the overlay to remove</param>
        public static async void RemoveOverlayFromMinimap(int overlayId)
        {
            if (overlay == 0) await Load();
            CallMinimapScaleformFunction(overlay, "REM_OVERLAY");
            ScaleformMovieMethodAddParamInt(overlayId);
            EndScaleformMovieMethod();
            minimaps.Remove(minimaps.Keys.ToList()[overlayId]);
        }
    }
}
