using CitizenFX.Core;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;
using System.Drawing;
using static CitizenFX.Core.Native.API;

namespace ScaleformUI.Elements
{
    /// <summary>
    /// Tools to deal with the game screen.
    /// </summary>
    public static class ScreenTools
    {
        /// <summary>
        /// The 1080pixels-based screen resolution while mantaining current aspect ratio.
        /// </summary>
        public static SizeF ResolutionMaintainRatio
        {
            get
            {
                // Get the game width and height
                int screenw = Screen.Resolution.Width;
                int screenh = Screen.Resolution.Height;
                // Calculate the ratio
                float ratio = (float)screenw / screenh;
                // And the width with that ratio
                float width = 1080f * ratio;
                // Finally, return a SizeF
                return new SizeF(width, 1080f);
            }
        }

        /// <summary>
        /// Convert resolution coords (es. 1920 x 1080) to scaleform coords.
        /// </summary>
        /// <param name="realX">The real X.</param>
        /// <param name="realY">The real Y.</param>
        /// <returns>A Vector2 with coordinates in 1280 x 720 scale</returns>
        public static Vector2 ConvertResolutionCoordsToScaleformCoords(float realX, float realY)
        {
            Size screen = Screen.Resolution;
            return new(realX / screen.Width * 1280, realY / screen.Height * 720);
        }

        /// <summary>
        /// Convert scaleform coords to resolution coords (es. 1920 x 1080).
        /// </summary>
        /// <param name="scaleformX">The scaleform X.</param>
        /// <param name="scaleformY">The scaleform Y.</param>
        /// <returns>A Vector2 with coordinates in player's actual resolution</returns>
        public static Vector2 ConvertScaleformCoordsToResolutionCoords(float scaleformX, float scaleformY)
        {
            Size screen = Screen.Resolution;
            return new Vector2(scaleformX / 1280 * screen.Width, scaleformY / 720 * screen.Height);
        }

        /// <summary>
        /// Convert screen coords (0.0 - 1.0) to scaleform coords.
        /// </summary>
        /// <param name="scX">The screen coord X.</param>
        /// <param name="scY">The screen coord Y.</param>
        /// <returns>A Vector2 with coordinates in 1280 x 720 scale</returns>
        public static Vector2 ConvertScreenCoordsToScaleformCoords(float scX, float scY)
        {
            return new (scX * 1280, scY * 720);
        }

        /// <summary>
        /// Convert scaleform coords to screen coords (0.0 - 1.0).
        /// </summary>
        /// <param name="scaleformX">The scaleform X.</param>
        /// <param name="scaleformY">The scaleform Y.</param>
        /// <returns>A Vector2 with coordinates in screen coords resolution (0.0 - 1.0)</returns>
        public static Vector2 ConvertScaleformCoordsToScreenCoords(float scaleformX, float scaleformY)
        {
            // Normalize coordinates to 0.0 - 1.0 range
            int w = 0, h = 0;
            GetActiveScreenResolution(ref w, ref h);
            return new Vector2((scaleformX / w) * 2f - 1f, (scaleformY / h) * 2f - 1f);
        }

        public static Vector2 ConvertResolutionCoordsToScreenCoords(float x, float y)
        {
            float normalizedX = Math.Max(0.0f, Math.Min(1.0f, (float)x / 1920.0f));
            float normalizedY = Math.Max(0.0f, Math.Min(1.0f, (float)y / 1080.0f));

            return new Vector2(normalizedX, normalizedY);
        }

        public static void AdjustNormalized16_9ValuesForCurrentAspectRatio(int widescreen, ref Vector2 pos, ref SizeF size)
        {
            if (widescreen == 0)
            {
                float oldPosX = pos != null ? pos.X : 0.5f;
                if (oldPosX > 0.5f)
                    widescreen = 2;
                else if (oldPosX < 0.5f)
                    widescreen = 1;
                else
                    widescreen = 3;
            }

            float fPhysicalAspect = GetAspectRatio(false);
            if (IsSuperWideScreen())
            {
                fPhysicalAspect = 16f / 9f;
            }

            float fScalar = (16f / 9f) / fPhysicalAspect, fAdjustPos = 1.0f - fScalar;
            switch (widescreen)
            {
                case 1:
                    if (size != null)
                        size.Width *= fScalar;

                    if (pos != null)
                        pos = new Vector2(pos.X *= fScalar, pos.Y);
                    break;
                case 2:
                    if (size != null)
                        size.Width *= fScalar;

                    if (pos != null)
                        pos = new Vector2((pos.X *= fScalar) + fAdjustPos, pos.Y);
                    break;
                case 3:
                    if (size != null)
                        size.Width *= fScalar;

                    if (pos != null)
                        pos = new Vector2((pos.X *= fScalar) + fAdjustPos * 0.5f, pos.Y);
                    break;
                case 4:
                    if (size != null)
                        size.Width *= fScalar;
                    break;
            }
            AdjustForSuperWidescreen(ref pos, ref size);
        }

        private static void AdjustForSuperWidescreen(ref Vector2 pos, ref SizeF size)
        {
            if (!IsSuperWideScreen())
            {
                return;
            }

            float fDifference = ((16f/9f) / GetAspectRatio(false));
            if (pos != null)
                pos = new Vector2(0.5f - ((0.5f - pos.X) * fDifference));

            if (size != null)
                size.Width *= fDifference;
        }

        public static bool IsSuperWideScreen()
        {
            float fAspectRatio = GetAspectRatio(false);
            return fAspectRatio > (16f / 9f);

        }

        public static bool GetWideScreen()
        {
            float WIDESCREEN_ASPECT = 1.5f;
            float fLogicalAspectRatio = GetAspectRatio(false);
            float fPhysicalAspectRatio = Screen.Resolution.Width / Screen.Resolution.Height;
            if (fPhysicalAspectRatio <= WIDESCREEN_ASPECT)
                return false;

            return fLogicalAspectRatio > WIDESCREEN_ASPECT;
        }

        /// <summary>
        /// Chech whether the mouse is inside the specified rectangle.
        /// </summary>
        /// <param name="topLeft">Start point of the rectangle at the top left.</param>
        /// <param name="boxSize">size of your rectangle.</param>
        /// <returns>true if the mouse is inside of the specified bounds, false otherwise.</returns>
        public static bool IsMouseInBounds(Point topLeft, Size boxSize)
        {
            Game.EnableControlThisFrame(0, Control.CursorX);
            Game.EnableControlThisFrame(0, Control.CursorY);
            // Get the resolution while maintaining the ratio.
            SizeF res = ResolutionMaintainRatio;
            // Then, get the position of mouse on the screen while relative to the current resolution
            int mouseX = (int)Math.Round(API.GetDisabledControlNormal(0, 239) * res.Width);
            int mouseY = (int)Math.Round(API.GetDisabledControlNormal(0, 240) * res.Height);
            // And check if the mouse is on the rectangle bounds
            bool isX = mouseX >= topLeft.X && mouseX <= topLeft.X + boxSize.Width;
            bool isY = mouseY > topLeft.Y && mouseY < topLeft.Y + boxSize.Height;
            // Finally, return the result of the checks
            return isX && isY;
        }

        public static bool IsMouseInBounds(PointF topLeft, SizeF boxSize)
        {
            Game.EnableControlThisFrame(0, Control.CursorX);
            Game.EnableControlThisFrame(0, Control.CursorY);
            // Get the resolution while maintaining the ratio.
            SizeF res = ResolutionMaintainRatio;
            // Then, get the position of mouse on the screen while relative to the current resolution
            float mouseX = GetDisabledControlNormal(0, 239) * res.Width;
            float mouseY = GetDisabledControlNormal(0, 240) * res.Height;
            // And check if the mouse is on the rectangle bounds
            bool isX = mouseX >= topLeft.X && mouseX <= topLeft.X + boxSize.Width;
            bool isY = mouseY > topLeft.Y && mouseY < topLeft.Y + boxSize.Height;
            // Finally, return the result of the checks
            return isX && isY;
        }

        public static bool IsMouseInBounds(Point topLeft, Size boxSize, Point DrawOffset)
        {
            Game.EnableControlThisFrame(0, Control.CursorX);
            Game.EnableControlThisFrame(0, Control.CursorY);
            SizeF res = ResolutionMaintainRatio;

            int mouseX = (int)Math.Round(API.GetDisabledControlNormal(0, 239) * res.Width);
            int mouseY = (int)Math.Round(API.GetDisabledControlNormal(0, 240) * res.Height);

            mouseX += DrawOffset.X;
            mouseY += DrawOffset.Y;

            return (mouseX >= topLeft.X && mouseX <= topLeft.X + boxSize.Width)
                   && (mouseY > topLeft.Y && mouseY < topLeft.Y + boxSize.Height);
        }

        public static bool IsMouseInBounds(PointF topLeft, SizeF boxSize, PointF DrawOffset)
        {
            Game.EnableControlThisFrame(0, Control.CursorX);
            Game.EnableControlThisFrame(0, Control.CursorY);
            SizeF res = ResolutionMaintainRatio;

            float mouseX = GetDisabledControlNormal(0, 239) * res.Width;
            float mouseY = GetDisabledControlNormal(0, 240) * res.Height;

            mouseX += DrawOffset.X;
            mouseY += DrawOffset.Y;

            return (mouseX >= topLeft.X && mouseX <= topLeft.X + boxSize.Width)
                   && (mouseY > topLeft.Y && mouseY < topLeft.Y + boxSize.Height);
        }

        /// <summary>
        /// Returns the safezone bounds in pixel, relative to the 1080pixel based system.
        /// </summary>
        /// <returns></returns>
        /// <summary>
        /// Safezone bounds relative to the 1080pixel based resolution.
        /// </summary>
        public static Point SafezoneBounds
        {
            get
            {
                // Get the size of the safezone as a float
                float t = GetSafeZoneSize();
                // Round the value with a max of 2 decimal places and do some calculations
                double g = Math.Round(Convert.ToDouble(t), 2);
                g = (g * 100) - 90;
                g = 10 - g;

                // Then, get the screen resolution
                float screenw = Screen.ScaledWidth;
                float screenh = Screen.Height;
                // Calculate the ratio
                float ratio = (float)screenw / screenh;
                // And this thing (that I don't know what it does)
                float wmp = ratio * 5.4f;

                // Finally, return a new point with the correct resolution
                return new Point((int)Math.Round(g * wmp), (int)Math.Round(g * 5.4f));
            }
        }

        /// <summary>
        /// Calculates the width of a string.
        /// </summary>
        /// <param name="text">The text to measure.</param>
        /// <param name="font">Game font used for measurements.</param>
        /// <param name="scale">The scale of the characters.</param>
        /// <returns>The width of the string based on the font and scale.</returns>
        public static float GetTextWidth(string text, CitizenFX.Core.UI.Font font, float scale)
        {
            // Start by requesting the game to start processing a width measurement
            SetTextEntryForWidth("CELL_EMAIL_BCON"); // _BEGIN_TEXT_COMMAND_WIDTH
                                                     // Add the text string
            UIResText.AddLongString(text);
            // Set the properties for the text
            SetTextFont((int)font);
            SetTextScale(1f, scale);

            // Ask the game for the relative string width
            float width = GetTextScreenWidth(true);
            // And return the literal result
            return ResolutionMaintainRatio.Width * width;
        }

        /// <summary>
        /// Gets the line count for the text.
        /// </summary>
        /// <param name="text">The text to measure.</param>
        /// <param name="position">The position of the text.</param>
        /// <param name="font">The font to use.</param>
        /// <returns>The number of lines used.</returns>
        public static int GetLineCount(string text, Point position, CitizenFX.Core.UI.Font font, float scale, int wrap)
        {
            // Tell the game that we are going to request the number of lines
            BeginTextCommandLineCount("CELL_EMAIL_BCON"); // _BEGIN_TEXT_COMMAND_LINE_COUNT

            UIResText.AddLongString(text);// Add the text that has been sent to us

            // Get the resolution with the correct aspect ratio
            SizeF res = ResolutionMaintainRatio;
            // Calculate the x and y positions
            float x = position.X / res.Width;
            float y = position.Y / res.Height;

            // Set the properties for the text
            SetTextFont((int)font);
            SetTextScale(1f, scale);

            // If there is some text wrap to add
            if (wrap > 0)
            {
                // Calculate the wrap size
                float start = position.X / res.Width;
                float end = start + (wrap / res.Width);
                // And apply it
                SetTextWrap(x, end);
            }
            // Finally, return the number of lines being made by the string
            return GetTextScreenLineCount(x, y); // _GET_TEXT_SCREEN_LINE_COUNT
        }

        public static int GetLineCount(string text, PointF position, CitizenFX.Core.UI.Font font, float scale, float wrap)
        {
            // Tell the game that we are going to request the number of lines
            BeginTextCommandLineCount("CELL_EMAIL_BCON"); // _BEGIN_TEXT_COMMAND_LINE_COUNT

            // Add the text that has been sent to us
            UIResText.AddLongString(text);// Add the text that has been sent to us
                                          // Get the resolution with the correct aspect ratio
            SizeF res = ResolutionMaintainRatio;
            // Calculate the x and y positions
            float x = position.X / res.Width;
            float y = position.Y / res.Height;

            // Set the properties for the text
            SetTextFont((int)font);
            SetTextScale(1f, scale);

            // If there is some text wrap to add
            if (wrap > 0)
            {
                // Calculate the wrap size
                float start = position.X / res.Width;
                float end = start + (wrap / res.Width);
                // And apply it
                SetTextWrap(x, end);
            }
            // Finally, return the number of lines being made by the string
            return GetTextScreenLineCount(x, y); // _GET_TEXT_SCREEN_LINE_COUNT
        }
    }
}

