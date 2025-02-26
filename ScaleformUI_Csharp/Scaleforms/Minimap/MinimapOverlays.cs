using CitizenFX.Core;
using CitizenFX.Core.Native;
using ScaleformUI.Elements;
using System.Drawing;
using System.Runtime.Remoting.Contexts;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.Scaleforms
{
    public enum MouseEvent
    {
        MOUSE_DRAG_OUT = 0,
        MOUSE_DRAG_OVER = 1,
        MOUSE_DOWN = 2,
        MOUSE_MOVE = 3,
        MOUSE_UP = 4,
        MOUSE_PRESS = 5,
        MOUSE_RELEASE = 6,
        MOUSE_RELEASE_OUTSIDE = 7,
        MOUSE_ROLL_OUT = 8,
        MOUSE_ROLL_OVER = 9,
    }

    public delegate void MinimapOverlayMouseEvent(MouseEvent mouseEvent);

    public class MinimapOverlay
    {
        internal int handle;
        internal string txd;
        internal string txn;
        internal SColor color;
        internal Vector2 position;
        internal float rotation;
        internal SizeF size;
        internal float alpha;
        internal bool centered;
        public event MinimapOverlayMouseEvent OnMouseEvent;

        public bool Visible
        {
            get => visible;
            set
            {
                visible = value;
                MinimapOverlays.HideOverlay(Handle, !visible);
            }
        }

        public int Handle { get => handle; set => handle = value; }
        public string Txd { get => txd; set => txd = value; }
        public string Txn { get => txn; set => txn = value; }
        public SColor Color
        {
            get => color;
            set
            {
                color = value;
                MinimapOverlays.SetOverlayColor(Handle, color);
            }
        }
        public Vector2 Position
        {
            get => position;
            set
            {
                position = value;
                MinimapOverlays.SetOverlayPosition(Handle, position);
            }
        }
        public float Rotation
        {
            get => rotation;
            set
            {
                rotation = value;
                MinimapOverlays.SetOverlayRotation(Handle, rotation);
            }
        }
        public SizeF Size
        {
            get => size;
            set
            {
                size = value;
                MinimapOverlays.SetOverlaySizeOrScale(Handle, size);
            }
        }

        internal bool visible;

        public float Alpha
        {
            get => alpha;
            set
            {
                alpha = value;
                MinimapOverlays.SetOverlayAlpha(Handle, alpha);
            }
        }

        public bool Centered { get => centered; set => centered = value; }
        internal void triggerMouseEvent(MouseEvent ev)
        {
            OnMouseEvent?.Invoke(ev);
        }

        public MinimapOverlay() { }
        public MinimapOverlay(int handle, string txd, string txn, Vector2 pos, float r, SizeF size, int a, bool centered)
        {
            this.handle = handle;
            this.txd = txd;
            this.txn = txn;
            this.color = Color;
            this.position = pos;
            this.size = size;
            this.rotation = r;
            this.centered = centered;
        }
    }

    public static class MinimapOverlays
    {
        internal static List<MinimapOverlay> minimaps = new();
        internal static int overlay = 0;
        internal static int minimapHandle = 0;
        internal static int eventType = 0;
        internal static int itemId = 0;
        internal static int context = 0;
        internal static int unused = 0;
        internal static bool success;

        internal static async Task Load()
        {
            overlay = AddMinimapOverlay("files/MINIMAP_LOADER.gfx");
            while (!HasMinimapOverlayLoaded(overlay)) await BaseScript.Delay(0);
            SetMinimapOverlayDisplay(overlay, 0f, 0f, 100f, 100f, 100f);
            int i = 0;
            do
            {
                Main.TriggerEvent("ScUI:getMinimapHandle", [ new Action<dynamic>(handle => {
                    minimapHandle = Convert.ToInt32(handle);
                    return;
                })]);
                i++;
                if (i >= 2 && minimapHandle == 0)
                    break;
                await BaseScript.Delay(1000);
            } while (minimapHandle == 0);
            if(minimapHandle == 0)
            {
                var mn = RequestScaleformMovieInstance("minimap");
                while (!HasScaleformMovieLoaded(mn))
                    await BaseScript.Delay(0);
                minimapHandle = mn;
                SetBigmapActive(true, false);
                await BaseScript.Delay(0);
                SetBigmapActive(false, false);
            }
        }

        internal static void Update()
        {
            success = API.GetScaleformMovieCursorSelection(minimapHandle, ref eventType, ref context, ref itemId, ref unused);
            if (success)
            {
                if (context == 1000)
                {
                    MouseEvent ev = (MouseEvent)eventType;
                    if (minimaps.Count > itemId)
                        minimaps[itemId].triggerMouseEvent(ev);
                }
            }
        }

        private static async Task<MinimapOverlay> addOverlay(string method, string txd, string txn, float x, float y, float r, float w, float h, int a, bool centered)
        {
            if (overlay == 0) await Load();

            if (!HasStreamedTextureDictLoaded(txd))
            {
                RequestStreamedTextureDict(txd, false);
                while (!HasStreamedTextureDictLoaded(txd)) await BaseScript.Delay(0);
            }

            CallMinimapScaleformFunction(overlay, method);
            ScaleformMovieMethodAddParamTextureNameString(txd);
            ScaleformMovieMethodAddParamTextureNameString(txn);
            ScaleformMovieMethodAddParamFloat(x);
            ScaleformMovieMethodAddParamFloat(y);
            ScaleformMovieMethodAddParamFloat(r);
            ScaleformMovieMethodAddParamFloat(w);
            ScaleformMovieMethodAddParamFloat(h);
            ScaleformMovieMethodAddParamInt(a);
            ScaleformMovieMethodAddParamBool(centered);
            EndScaleformMovieMethod();

            SetStreamedTextureDictAsNoLongerNeeded(txd);

            MinimapOverlay minOv = new MinimapOverlay(minimaps.Count + 1, txd, txn, new Vector2(x, y), r, new SizeF(w, h), a, centered);
            minimaps.Add(minOv);
            return minOv;

        }

        /// <summary>
        /// Adds a custom minimap in any place of the map specified
        /// </summary>
        /// <param name="textureDict">The texture dictionary</param>
        /// <param name="textureName">The texture name</param>
        /// <param name="x">X world coordinate</param>
        /// <param name="y">Y world coordinate</param>
        /// <param name="rotation">Rotation of the texture in degrees (default 0)</param>
        /// <param name="width">The width of the texture in pixels (default -1 to leave on original size, else this will override original width)</param>
        /// <param name="height">The height of the texture in pixels (default -1 to leave on original size, else this will override original height)</param>
        /// <param name="alpha">The alpha transparency value of the texture (default 100)</param>
        /// <param name="centered"><see langword="true"/> to center the texture to the given coordinates, <see langword="false"/> to center it on its top-left corner</param>
        /// <returns>The overlay ID in Dictionary</returns>
        public static async Task<MinimapOverlay> AddSizedOverlayToMap(string textureDict, string textureName, float x, float y, float rotation = 0, float width = -1, float height = -1, int alpha = 100, bool centered = false)
        {
            return await addOverlay("ADD_SIZED_OVERLAY", textureDict, textureName, x, y, rotation, width, height, alpha, centered);
        }

        /// <summary>
        /// Adds a custom minimap in any place of the map specified
        /// </summary>
        /// <param name="textureDict">The texture dictionary</param>
        /// <param name="textureName">The texture name</param>
        /// <param name="x">X world coordinate</param>
        /// <param name="y">Y world coordinate</param>
        /// <param name="rotation">Rotation of the texture in degrees (default 0)</param>
        /// <param name="xScale">The horizontal scale (percentage) of the texture (default 100)</param>
        /// <param name="yScale">The vertical scale (percentage) of the texture (default 100)</param>
        /// <param name="alpha">The alpha transparency value of the texture (default 100)</param>
        /// <param name="centered"><see langword="true"/> to center the texture to the given coordinates, <see langword="false"/> to center it on its top-left corner</param>
        /// <returns>The overlay ID in Dictionary</returns>
        public static async Task<MinimapOverlay> AddScaledOverlayToMap(string textureDict, string textureName, float x, float y, float rotation = 0, float xScale = 100f, float yScale = 100f, int alpha = 100, bool centered = false)
        {
            return await addOverlay("ADD_SCALED_OVERLAY", textureDict, textureName, x, y, rotation, xScale, yScale, alpha, centered);
        }

        /// <summary>
        /// Sets the selected overlay's color (argb)
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="color"></param>
        public static void SetOverlayColor(int overlayId, SColor color)
        {
            if (overlay == 0) return;
            CallMinimapScaleformFunction(overlay, "SET_OVERLAY_COLOR");
            ScaleformMovieMethodAddParamInt(overlayId - 1);
            ScaleformMovieMethodAddParamInt(color.A);
            ScaleformMovieMethodAddParamInt(color.R);
            ScaleformMovieMethodAddParamInt(color.G);
            ScaleformMovieMethodAddParamInt(color.B);
            EndScaleformMovieMethod();
            minimaps[overlayId - 1].color = color;
        }

        /// <summary>
        /// Hides the selected overlay or shows it
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="hide"></param>
        public static void HideOverlay(int overlayId, bool hide)
        {
            if (overlay == 0) return;
            CallMinimapScaleformFunction(overlay, "HIDE_OVERLAY");
            ScaleformMovieMethodAddParamInt(overlayId - 1);
            ScaleformMovieMethodAddParamBool(hide);
            EndScaleformMovieMethod();
            minimaps[overlayId - 1].visible = !hide;
        }

        /// <summary>
        /// Changes overlay's Alpha
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="hide"></param>
        public static void SetOverlayAlpha(int overlayId, float alpha)
        {
            if (overlay == 0) return;
            CallMinimapScaleformFunction(overlay, "SET_OVERLAY_ALPHA");
            ScaleformMovieMethodAddParamInt(overlayId - 1);
            ScaleformMovieMethodAddParamFloat(alpha);
            EndScaleformMovieMethod();
            minimaps[overlayId - 1].alpha = alpha;
        }

        /// <summary>
        /// Changes the overlay coordinates
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="pos"></param>
        public static void SetOverlayPosition(int overlayId, Vector2 pos)
        {
            overlayPos(overlayId, pos.X, pos.Y);
        }

        /// <summary>
        /// Changes the overlay coordinates
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="pos"></param>
        public static void SetOverlayPosition(int overlayId, float x, float y)
        {
            overlayPos(overlayId, x, y);
        }

        /// <summary>
        /// Changes the overlay coordinates
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="pos"></param>
        public static void SetOverlayPosition(int overlayId, float[] pos)
        {
            overlayPos(overlayId, pos[0], pos[1]);
        }

        /// <summary>
        /// Changes the overlay size, if the overlay is scaled then the values must be in percentage
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="size"></param>
        public static void SetOverlaySizeOrScale(int overlayId, SizeF size)
        {
            overlaySize(overlayId, size.Width, size.Height);
        }

        /// <summary>
        /// Changes the overlay size, if the overlay is scaled then the values must be in percentage
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="size"></param>
        public static void SetOverlaySizeOrScale(int overlayId, float w, float h)
        {
            overlaySize(overlayId, w, h);
        }

        /// <summary>
        /// Changes the overlay size, if the overlay is scaled then the values must be in percentage
        /// </summary>
        /// <param name="overlayId"></param>
        /// <param name="size"></param>
        public static void SetOverlaySizeOrScale(int overlayId, float[] size)
        {
            overlaySize(overlayId, size[0], size[1]);
        }

        public static void SetOverlayRotation(int overlayId, float rotation)
        {
            if (overlay == 0) return;
            CallMinimapScaleformFunction(overlay, "UPDATE_OVERLAY_ROTATION");
            ScaleformMovieMethodAddParamInt(overlayId - 1);
            ScaleformMovieMethodAddParamFloat(rotation);
            EndScaleformMovieMethod();
            minimaps[overlayId - 1].rotation = rotation;
        }

        private static void overlayPos(int overlayId, float x, float y)
        {
            if (overlay == 0) return;
            CallMinimapScaleformFunction(overlay, "UPDATE_OVERLAY_POSITION");
            ScaleformMovieMethodAddParamInt(overlayId - 1);
            ScaleformMovieMethodAddParamFloat(x);
            ScaleformMovieMethodAddParamFloat(y);
            EndScaleformMovieMethod();
            minimaps[overlayId - 1].position = new Vector2(x, y);
        }

        private static void overlaySize(int overlayId, float w, float h)
        {
            if (overlay == 0) return;
            CallMinimapScaleformFunction(overlay, "UPDATE_OVERLAY_SIZE_OR_SCALE");
            ScaleformMovieMethodAddParamInt(overlayId - 1);
            ScaleformMovieMethodAddParamFloat(w);
            ScaleformMovieMethodAddParamFloat(h);
            EndScaleformMovieMethod();
            minimaps[overlayId - 1].size = new SizeF(w, h);
        }


        /// <summary>
        /// Remove an overlay from the ingame Map
        /// </summary>
        /// <param name="overlayId">Id of the overlay to remove</param>
        public static async void RemoveOverlayFromMinimap(int overlayId)
        {
            if (overlay == 0) await Load();
            CallMinimapScaleformFunction(overlay, "REM_OVERLAY");
            ScaleformMovieMethodAddParamInt(overlayId - 1);
            EndScaleformMovieMethod();
            minimaps.RemoveAt(overlayId - 1);
        }

        /// <summary>
        /// Removes all the overlays from the minimap
        /// </summary>
        public static void ClearAll()
        {
            if (overlay == 0) return;
            CallMinimapScaleformFunction(overlay, "CLEAR_ALL");
            EndScaleformMovieMethod();
            minimaps.Clear();
        }
    }
}
