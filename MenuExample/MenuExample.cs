using System;
using System.Drawing;
using System.Collections.Generic;
using CitizenFX.Core;
using CitizenFX.Core.UI;
using ScaleformUI;
using CitizenFX.Core.Native;
using System.Linq;
using System.Threading.Tasks;
using ScaleformUI.PauseMenu;

public class MenuExample : BaseScript
{
	private bool enabled = true;
	private string dish = "Banana";
	private MenuPool _menuPool;

	public void ExampleMenu()
    {
		var txd = API.CreateRuntimeTxd("scaleformui");
		var _titledui = API.CreateDui("https://i.imgur.com/3yrFYbF.gif", 288, 130);
		API.CreateRuntimeTextureFromDuiHandle(txd, "bannerbackground", API.GetDuiHandle(_titledui));
	
		UIMenu exampleMenu = new UIMenu("ScaleformUI", "ScaleformUI SHOWCASE", new PointF(20, 20), "scaleformui", "bannerbackground", true, true); // true means add menu Glare scaleform to the menu
		exampleMenu.MaxItemsOnScreen = 7; // To decide max items on screen at time, default 7
		// let's add the menu to the Pool
		_menuPool.Add(exampleMenu);

		#region Menu Declaration

		#region Ketchup

		var ketchupItem = new UIMenuCheckboxItem("Scrolling animation enabled?", UIMenuCheckboxStyle.Tick, enabled, "Do you wish to enable the scrolling animation?");
		var _paneldui = API.CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160);
		API.CreateRuntimeTextureFromDuiHandle(txd, "panelbackground", API.GetDuiHandle(_paneldui));
		UIMissionDetailsPanel sidePanel = new UIMissionDetailsPanel(PanelSide.Right, "Side Panel", true, "scaleformui", "panelbackground");
		UIFreemodeDetailsItem detailItem1 = new UIFreemodeDetailsItem("Left Label", "Right Label", BadgeIcon.BRIEFCASE, HudColor.HUD_COLOUR_FREEMODE);
		UIFreemodeDetailsItem detailItem2 = new UIFreemodeDetailsItem("Left Label", "Right Label", BadgeIcon.STAR, HudColor.HUD_COLOUR_GOLD);
		UIFreemodeDetailsItem detailItem3 = new UIFreemodeDetailsItem("Left Label", "Right Label", BadgeIcon.ARMOR, HudColor.HUD_COLOUR_PURPLE);
		UIFreemodeDetailsItem detailItem4 = new UIFreemodeDetailsItem("Left Label", "Right Label", BadgeIcon.BRAND_DILETTANTE, HudColor.HUD_COLOUR_GREEN);
		UIFreemodeDetailsItem detailItem5 = new UIFreemodeDetailsItem("Left Label", "Right Label", BadgeIcon.COUNTRY_ITALY, HudColor.HUD_COLOUR_WHITE, true);
		sidePanel.AddItem(detailItem1);
		sidePanel.AddItem(detailItem2);
		sidePanel.AddItem(detailItem3);
		sidePanel.AddItem(detailItem4);
		sidePanel.AddItem(detailItem5);
		ketchupItem.AddSidePanel(sidePanel);
		ketchupItem.SetLeftBadge(BadgeIcon.STAR);
		exampleMenu.AddItem(ketchupItem);
		#endregion

		#region Cook

		var cookItem = new UIMenuItem("Cook!", "Cook the dish with the appropiate ingredients and ketchup.");
		exampleMenu.AddItem(cookItem);
		UIVehicleColourPickerPanel sidePanelB = new UIVehicleColourPickerPanel(PanelSide.Right, "ColorPicker");
		cookItem.AddSidePanel(sidePanelB);
		cookItem.SetRightBadge(BadgeIcon.STAR);
		sidePanelB.OnVehicleColorPickerSelect += (item, panel, value) =>
		{
			Notifications.ShowNotification($"Vehicle Color: {(VehicleColor)value}");
			sidePanelB.Title = ((VehicleColor)value).ToString();
		};

		var colorItem = new UIMenuItem("UIMenuItem with Colors", "~b~Look!!~r~I can be colored ~y~too!!~w~~n~Every item now supports custom colors!", HudColor.HUD_COLOUR_PURPLE, HudColor.HUD_COLOUR_PINK);
		exampleMenu.AddItem(colorItem);

		float dynamicvalue = 0f;
		var dynamicItem = new UIMenuDynamicListItem("Dynamic List Item", "Try pressing ~INPUT_FRONTEND_LEFT~ or ~INPUT_FRONTEND_RIGHT~", dynamicvalue.ToString("F3"), async (sender, direction) =>
		{
			if (direction == UIMenuDynamicListItem.ChangeDirection.Left) dynamicvalue -= 0.01f;
			else dynamicvalue += 0.01f;
			return dynamicvalue.ToString("F3");
		});
		dynamicItem.BlinkDescription = true;
		exampleMenu.AddItem(dynamicItem);

		var foodsList = new List<dynamic>
		{
			"LINEAR",
			"QUADRATIC_IN",
			"QUADRATIC_OUT",
			"QUADRATIC_INOUT",
			"CUBIC_IN",
			"CUBIC_OUT",
			"CUBIC_INOUT",
			"QUARTIC_IN",
			"QUARTIC_OUT",
			"QUARTIC_INOUT",
			"SINE_IN",
			"SINE_OUT",
			"SINE_INOUT",
			"BACK_IN",
			"BACK_OUT",
			"BACK_INOUT",
			"CIRCULAR_IN",
			"CIRCULAR_OUT",
			"CIRCULAR_INOUT"
		};

		var BlankItem = new UIMenuSeparatorItem("Separator (Jumped)", true);
		var BlankItem_2 = new UIMenuSeparatorItem("Separator (not Jumped)", false);
		exampleMenu.AddItem(BlankItem);
		exampleMenu.AddItem(BlankItem_2);

		var colorListItem = new UIMenuListItem("Choose the scrolling animation", foodsList, (int)exampleMenu.AnimationType, "~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!~n~⚠ 🐌 ❤️ 🥺 💪🏻 You can use Emojis too!", HudColor.HUD_COLOUR_FREEMODE_DARK, HudColor.HUD_COLOUR_FREEMODE);
		colorListItem.BlinkDescription = true;
		exampleMenu.AddItem(colorListItem);

		var slider = new UIMenuSliderItem("Slider Item", "Cool!", true); // by default max is 100 and multipler 5 = 20 steps.
		exampleMenu.AddItem(slider);
		var progress = new UIMenuProgressItem("Slider Progress Item", 10, 0);
		exampleMenu.AddItem(progress);

		var listPanelItem0 = new UIMenuItem("Change Color", "It can be whatever item you want it to be");
		var ColorPanel = new UIMenuColorPanel("Color Panel Example", ColorPanelType.Hair);
		// you can choose between hair palette or makeup palette or custom
		exampleMenu.AddItem(listPanelItem0);
		listPanelItem0.AddPanel(ColorPanel);

		var listPanelItem1 = new UIMenuItem("Custom palette panel");
		var ColorPanelCustom = new UIMenuColorPanel("Custom Palette Example", new List<HudColor> { HudColor.HUD_COLOUR_GREEN, HudColor.HUD_COLOUR_RED, HudColor.HUD_COLOUR_FREEMODE, HudColor.HUD_COLOUR_PURPLE, HudColor.HUD_COLOUR_TREVOR }, 0);
		exampleMenu.AddItem(listPanelItem1);
		listPanelItem1.AddPanel(ColorPanelCustom);

		var listPanelItem2 = new UIMenuItem("Change Percentage", "It can be whatever item you want it to be");
		var PercentagePanel = new UIMenuPercentagePanel("Percentage Panel", "0%", "100%");
		// You can change every text in this Panel
		exampleMenu.AddItem(listPanelItem2);
		listPanelItem2.AddPanel(PercentagePanel);

		var listPanelItem3 = new UIMenuItem("Change Grid Position", "It can be whatever item you want it to be");
		var GridPanel = new UIMenuGridPanel("Up", "Left", "Right", "Down", new System.Drawing.PointF(.5f, .5f));
		var HorizontalGridPanel = new UIMenuGridPanel("Left", "Right", new System.Drawing.PointF(.5f, .5f));
		// you can choose the text in every position and where to place the starting position of the cirlce
		exampleMenu.AddItem(listPanelItem3);
		listPanelItem3.AddPanel(GridPanel);
		listPanelItem3.AddPanel(HorizontalGridPanel);

		var listPanelItem4 = new UIMenuListItem("Look at Statistics", new List<object> { "Example", "example2" }, 0);
		var statistics = new UIMenuStatisticsPanel();
		exampleMenu.AddItem(listPanelItem4);
		listPanelItem4.AddPanel(statistics);
		statistics.AddStatistics("Look at this!", 0);
		statistics.AddStatistics("I'm a statistic too!", 0);
		statistics.AddStatistics("Am i not?!", 0);
		//you can add as menu statistics you want 
		statistics.UpdateStatistic(0, 10f);
		statistics.UpdateStatistic(1, 50f);
		statistics.UpdateStatistic(2, 100f);
		//and you can get / set their percentage

		#endregion

		#region Windows SubMenu
		var windowSubmenu = new UIMenu("Windows Menu", "submenu description");
		exampleMenu.AddSubMenu(windowSubmenu, "Windows SubMenu item label", "this is the submenu binded item description");
		windowSubmenu.ParentItem.SetRightLabel(">>>");
		var heritageWindow = new UIMenuHeritageWindow(0, 0);
		var statsWindow = new UIMenuDetailsWindow("Parents resemblance", "Dad:", "Mom:", true, new List<UIDetailStat>());
		windowSubmenu.AddWindow(heritageWindow);
		windowSubmenu.AddWindow(statsWindow);
		List<dynamic> momfaces = new List<dynamic>() { "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla", "Violet", "Sophia", "Eveline", "Nicole", "Ashley", "Grace", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Misty" };
		List<dynamic> dadfaces = new List<dynamic>() { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Joan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", "Claude", "Niko", "John" };
		List<dynamic> lista = new List<dynamic>();
		for (int i = 0; i < 101; i++) lista.Add(i);
		var mom = new UIMenuListItem("Mamma", momfaces, 0);
		var dad = new UIMenuListItem("Papà", dadfaces, 0);
		var newItem = new UIMenuSliderItem("Heritage Slider", "This is Useful on heritage", 100, 5, 50, true);
		windowSubmenu.AddItem(mom);
		windowSubmenu.AddItem(dad);
		windowSubmenu.AddItem(newItem);
		statsWindow.DetailMid = "Dad: " + newItem.Value + "%";
		statsWindow.DetailBottom = "Mom: " + (100 - newItem.Value) + "%";
		statsWindow.DetailStats = new List<UIDetailStat>()
		{
			new UIDetailStat(100-newItem.Value, HudColor.HUD_COLOUR_PINK),
			new UIDetailStat(newItem.Value, HudColor.HUD_COLOUR_FREEMODE),
		};
		#endregion

		#region Scaleforms SubMenu

		var scaleformMenu = _menuPool.AddSubMenu(exampleMenu, "Scaleforms Showdown");
		UIMenuItem showSimplePopup = new UIMenuItem("Show PopupWarning example", "You can customize it to your needs");
		UIMenuItem showPopupButtons = new UIMenuItem("Show PopupWarning with buttons", "It waits until a button has been pressed!");
		UIMenuListItem customInstr = new UIMenuListItem("SavingNotification", Enum.GetNames(typeof(LoadingSpinnerType)).Cast<dynamic>().ToList(), 0, "InstructionalButtons now give you the ability to dynamically edit, add, remove, customize your buttons, you can even use them outside the menu ~y~without having to run multiple instances of the same scaleform~w~, aren't you happy??");
		UIMenuItem customInstr2 = new UIMenuItem("Add a random InstructionalButton!", "InstructionalButtons now give you the ability to dynamically edit, add, remove, customize your buttons, you can even use them outside the menu ~y~without having to run multiple instances of the same scaleform~w~, aren't you happy??");
		UIMenuItem bigMessage = new UIMenuItem("BigMessage example", "");
		UIMenuItem midMessage = new UIMenuItem("MediumMessage example", "");
		scaleformMenu.AddItem(showSimplePopup);
		scaleformMenu.AddItem(showPopupButtons);
		scaleformMenu.AddItem(customInstr);
		scaleformMenu.AddItem(customInstr2);
		scaleformMenu.AddItem(bigMessage);
		scaleformMenu.AddItem(midMessage);

		#endregion

		#region Notifications SubMenu

		UIMenu notifications = _menuPool.AddSubMenu(exampleMenu, "Notifications Showdown");
		var colors = Enum.GetNames(typeof(NotificationColor)).ToList<dynamic>();
		colors.Add("Classic");
		var char_sprites = new List<dynamic>() { "Abigail", "Amanda", "Ammunation", "Andreas", "Antonia", "Ashley", "BankOfLiberty", "BankFleeca", "BankMaze", "Barry", "Beverly", "BikeSite", "BlankEntry", "Blimp", "Blocked", "BoatSite", "BrokenDownGirl", "BugStars", "Call911", "LegendaryMotorsport", "SSASuperAutos", "Castro", "ChatCall", "Chef", "Cheng", "ChengSenior", "Chop", "Cris", "Dave", "Default", "Denise", "DetonateBomb", "DetonatePhone", "Devin", "SubMarine", "Dom", "DomesticGirl", "Dreyfuss", "DrFriedlander", "Epsilon", "EstateAgent", "Facebook", "FilmNoire", "Floyd", "Franklin", "FranklinTrevor", "GayMilitary", "Hao", "HitcherGirl", "Hunter", "Jimmy", "JimmyBoston", "Joe", "Josef", "Josh", "LamarDog", "Lester", "Skull", "LesterFranklin", "LesterMichael", "LifeInvader", "LsCustoms", "LSTI", "Manuel", "Marnie", "Martin", "MaryAnn", "Maude", "Mechanic", "Michael", "MichaelFranklin", "MichaelTrevor", "WarStock", "Minotaur", "Molly", "MorsMutual", "ArmyContact", "Brucie", "FibContact", "RockStarLogo", "Gerald", "Julio", "MechanicChinese", "MerryWeather", "Unicorn", "Mom", "MrsThornhill", "PatriciaTrevor", "PegasusDelivery", "ElitasTravel", "Sasquatch", "Simeon", "SocialClub", "Solomon", "Taxi", "Trevor", "YouTube", "Wade" };

		var noti1 = new UIMenuListItem("Simple Notification", colors, colors.Count - 1, "Can be colored too! Change color and / or select this item to show the notification.");
		var noti2 = new UIMenuListItem("Advanced Notification", char_sprites, 0, "Change the char and see the notification example! (It can be colored too like the simple notification)");
		var noti3 = new UIMenuItem("Help Notification", "Insert your text and see the example.");
		var noti4 = new UIMenuItem("Floating Help Notification", "This is tricky, it's a 3D notification, you'll have to input a Vector3 to show it!");
		var noti5 = new UIMenuItem("Stats Notification", "This is the notification you see in GTA:O when you improve one of your skills.");
		var noti6 = new UIMenuItem("VS Notification", "This is the notification you see in GTA:O when you kill someone or get revenge.");
		var noti7 = new UIMenuItem("3D Text", "This is known a lot.. let's you draw a 3D text in a precise world coordinates.");
		var noti8 = new UIMenuItem("Simple Text", "This will let you draw a 2D text on screen, you'll have to input the 2D  (X, Y) coordinates.");
		notifications.AddItem(noti1);
		notifications.AddItem(noti2);
		notifications.AddItem(noti3);
		notifications.AddItem(noti4);
		notifications.AddItem(noti5);
		notifications.AddItem(noti6);
		notifications.AddItem(noti7);
		notifications.AddItem(noti8);

		#endregion

		#region PauseMenu Enabler

		UIMenuItem pause = new UIMenuItem("Open Pause Menu");
		exampleMenu.AddItem(pause);
		pause.Activated += (menu, item) =>
		{
			PauseMenuShowcase(menu);
		};

		#endregion

		#endregion

		#region Menu Events

		// here you can handle all the events for the mainMenu and its submenus or items themselves.. there's not a real order and if you want you can place these events 
		// right under the place where their menus/items were declared, i place them here for a creation order.

		// ====================================================================
		// =--------------------------- [Items] ------------------------------=
		// ====================================================================

		slider.OnSliderChanged += (item, index) =>
		{
			Screen.ShowSubtitle($"Slider changed => {index}");
		};

		progress.OnProgressChanged += (item, index) =>
		{
			Screen.ShowSubtitle($"Progress changed => {index}");
		};

		// ====================================================================
		// =--------------------------- [Panels] -----------------------------=
		// ====================================================================
		// THERE ARE NOW EVENT FOR PANELS.. WHEN YOU CHANGE WHAT IS CHANGABLE THE PANEL ITSELF WILL DO WHATEVER YOU TELL HIM TO DO

		ColorPanel.OnColorPanelChange += (item, panel, index) =>
		{
			Notifications.ShowNotification($"ColorPanel index => {index}");
		};

		ColorPanelCustom.OnColorPanelChange += (item, panel, index) =>
		{
			Notifications.ShowNotification($"ColorPanel index => {index}");
		};

		PercentagePanel.OnPercentagePanelChange += (item, panel, index) => {
			Screen.ShowSubtitle("Percentage = " + index + "...");
		};

		GridPanel.OnGridPanelChange += (item, panel, value) => {
			Screen.ShowSubtitle("GridPosition = " + value + "...");
		};

		HorizontalGridPanel.OnGridPanelChange += (item, panel, value) => {
			Screen.ShowSubtitle("HorizontalGridPosition = " + value + "...");
		};

		// ====================================================================
		// =---------------------- [Heritage SubMenu] ------------------------=
		// ====================================================================

		int MomIndex = 0;
		int DadIndex = 0;

		windowSubmenu.OnListChange += async (_sender, _listItem, _newIndex) =>
		{
			if (_listItem == mom)
			{
				MomIndex = _newIndex;
				heritageWindow.Index(MomIndex, DadIndex);
			}
			else if (_listItem == dad)
			{
				DadIndex = _newIndex;
				heritageWindow.Index(MomIndex, DadIndex);
			}
			// This way the heritage window changes only if you change a list item!
		};

		windowSubmenu.OnSliderChange += (sender, item, value) =>
		{
			statsWindow.DetailStats[0].Percentage = 100 - value;
			statsWindow.DetailStats[0].HudColor = HudColor.HUD_COLOUR_PINK;
			statsWindow.DetailStats[1].Percentage = value;
			statsWindow.DetailStats[1].HudColor = HudColor.HUD_COLOUR_FREEMODE;
            statsWindow.UpdateStatsToWheel();
			statsWindow.UpdateLabels("Parents resemblance", "Dad: " + value + "%", "Mom: " + (100 - value) + "%");
		};

		// ====================================================================
		// =--------------------- [Scaleforms SubMenu] -----------------------=
		// ====================================================================

		scaleformMenu.OnItemSelect += async (sender, item, index) =>
		{
			if (item == showSimplePopup)
			{
				ScaleformUI.ScaleformUI.Warning.ShowWarning("This is the title", "This is the subtitle", "This is the prompt.. you have 6 seconds left", "This is the error message, ScaleformUI Ver. 3.0");
				await Delay(1000);
				for (int i = 5; i > -1; i--)
				{
					ScaleformUI.ScaleformUI.Warning.UpdateWarning("This is the title", "This is the subtitle", $"This is the prompt.. you have {i} seconds left", "This is the error message, ScaleformUI Ver. 3.0");
					await Delay(1000);
				}
				ScaleformUI.ScaleformUI.Warning.Dispose();
			}
			else if (item == showPopupButtons)
			{
				List<InstructionalButton> buttons = new List<InstructionalButton>()
				{
					new InstructionalButton(Control.FrontendDown, "Accept only with Keyboard", PadCheck.Keyboard),
					new InstructionalButton(Control.FrontendY, "Cancel only with GamePad", PadCheck.Controller),
					new InstructionalButton(Control.FrontendX, Control.Detonate, "This will change button if you're using gamepad or keyboard"),
					new InstructionalButton(new List<Control> { Control.MoveUpOnly, Control.MoveLeftOnly , Control.MoveDownOnly , Control.MoveRightOnly }, "Woow multiple buttons at once??")
				};
				ScaleformUI.ScaleformUI.Warning.ShowWarningWithButtons("This is the title", "This is the subtitle", "This is the prompt, press any button", buttons, "This is the error message, ScaleformUI Ver. 3.0");
				ScaleformUI.ScaleformUI.Warning.OnButtonPressed += (button) =>
				{
					Debug.WriteLine($"You pressed a Button => {button.Text}");
				};
			}
			else if (item == customInstr2)
			{
				if (ScaleformUI.ScaleformUI.InstructionalButtons.ControlButtons.Count >= 6) return;
				ScaleformUI.ScaleformUI.InstructionalButtons.AddInstructionalButton(new InstructionalButton((Control)new Random().Next(0, 250), "I'm a new button look at me!"));
			}
			else if (item == bigMessage)
            {
				ScaleformUI.ScaleformUI.BigMessageInstance.ShowSimpleShard("TITLE", "SUBTITLE");
            }
			else if (item == midMessage)
            {
				ScaleformUI.ScaleformUI.MedMessageInstance.ShowColoredShard("TITLE", "SUBTITLE", HudColor.HUD_COLOUR_FREEMODE);
			}
		};

		customInstr.OnListSelected += (item, index) =>
		{
			if (ScaleformUI.ScaleformUI.InstructionalButtons.IsSaving) return;
			ScaleformUI.ScaleformUI.InstructionalButtons.AddSavingText((LoadingSpinnerType)(index + 1), "I'm a saving text", 3000);
		};

		// ====================================================================
		// =------------------- [Notifications SubMenu] ----------------------=
		// ====================================================================

		ScaleformUI.ScaleformUINotification notification = null;
		notifications.OnListChange += (_menu, _item, _index) =>
		{
			if (_item == noti1)
			{
				if (notification != null)
					notification.Hide();
				if (_index == (colors.Count - 1))
					notification = Notifications.ShowNotification("This is a simple notification without color and look how long it is wooow!", true, true);
				else
				{
					switch (_index)
					{
						case 0:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.Gold, true, true);
							break;
						case 1:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.Red, true, true);
							break;
						case 2:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.Rose, true, true);
							break;
						case 3:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.GreenLight, true, true);
							break;
						case 4:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.GreenDark, true, true);
							break;
						case 5:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.Cyan, true, true);
							break;
						case 6:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.Purple, true, true);
							break;
						case 7:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.Yellow, true, true);
							break;
						case 8:
							notification = Notifications.ShowNotification("This is a simple colored notification and look how long it is wooow!", NotificationColor.Blue, true, true);
							break;
					}
				}
			}
			else if (_item == noti2)
			{
				string selectedChar = NotificationChar.Abigail;
				#region SwitchStatement
				switch (_item.Items[_index])
				{
					case "Abigail":
						selectedChar = NotificationChar.Abigail;
						break;
					case "Amanda":
						selectedChar = NotificationChar.Amanda;
						break;
					case "Ammunation":
						selectedChar = NotificationChar.Ammunation;
						break;
					case "Andreas":
						selectedChar = NotificationChar.Andreas;
						break;
					case "Antonia":
						selectedChar = NotificationChar.Antonia;
						break;
					case "Ashley":
						selectedChar = NotificationChar.Ashley;
						break;
					case "BankOfLiberty":
						selectedChar = NotificationChar.BankOfLiberty;
						break;
					case "BankFleeca":
						selectedChar = NotificationChar.BankFleeca;
						break;
					case "BankMaze":
						selectedChar = NotificationChar.BankMaze;
						break;
					case "Barry":
						selectedChar = NotificationChar.Barry;
						break;
					case "Beverly":
						selectedChar = NotificationChar.Beverly;
						break;
					case "BikeSite":
						selectedChar = NotificationChar.BikeSite;
						break;
					case "BlankEntry":
						selectedChar = NotificationChar.BlankEntry;
						break;
					case "Blimp":
						selectedChar = NotificationChar.Blimp;
						break;
					case "Blocked":
						selectedChar = NotificationChar.Blocked;
						break;
					case "BoatSite":
						selectedChar = NotificationChar.BoatSite;
						break;
					case "BrokenDownGirl":
						selectedChar = NotificationChar.BrokenDownGirl;
						break;
					case "BugStars":
						selectedChar = NotificationChar.BugStars;
						break;
					case "Call911":
						selectedChar = NotificationChar.Call911;
						break;
					case "LegendaryMotorsport":
						selectedChar = NotificationChar.LegendaryMotorsport;
						break;
					case "SSASuperAutos":
						selectedChar = NotificationChar.SSASuperAutos;
						break;
					case "Castro":
						selectedChar = NotificationChar.Castro;
						break;
					case "ChatCall":
						selectedChar = NotificationChar.ChatCall;
						break;
					case "Chef":
						selectedChar = NotificationChar.Chef;
						break;
					case "Cheng":
						selectedChar = NotificationChar.Cheng;
						break;
					case "ChengSenior":
						selectedChar = NotificationChar.ChengSenior;
						break;
					case "Chop":
						selectedChar = NotificationChar.Chop;
						break;
					case "Cris":
						selectedChar = NotificationChar.Cris;
						break;
					case "Dave":
						selectedChar = NotificationChar.Dave;
						break;
					case "Default":
						selectedChar = NotificationChar.Default;
						break;
					case "Denise":
						selectedChar = NotificationChar.Denise;
						break;
					case "DetonateBomb":
						selectedChar = NotificationChar.DetonateBomb;
						break;
					case "DetonatePhone":
						selectedChar = NotificationChar.DetonatePhone;
						break;
					case "Devin":
						selectedChar = NotificationChar.Devin;
						break;
					case "SubMarine":
						selectedChar = NotificationChar.SubMarine;
						break;
					case "Dom":
						selectedChar = NotificationChar.Dom;
						break;
					case "DomesticGirl":
						selectedChar = NotificationChar.DomesticGirl;
						break;
					case "Dreyfuss":
						selectedChar = NotificationChar.Dreyfuss;
						break;
					case "DrFriedlander":
						selectedChar = NotificationChar.DrFriedlander;
						break;
					case "Epsilon":
						selectedChar = NotificationChar.Epsilon;
						break;
					case "EstateAgent":
						selectedChar = NotificationChar.EstateAgent;
						break;
					case "Facebook":
						selectedChar = NotificationChar.Facebook;
						break;
					case "FilmNoire":
						selectedChar = NotificationChar.FilmNoire;
						break;
					case "Floyd":
						selectedChar = NotificationChar.Floyd;
						break;
					case "Franklin":
						selectedChar = NotificationChar.Franklin;
						break;
					case "FranklinTrevor":
						selectedChar = NotificationChar.FranklinTrevor;
						break;
					case "GayMilitary":
						selectedChar = NotificationChar.GayMilitary;
						break;
					case "Hao":
						selectedChar = NotificationChar.Hao;
						break;
					case "HitcherGirl":
						selectedChar = NotificationChar.HitcherGirl;
						break;
					case "Hunter":
						selectedChar = NotificationChar.Hunter;
						break;
					case "Jimmy":
						selectedChar = NotificationChar.Jimmy;
						break;
					case "JimmyBoston":
						selectedChar = NotificationChar.JimmyBoston;
						break;
					case "Joe":
						selectedChar = NotificationChar.Joe;
						break;
					case "Josef":
						selectedChar = NotificationChar.Josef;
						break;
					case "Josh":
						selectedChar = NotificationChar.Josh;
						break;
					case "LamarDog":
						selectedChar = NotificationChar.LamarDog;
						break;
					case "Lester":
						selectedChar = NotificationChar.Lester;
						break;
					case "Skull":
						selectedChar = NotificationChar.Skull;
						break;
					case "LesterFranklin":
						selectedChar = NotificationChar.LesterFranklin;
						break;
					case "LesterMichael":
						selectedChar = NotificationChar.LesterMichael;
						break;
					case "LifeInvader":
						selectedChar = NotificationChar.LifeInvader;
						break;
					case "LsCustoms":
						selectedChar = NotificationChar.LsCustoms;
						break;
					case "LSTI":
						selectedChar = NotificationChar.LSTI;
						break;
					case "Manuel":
						selectedChar = NotificationChar.Manuel;
						break;
					case "Marnie":
						selectedChar = NotificationChar.Marnie;
						break;
					case "Martin":
						selectedChar = NotificationChar.Martin;
						break;
					case "MaryAnn":
						selectedChar = NotificationChar.MaryAnn;
						break;
					case "Maude":
						selectedChar = NotificationChar.Maude;
						break;
					case "Mechanic":
						selectedChar = NotificationChar.Mechanic;
						break;
					case "Michael":
						selectedChar = NotificationChar.Michael;
						break;
					case "MichaelFranklin":
						selectedChar = NotificationChar.MichaelFranklin;
						break;
					case "MichaelTrevor":
						selectedChar = NotificationChar.MichaelTrevor;
						break;
					case "WarStock":
						selectedChar = NotificationChar.WarStock;
						break;
					case "Minotaur":
						selectedChar = NotificationChar.Minotaur;
						break;
					case "Molly":
						selectedChar = NotificationChar.Molly;
						break;
					case "MorsMutual":
						selectedChar = NotificationChar.MorsMutual;
						break;
					case "ArmyContact":
						selectedChar = NotificationChar.ArmyContact;
						break;
					case "Brucie":
						selectedChar = NotificationChar.Brucie;
						break;
					case "FibContact":
						selectedChar = NotificationChar.FibContact;
						break;
					case "RockStarLogo":
						selectedChar = NotificationChar.RockStarLogo;
						break;
					case "Gerald":
						selectedChar = NotificationChar.Gerald;
						break;
					case "Julio":
						selectedChar = NotificationChar.Julio;
						break;
					case "MechanicChinese":
						selectedChar = NotificationChar.MechanicChinese;
						break;
					case "MerryWeather":
						selectedChar = NotificationChar.MerryWeather;
						break;
					case "Unicorn":
						selectedChar = NotificationChar.Unicorn;
						break;
					case "Mom":
						selectedChar = NotificationChar.Mom;
						break;
					case "MrsThornhill":
						selectedChar = NotificationChar.MrsThornhill;
						break;
					case "PatriciaTrevor":
						selectedChar = NotificationChar.PatriciaTrevor;
						break;
					case "PegasusDelivery":
						selectedChar = NotificationChar.PegasusDelivery;
						break;
					case "ElitasTravel":
						selectedChar = NotificationChar.ElitasTravel;
						break;
					case "Sasquatch":
						selectedChar = NotificationChar.Sasquatch;
						break;
					case "Simeon":
						selectedChar = NotificationChar.Simeon;
						break;
					case "SocialClub":
						selectedChar = NotificationChar.SocialClub;
						break;
					case "Solomon":
						selectedChar = NotificationChar.Solomon;
						break;
					case "Taxi":
						selectedChar = NotificationChar.Taxi;
						break;
					case "Trevor":
						selectedChar = NotificationChar.Trevor;
						break;
					case "YouTube":
						selectedChar = NotificationChar.YouTube;
						break;
					case "Wade":
						selectedChar = NotificationChar.Wade;
						break;
				}
				#endregion
				if (notification != null) notification.Hide();
				notification = Notifications.ShowAdvancedNotification("This is the title!!", "This is the subtitle!", "This is the main text!!", selectedChar, selectedChar, HudColor.NONE, Colors.AliceBlue, true, NotificationType.Default, true, true);
			}
		};

		notifications.OnItemSelect += async (_menu, _item, _index) =>
		{
			API.AddTextEntry("FMMC_KEY_TIP8", "Insert text (Max 50 chars):");
			string text = await Game.GetUserInput("", 50); // i set max 50 chars here as example but it can be way more!
			if (_item == noti3)
			{
				Notifications.ShowHelpNotification(text, 5000);
			}
			else if (_item == noti4)
			{

				_text = text;
				_timer = Game.GameTime + 1;
				Tick += FloatingHelpTimer;
			}
			else if (_item == noti5)
			{
				Notifications.ShowStatNotification(75, 50, text, true, true);
			}
			else if (_item == noti6)
			{
				Notifications.ShowVSNotification(Game.PlayerPed, HudColor.HUD_COLOUR_BLUE, HudColor.HUD_COLOUR_RED);
				// you must specify 1 or 2 peds for this.. in this case i use the player ped twice for the sake of the example.
			}
			else if (_item == noti7)
			{
				_text = text;
				_timer = Game.GameTime + 1;
				Tick += Text3DTimer;
			}
			else if (_item == noti8)
			{
				_text = text;
				_timer = Game.GameTime + 1;
				Tick += TextTimer;
			}
		};

		// ====================================================================
		// =------------------------- [Main Menu] ----------------------------=
		// ====================================================================

		exampleMenu.OnCheckboxChange += (sender, item, checked_) =>
		{
			if (item == ketchupItem)
			{
				enabled = checked_;
				sender.EnableAnimation = enabled;
				colorListItem.Enabled = enabled;
				Notifications.ShowNotification("~r~Menu animation: ~b~" + (enabled?"Enabled":"Disabled"));
			}
		};

		exampleMenu.OnItemSelect += (sender, item, index) =>
		{
			if (item == cookItem)
			{
				string output = enabled ? "You have ordered ~b~{0}~w~ ~r~with~w~ ketchup." : "You have ordered ~b~{0}~w~ ~r~without~w~ ketchup.";
				Screen.ShowSubtitle(String.Format(output, dish));
			}
		};

		exampleMenu.OnIndexChange += (sender, index) =>
		{
			//if (sender.MenuItems[index] == cookItem)
				//cookItem.SetLeftBadge(BadgeIcon.NONE);
		};

		exampleMenu.OnListChange += (sender, item, index) =>
		{
			if (item == colorListItem)
				sender.AnimationType = (MenuAnimationType)index;
		};
		exampleMenu.OnMenuStateChanged += (oldMenu, newMenu, state) =>
		{
			if (state == MenuState.Opened)
			{
				Screen.ShowSubtitle($"{newMenu.Title} just opened!", 3000);
				Debug.WriteLine($"{newMenu.Title} just opened!");
			}
			else if (state == MenuState.ChangeForward)
			{
				Screen.ShowSubtitle($"{oldMenu.Title} => {newMenu.Title}", 3000);
				Debug.WriteLine($"{oldMenu.Title} => {newMenu.Title}");
			}
			else if (state == MenuState.ChangeBackward)
			{
				Screen.ShowSubtitle($"{newMenu.Title} <= {oldMenu.Title}", 3000);
				Debug.WriteLine($"{newMenu.Title} <= {oldMenu.Title}");
			}
			else if (state == MenuState.Closed)
			{
				Screen.ShowSubtitle($"{oldMenu.Title} just closed!", 3000);
				Debug.WriteLine($"{oldMenu.Title} just closed!");
			}
		};

		#endregion

		exampleMenu.Visible = true;
	}

	private int _timer = 0;
	private string _text = string.Empty;
	public async Task Text3DTimer()
	{
		Notifications.DrawText3D(_text, Game.PlayerPed.Bones[Bone.SKEL_Head].Position + new Vector3(0, 0, 0.5f), Colors.WhiteSmoke);
		if (Game.GameTime - _timer > 5000) // this is a tricky yet simple way to count time without using Delay and pausing the Thread ;)
			Tick -= Text3DTimer;
		await Task.FromResult(0);
	}
	public async Task TextTimer()
	{
		Notifications.DrawText(0.35f, 0.7f, _text);
		if (Game.GameTime - _timer > 5000) // this is a tricky yet simple way to count time without using Delay and pausing the Thread ;)
			Tick -= TextTimer;
		await Task.FromResult(0);
	}
	public async Task FloatingHelpTimer()
	{
		Notifications.ShowFloatingHelpNotification(_text, Game.PlayerPed.Bones[Bone.SKEL_Head].Position + new Vector3(0, 0, 0.5f), 5000);
		// this will show the 3d notification on the head of the ped in 3d world coords
		if (Game.GameTime - _timer > 5000) // this is a tricky yet simple way to count time without using Delay and pausing the Thread ;)
			Tick -= FloatingHelpTimer;
		await Task.FromResult(0);
	}

	public async void PauseMenuShowcase(UIMenu _menu)
    {
		var mainMenu = _menu;
		// tabview is the main menu.. the container of all the tabs.
		TabView pauseMenu = new TabView("PauseMenu example", "Look there's a subtitle too!", "Detail 1", "Detail 2", "Detail 3");
		var mugshot = API.RegisterPedheadshot(Game.PlayerPed.Handle);
		while (!API.IsPedheadshotReady(mugshot)) await BaseScript.Delay(1);
		var txd = API.GetPedheadshotTxdString(mugshot);
		pauseMenu.HeaderPicture = new(txd, txd);
		_menuPool.Add(pauseMenu);
		TabTextItem basicTab = new TabTextItem("TabTextItem", "This is the title!");
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~b~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~g~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		basicTab.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~r~Use the mouse wheel to scroll the text!!"));
		pauseMenu.AddTab(basicTab);

		TabSubmenuItem multiItemTab = new TabSubmenuItem("TabSubMenu");
		pauseMenu.AddTab(multiItemTab);
		TabLeftItem first = new TabLeftItem("1 - Empty", LeftItemType.Empty);
		TabLeftItem second = new TabLeftItem("2 - Info", LeftItemType.Info);
		TabLeftItem third = new TabLeftItem("3 - Statistics", LeftItemType.Statistics);
		TabLeftItem fourth = new TabLeftItem("4 - Settings", LeftItemType.Settings);
		TabLeftItem fifth = new TabLeftItem("5 - Keymaps", LeftItemType.Keymap);
		multiItemTab.AddLeftItem(first);
		multiItemTab.AddLeftItem(second);
		multiItemTab.AddLeftItem(third);
		multiItemTab.AddLeftItem(fourth);
		multiItemTab.AddLeftItem(fifth);

		second.TextTitle = "Info Title!!";
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~b~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~g~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"));
		second.AddItem(new BasicTabItem("~BLIP_INFO_ICON~ ~r~Use the mouse wheel to scroll the text!!"));

		StatsTabItem _labelStatItem = new StatsTabItem("Item's Label", "Item's right label");
		StatsTabItem _coloredBarStatItem0 = new StatsTabItem("Item's Label", 0, HudColor.HUD_COLOUR_ORANGE);
		StatsTabItem _coloredBarStatItem1 = new StatsTabItem("Item's Label", 25, HudColor.HUD_COLOUR_RED);
		StatsTabItem _coloredBarStatItem2 = new StatsTabItem("Item's Label", 50, HudColor.HUD_COLOUR_BLUE);
		StatsTabItem _coloredBarStatItem3 = new StatsTabItem("Item's Label", 75, HudColor.HUD_COLOUR_GREEN);
		StatsTabItem _coloredBarStatItem4 = new StatsTabItem("Item's Label", 100, HudColor.HUD_COLOUR_PURPLE);

		third.AddItem(_labelStatItem);
		third.AddItem(_coloredBarStatItem0);
		third.AddItem(_coloredBarStatItem1);
		third.AddItem(_coloredBarStatItem2);
		third.AddItem(_coloredBarStatItem3);
		third.AddItem(_coloredBarStatItem4);

		List<dynamic> itemList = new List<dynamic>() { "This", "Is", "The", "List", "Super", "Power", "Wooow" };
		SettingsItem _settings1 = new SettingsItem("Item's Label", "Item's right Label");
		SettingsItem _settings2 = new SettingsListItem("Item's Label", itemList, 0);
		SettingsItem _settings3 = new SettingsProgressItem("Item's Label", 100, 25, false, HudColor.HUD_COLOUR_FREEMODE);
		SettingsItem _settings4 = new SettingsProgressItem("Item's Label", 100, 75, true, HudColor.HUD_COLOUR_PINK);
		SettingsItem _settings5 = new SettingsCheckboxItem("Item's Label", UIMenuCheckboxStyle.Tick, true);
		SettingsItem _settings6 = new SettingsSliderItem("Item's Label", 100, 50, HudColor.HUD_COLOUR_RED);
		fourth.AddItem(_settings1);
		fourth.AddItem(_settings2);
		fourth.AddItem(_settings3);
		fourth.AddItem(_settings4);
		fourth.AddItem(_settings5);
		fourth.AddItem(_settings6);

		fifth.TextTitle = "ACTION";
		fifth.KeymapRightLabel_1 = "PRIMARY";
		fifth.KeymapRightLabel_2 = "SECONDARY";
		KeymapItem key1 = new KeymapItem("Simple Keymap", "~INPUT_FRONTEND_ACCEPT~", "~INPUT_VEH_EXIT~");
		KeymapItem key2 = new KeymapItem("Advanced Keymap", "~INPUT_SPRINT~ + ~INPUT_CONTEXT~", "", "", "~INPUTGROUP_FRONTEND_TRIGGERS~");
		fifth.AddItem(key1);
		fifth.AddItem(key2);
		fifth.AddItem(key1);
		fifth.AddItem(key2);
		fifth.AddItem(key1);
		fifth.AddItem(key2);
		fifth.AddItem(key1);
		fifth.AddItem(key2);

		pauseMenu.OnPauseMenuOpen += (menu) =>
		{
			Screen.ShowSubtitle(menu.Title + " Opened!");
			if (mainMenu != null)
				mainMenu.Visible = false;
		};
		pauseMenu.OnPauseMenuClose += async (menu) =>
		{
			Screen.ShowSubtitle(menu.Title + " Closed!");
			// to prevent the pause menu to close the menu too!
			await BaseScript.Delay(250);
			if (mainMenu != null)
				mainMenu.Visible = true;
		};

		pauseMenu.OnPauseMenuTabChanged += (menu, tab, tabIndex) =>
		{
			Screen.ShowSubtitle(tab.Title + " Selected!");
		};

		pauseMenu.OnPauseMenuFocusChanged += (menu, tab, focusLevel) =>
		{
			Screen.ShowSubtitle(tab.Title + " Focus at level => ~y~"+ focusLevel +"~w~!");
			if(focusLevel == 1)
            {
				if(tab is TabTextItem)
                {
					List<InstructionalButton> buttons = new List<InstructionalButton>()
					{
						new InstructionalButton(Control.PhoneCancel, Game.GetGXTEntry("HUD_INPUT3")),
						new InstructionalButton(Control.LookUpDown, "Scroll text", PadCheck.Controller),
						new InstructionalButton(InputGroup.INPUTGROUP_CURSOR_SCROLL, "Scroll text", PadCheck.Keyboard)
					
					};

                    ScaleformUI.ScaleformUI.InstructionalButtons.SetInstructionalButtons(buttons);
                }
            }
			else if (focusLevel == 0)
				ScaleformUI.ScaleformUI.InstructionalButtons.SetInstructionalButtons(menu.InstructionalButtons);

		};

		pauseMenu.OnLeftItemChange += (menu, tabIndex, focusLevel, leftItemIndex) =>
		{
			Screen.ShowSubtitle(menu.Tabs[tabIndex].Title + " Focus at level => ~y~" + focusLevel + "~w~, and left Item ~o~N° " + (leftItemIndex + 1) + "~w~ selected!");
		};
	
		pauseMenu.OnLeftItemSelect += (menu, tabIndex, focusLevel, leftItemIndex) =>
		{
			Screen.ShowSubtitle(menu.Tabs[tabIndex].Title + " Focus at level => ~y~" + focusLevel + "~w~, and left Item ~o~N° " + (leftItemIndex + 1) + "~w~ selected!");
		};

		pauseMenu.OnRightItemChange += (menu, tabIndex, focusLevel, leftItemIndex, rightItemIndex) =>
		{
			Screen.ShowSubtitle(menu.Tabs[tabIndex].Title + " Focus at level => ~y~" + focusLevel + "~w~, left Item ~o~N° " + (leftItemIndex + 1) + "~w~ and right Item ~b~N° " + (rightItemIndex+1) + "~w~ selected!");
		};
		pauseMenu.Visible = true;
		API.UnregisterPedheadshot(mugshot);
	}

	public MenuExample()
	{
		_menuPool = new MenuPool();
		_menuPool.RefreshIndex();

		// We create a marker on the peds position, adds it to the MarkerHandler
		Marker playerMarker = new Marker(MarkerType.VerticalCylinder, Game.PlayerPed.Position, new Vector3(1.5f), 5f, Colors.Cyan, true);
		MarkersHandler.AddMarker(playerMarker);

		Tick += async () =>
		{
			_menuPool.ProcessMenus();

			//If the player is in drawing range for the marker, the marker will draw automatically and the DrawText will show itself (true if the ped enters the marker)
			if(playerMarker.IsInRange)
				Notifications.DrawText($"IsInMarker => {playerMarker.IsInMarker}");

			if (Game.IsControlJustPressed(0, Control.SelectCharacterMichael) && !_menuPool.IsAnyMenuOpen) // Our menu enabler (to exit menu simply press Back on the main menu)
				ExampleMenu();

			// to open the pause menu without opening the normal menu.
			if (Game.IsControlJustPressed(0, Control.SelectCharacterFranklin) && !_menuPool.IsAnyMenuOpen && !_menuPool.IsAnyPauseMenuOpen)
				PauseMenuShowcase(null);
			await Task.FromResult(0);
		};
	}
}
