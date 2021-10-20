using System;
using System.Drawing;
using System.Threading.Tasks;
using CitizenFX.Core;
using CitizenFX.Core.Native;
using CitizenFX.Core.UI;
using static CitizenFX.Core.Native.API;
using Font = CitizenFX.Core.UI.Font;
namespace NativeUI
{
	public enum NotificationType : int
	{
		Default = 0,
		Bubble = 1,
		Mail = 2,
		FriendRequest = 3,
		Default2 = 4,
		Reply = 7,
		ReputationPoints = 8,
		Money = 9
	}

	public enum NotificationColor
	{
		Red = 27,
		Yellow = 50,
		Gold = 12,
		GreenLight = 46,
		GreenDark = 47,
		Cyan = 48,
		Blue = 51,
		Purple = 49,
		Rose = 45
	}

	public enum IconType
	{
		ChatBox = 1,
		Email = 2,
		AdDFriendRequest = 3,
		RightJumpingArrow = 7,
		RPIcon = 8,
		DollarIcon = 9
	}

	// Had to copy from Cfx API or i wouldn't have been able to use it
	public sealed class NativeUINotification
	{
		#region Fields
		int _handle;
		#endregion

		internal NativeUINotification(int handle)
		{
			_handle = handle;
		}

		/// <summary>
		/// Hides this <see cref="NativeUINotification"/> instantly
		/// </summary>
		public void Hide()
		{
			ThefeedRemoveItem(_handle);
		}
	}


	public class Notifications
	{
		/// <summary>
		/// Shows a simple notification
		/// </summary>
		/// <param name="msg"> Notification text </param>
		/// <param name="blink"> if true the notification will blink </param>
		/// <param name="showBriefing"> if true the notification will visible in briefing page in pause menu </param>
		/// <returns></returns>
		public static NativeUINotification ShowNotification(string msg, bool blink = false, bool showBriefing = true)
		{
			AddTextEntry("NativeUINotification", msg);
			BeginTextCommandThefeedPost("NativeUINotification");
			return new NativeUINotification(EndTextCommandThefeedPostTicker(blink, showBriefing));
		}

		/// <summary>
		/// Shows a simple colored notification
		/// </summary>
		/// <param name="msg"> Notification text </param>
		/// <param name="color"> Notification color </param>
		/// <param name="blink"> if true the notification will blink </param>
		/// <param name="showBriefing"> if true the notification will visible in briefing page in pause menu </param>
		/// <returns></returns>
		public static NativeUINotification ShowNotification(string msg, NotificationColor color, bool blink = false, bool showBriefing = true)
		{
			AddTextEntry("NativeUINotification", msg);
			BeginTextCommandThefeedPost("NativeUINotification");
			ThefeedNextPostBackgroundColor((int)color);
			return new NativeUINotification(EndTextCommandThefeedPostTicker(blink, showBriefing));
		}

		/// <summary>
		/// Shows the classic Help Text in Top-Left on the screen, call this every frame (on Tick)
		/// </summary>
		/// <param name="helpText">Text to be shown</param>
		public static void ShowHelpNotification(string helpText)
		{
			AddTextEntry("NativeUIHelpText", helpText);
			DisplayHelpTextThisFrame("NativeUIHelpText", false);
		}

		/// <summary>
		/// Shows the classic Help Text in Top-Left on the screen for the amount of time specified (Max 5 seconds, NO NEED TO CALL THIS PER FRAME)
		/// </summary>
		/// <param name="helpText">Text to be shown</param>
		/// <param name="time">Amount of time (milliseconds)</param>
		public static void ShowHelpNotification(string helpText, int time)
		{
			if (time > 5000) time = 5000;
			AddTextEntry("NativeUIHelpText", helpText);
			BeginTextCommandDisplayHelp("NativeUIHelpText");
			EndTextCommandDisplayHelp(0, false, true, time);
		}

		/// <summary>
		/// Shows a 3D Help Notification in the desired coordinates (call this onTick)
		/// </summary>
		/// <param name="msg">The text of the notification</param>
		/// <param name="coords">World coordinates</param>
		/// <param name="time"></param>
		public static void ShowFloatingHelpNotification(string msg, Vector3 coords, int time = -1)
		{
			AddTextEntry("NativeUIFloatingHelpText", msg);
			SetFloatingHelpTextWorldPosition(1, coords.X, coords.Y, coords.Z);
			SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0);
			BeginTextCommandDisplayHelp("NativeUIFloatingHelpText");
			EndTextCommandDisplayHelp(2, false, false, time);
		}

		/// <summary>
		/// Shows a notification cellphone style with picture
		/// </summary>
		/// <param name="title">Title of the notification</param>
		/// <param name="subtitle">Subtitle of the notification</param>
		/// <param name="text">Main text of the notification</param>
		/// <param name="iconSet">The texture dictionary for the icon (see <see cref="NotificationChar"/>for a list of default icons)</param>
		/// <param name="icon">The texture name for the icon</param>
		/// <param name="bgColor">The background color for the notification, defaults to NONE</param>
		/// <param name="flashColor">Set a <see cref="Color"/> to flash the notification to, if blink is <see langword="true"/> this is ignored</param>
		/// <param name="blink">Wether to blink or not the notification</param>
		/// <param name="type">The <see cref="NotificationType"/></param>
		/// <param name="showInBrief">True to show it in Briefing page in Pause Menu</param>
		/// <param name="sound">If true a sound will be played on notification appearing</param>
		public static NativeUINotification ShowAdvancedNotification(string title, string subtitle, string text, string iconSet = "Default", string icon = "Default", HudColor bgColor = HudColor.NONE, Color flashColor = new Color(), bool blink = false, NotificationType type = NotificationType.Default, bool showInBrief = true, bool sound = true)
		{
			AddTextEntry("NativeUIAdvancedNotification", text);
			BeginTextCommandThefeedPost("NativeUIAdvancedNotification");
			AddTextComponentSubstringPlayerName(text);
			if (bgColor != HudColor.NONE)
				SetNotificationBackgroundColor((int)bgColor);
			if (!flashColor.IsEmpty && blink)
				SetNotificationFlashColor(flashColor.R, flashColor.G, flashColor.B, flashColor.A);
			if (sound) Audio.PlaySoundFrontend("DELETE", "HUD_DEATHMATCH_SOUNDSET");
			return new NativeUINotification(EndTextCommandThefeedPostMessagetext(iconSet, icon, true, (int)type, title, subtitle));
			//return new Notification(EndTextCommandThefeedPostTicker(blink, showInBrief));
		}

		/// <summary>
		/// Shows a statistic increase notification
		/// </summary>
		/// <param name="newProgress">New increased value</param>
		/// <param name="oldProgress">Old value before new value</param>
		/// <param name="title">Title of the notification</param>
		/// <param name="blink">Notification Blink</param>
		/// <param name="showBrief">Show or not in Pause Menu briefing page</param>
		public static async void ShowStatNotification(int newProgress, int oldProgress, string title, bool blink = false, bool showBrief = true)
		{
			AddTextEntry("NativeUIStatsNotification", title);
			Tuple<int, string> mug = await GetPedMugshotAsync(Game.PlayerPed);
			BeginTextCommandThefeedPost("PS_UPDATE");
			AddTextComponentInteger(newProgress);
			Function.Call(Hash.END_TEXT_COMMAND_THEFEED_POST_STATS, "NativeUIStatsNotification", 2, newProgress, oldProgress, false, mug.Item2, mug.Item2);
			EndTextCommandThefeedPostTicker(blink, showBrief);
			UnregisterPedheadshot(mug.Item1);
		}

		/// <summary>
		/// Show a VS notification (like in GTA:O)
		/// </summary>
		/// <param name="otherPed">The other Ped to show in notification</param>
		/// <param name="color1">My color</param>
		/// <param name="color2">Other ped color</param>
		public static async void ShowVSNotification(Ped otherPed, HudColor color1, HudColor color2)
		{
			var mug = await GetPedMugshotAsync(Game.PlayerPed);
			var otherMug = await GetPedMugshotAsync(otherPed);
			BeginTextCommandThefeedPost("");
			Function.Call(Hash.END_TEXT_COMMAND_THEFEED_POST_VERSUS_TU, mug.Item2, mug.Item2, 12, otherMug.Item2, otherMug.Item2, 1, color1, color2);
		}

		/// <summary>
		/// Show a VS notification (like in GTA:O) between 2 peds
		/// </summary>
		/// <param name="otherPed1">Ped on the left</param>
		/// <param name="otherPed2">Ped on the right</param>
		/// <param name="color1">Color for Ped on the left</param>
		/// <param name="color2">Color for ped on the right</param>
		public static async void ShowVSNotification(Ped otherPed1, Ped otherPed2, HudColor color1, HudColor color2)
		{
			var mug = await GetPedMugshotAsync(otherPed1);
			var otherMug = await GetPedMugshotAsync(otherPed2);
			BeginTextCommandThefeedPost("");
			Function.Call(Hash.END_TEXT_COMMAND_THEFEED_POST_VERSUS_TU, mug.Item2, mug.Item2, 12, otherMug.Item2, otherMug.Item2, 1, color1, color2);
		}

		/// <summary>
		/// Draws a 3D text on the screen at desired world coords relative to the <see cref="GameplayCamera"/>
		/// </summary>
		/// <param name="text">Main text</param>
		/// <param name="coord">World coordinates</param>
		/// <param name="color">Text color</param>
		/// <param name="font">Set the desired <see cref="Font"/></param>
		/// <param name="scale">Text scale (Default is 17.0f)</param>
		public static void DrawText3D(string text, Vector3 coord, Color color, Font font = Font.ChaletComprimeCologne, float scale = 17f)
		{
			Vector3 cam = GameplayCamera.Position;
			float dist = Vector3.Distance(coord, cam);
			float scaleInternal = (1 / dist) * scale;
			float fov = (1 / GameplayCamera.FieldOfView) * 100;
			float _scale = scaleInternal * fov;
			SetTextScale(0.1f * _scale, 0.15f * _scale);
			SetTextFont((int)font);
			SetTextProportional(true);
			SetTextColour(color.R, color.G, color.B, color.A);
			SetTextDropshadow(5, 0, 0, 0, 255);
			SetTextEdge(2, 0, 0, 0, 150);
			SetTextDropShadow();
			SetTextOutline();
			SetTextCentre(true);
			SetDrawOrigin(coord.X, coord.Y, coord.Z, 0);
			BeginTextCommandDisplayText("STRING");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(0, 0);
			ClearDrawOrigin();
		}

		/// <summary>
		/// Draws a 3D text on the screen at desired world coords relative to any scripted <see cref="Camera"/>
		/// </summary>
		/// <param name="camera">The scripted Camera to refer</param>
		/// <param name="text">Main text</param>
		/// <param name="coord">World coordinates</param>
		/// <param name="color">Text color</param>
		/// <param name="font">Set the desired <see cref="Font"/></param>
		/// <param name="scale">Text scale (Default is 17.0f)</param>
		public static void DrawText3D(Camera camera, string text, Vector3 coord, Color color, Font font = Font.ChaletComprimeCologne, float scale = 17f)
		{
			Vector3 cam = camera.Position;
			float dist = Vector3.Distance(coord, cam);
			float scaleInternal = (1 / dist) * scale;
			float fov = (1 / camera.FieldOfView) * 100;
			float _scale = scaleInternal * fov;
			SetTextScale(0.1f * _scale, 0.15f * _scale);
			SetTextFont((int)font);
			SetTextProportional(true);
			SetTextColour(color.R, color.G, color.B, color.A);
			SetTextDropshadow(5, 0, 0, 0, 255);
			SetTextEdge(2, 0, 0, 0, 150);
			SetTextDropShadow();
			SetTextOutline();
			SetTextCentre(true);
			SetDrawOrigin(coord.X, coord.Y, coord.Z, 0);
			BeginTextCommandDisplayText("STRING");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(0, 0);
			ClearDrawOrigin();
		}

		/// <summary>
		/// Draws a 2D text on screen
		/// </summary>
		/// <param name="text">Text to draw</param>
		public static void DrawText(string text)
		{
			SetTextFont(4);
			SetTextProportional(false);
			SetTextScale(0.0f, 0.5f);
			SetTextColour(255, 255, 255, 255);
			SetTextDropshadow(0, 0, 0, 0, 255);
			SetTextEdge(1, 0, 0, 0, 255);
			SetTextDropShadow();
			SetTextOutline();
			SetTextCentre(true);
			SetTextEntry("STRING");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(0.5f, 0.8f);
		}

		/// <summary>
		/// Draws a 2D text on screen
		/// </summary>
		/// <param name="x">X position on the screen</param>
		/// <param name="y">Y position on the screen</param>
		/// <param name="text">Text to draw</param>
		public static void DrawText(float x, float y, string text)
		{
			SetTextFont(4);
			SetTextProportional(false);
			SetTextScale(0.0f, 0.5f);
			SetTextColour(255, 255, 255, 255);
			SetTextDropshadow(0, 0, 0, 0, 255);
			SetTextEdge(1, 0, 0, 0, 255);
			SetTextDropShadow();
			SetTextOutline();
			SetTextCentre(false);
			SetTextEntry("STRING");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(x, y);
		}

		/// <summary>
		/// Draws a 2D text on screen
		/// </summary>
		/// <param name="x">X position on the screen</param>
		/// <param name="y">Y position on the screen</param>
		/// <param name="text">Text to draw</param>
		/// <param name="color">Color of the text</param>
		public static void DrawText(float x, float y, string text, Color color)
		{
			SetTextFont(4);
			SetTextProportional(false);
			SetTextScale(0.0f, 0.5f);
			SetTextColour(color.R, color.G, color.B, color.A);
			SetTextDropshadow(0, 0, 0, 0, 255);
			SetTextEdge(1, 0, 0, 0, 255);
			SetTextDropShadow();
			SetTextOutline();
			SetTextCentre(true);
			SetTextEntry("STRING");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(x, y);
		}

		/// <summary>
		/// Draws a 2D text on screen
		/// </summary>
		/// <param name="x">X position on the screen</param>
		/// <param name="y">Y position on the screen</param>
		/// <param name="text">Text to draw</param>
		/// <param name="color">Color of the text</param>
		/// <param name="font">Text font</param>
		public static void DrawText(float x, float y, string text, Color color, Font font)
		{
			SetTextFont((int)font);
			SetTextScale(0.0f, 0.5f);
			SetTextColour(color.R, color.G, color.B, color.A);
			SetTextDropShadow();
			SetTextOutline();
			SetTextCentre(true);
			SetTextEntry("STRING");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(x, y);
		}

		/// <summary>
		/// Draws a 2D text on screen
		/// </summary>
		/// <param name="x">X position on the screen</param>
		/// <param name="y">Y position on the screen</param>
		/// <param name="text">Text to draw</param>
		/// <param name="color">Color of the text</param>
		/// <param name="font">Text font</param>
		/// <param name="TextAlignment">Text alignment</param>
		public static void DrawText(float x, float y, string text, Color color, Font font, Alignment TextAlignment)
		{
			SetTextFont((int)font);
			SetTextScale(0.0f, 0.5f);
			SetTextColour(color.R, color.G, color.B, color.A);
			SetTextDropShadow();
			SetTextOutline();
			switch (TextAlignment)
			{
				case Alignment.Center:
					SetTextCentre(true);
					break;
				case Alignment.Right:
					SetTextRightJustify(true);
					SetTextWrap(0, x);
					break;
			}
			SetTextEntry("STRING");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(x, y);
		}

		/// <summary>
		/// Draws a 2D text on screen
		/// </summary>
		/// <param name="x">X position on the screen</param>
		/// <param name="y">Y position on the screen</param>
		/// <param name="text">Text to draw</param>
		/// <param name="color">Color of the text</param>
		/// <param name="font">Text font</param>
		/// <param name="TextAlignment">Text alignment</param>
		/// <param name="Shadow">True to set a text shadow</param>
		/// <param name="Outline">True to outline the text</param>
		/// <param name="Wrap">Wrap the text at desired boundries</param>
		public static void DrawText(float x, float y, string text, Color color, CitizenFX.Core.UI.Font font, Alignment TextAlignment, bool Shadow = false, bool Outline = false, float Wrap = 0)
		{
			int screenw = Screen.Resolution.Width;
			int screenh = Screen.Resolution.Height;
			const float height = 1080f;
			float ratio = (float)screenw / screenh;
			float width = height * ratio;

			SetTextFont((int)font);
			SetTextScale(0.0f, 0.5f);
			SetTextColour(color.R, color.G, color.B, color.A);
			if (Shadow)
				SetTextDropShadow();
			if (Outline)
				SetTextOutline();
			if (Wrap != 0)
			{
				float xsize = (x + Wrap) / width;
				SetTextWrap(x, xsize);
			}
			switch (TextAlignment)
			{
				case Alignment.Center:
					SetTextCentre(true);
					break;
				case Alignment.Right:
					SetTextRightJustify(true);
					SetTextWrap(0, x);
					break;
			}
			SetTextEntry("jamyfafi");
			AddTextComponentSubstringPlayerName(text);
			EndTextCommandDisplayText(x, y);
		}

		internal static async Task<Tuple<int, string>> GetPedMugshotAsync(Ped ped, bool transparent = false)
		{
			var mugshot = RegisterPedheadshot(ped.Handle);
			if (transparent) mugshot = RegisterPedheadshotTransparent(ped.Handle);
			while (!IsPedheadshotReady(mugshot)) await BaseScript.Delay(1);
			var txd = GetPedheadshotTxdString(mugshot);

			return new Tuple<int, string>(mugshot, txd);
		}
	}
}
