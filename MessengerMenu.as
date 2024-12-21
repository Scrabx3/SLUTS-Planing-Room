import gfx.io.GameDelegate;
import gfx.utils.Delegate;
import Shared.GlobalFunc;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;
import gfx.managers.FocusHandler;

import skyui.components.list.ListLayoutManager;
import skyui.components.list.TabularList;
import skyui.components.list.ListLayout;
import skyui.props.PropertyDataExtender;

import skyui.defines.Input;
import skyui.defines.Inventory;
import skyui.util.GlobalFunctions;
import skyui.util.Translator;
import skyui.components.ButtonPanel;

import com.greensock.*;
import com.greensock.easing.*;

class MessengerMenu extends MovieClip
{
	public static var OPTION_NONE = -1;
	public static var OPTION_RANDOM = 0;
	private static var _CSPECIAL = 0xD92F2F;

	/* STAGE */

	public var menu: OptionList;
	public var loadingWidget: MovieClip;
	public var background: MovieClip;

  /* PRIVATE VARIABLES */

	private var _addonCount;
	private var _options;

	// Build Menu

	public function setSuboptions(/* Sub Options */)
	{
		// name, type
		var subOptions = new Array();
		for (var i = 0; i < arguments.length; i++) {
			var objStrings = arguments[i].split(",");
			var subOption = {
				name: objStrings[0],
				type: objStrings[1]
			};
			subOptions.push(subOption);
		}
		menu.setSuboptionItems(subOptions);
	}

	public function openMenu(/* Options */)
	{
		// name, id, location, hold, id, enabled, type1/type2/...
		var options = new Array();
		for (var i = 0; i < arguments.length; i++) {
			var objStrings = arguments[i].split(",");
			var option = {
				name: objStrings[0],
				id: objStrings[1],
				location: objStrings[2],
				hold: objStrings[3],
				enabled: objStrings[4],
				types: objStrings[5].split("/")
			};
			options.push(option);
		}
		menu.setItems(options);
		loadingWidget._visible = false;
		TweenLite.to(menu, 1.0, {_alpha: 100});
	}

  /* INITIALIZATION */

	public function MessengerMenu()
	{
		super();
		Mouse.addListener(this);
		FocusHandler.instance.setFocus(this, 0);
		_global.gfxExtensions = true;
	}

	public function onLoad(): Void
	{
		var minXY: Object = {x: Stage.visibleRect.x + Stage.safeRect.x, y: Stage.visibleRect.y + Stage.safeRect.y};
    var maxXY: Object = {x: Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x, y: Stage.visibleRect.y + Stage.visibleRect.height - Stage.safeRect.y};

    //  (minXY.x, minXY.y) _____________ (maxXY.x, minXY.y)
    //                    |             |
    //                    |     THE     |
    //                    |    STAGE    |
    //  (minXY.x, maxXY.y)|_____________|(maxXY.x, maxXY.y)

		globalToLocal(minXY);
		globalToLocal(maxXY);
		trace("Stage: " + minXY.x + ", " + minXY.y + " - " + maxXY.x + ", " + maxXY.y);

		background._x = (minXY.x + maxXY.x) / 2;
		background._y = (minXY.y + maxXY.y) / 2;
		background._width = maxXY.x - minXY.x;
		background._height = maxXY.y - minXY.y;
		
		var stageMidY = (minXY.y + maxXY.y) / 2;
		var stageHeight = maxXY.y - minXY.y;
		menu._x = (minXY.x + maxXY.x) / 2;
		menu._y = stageMidY - stageMidY * 0.1;
		menu._height = stageHeight * 0.7;
		menu._width = menu._height * 1.76;

		// menu.addEventListener("closeMenu", this, "onCloseMenu");

		// setTimeout(Delegate.create(this, test), 1000);
	}

	private function test() {
		var subOpts = [
			"Option1,TypeA",
			"Option2,TypeB",
			"Option3,TypeC"
		];
		setSuboptions.apply(this, subOpts);
		
		var opts = [
			"Option1,Loc 1,Hold1,1,true,TypeA/TypeB",
			"Option2,Loc 2,Hold2,2,true,TypeB/TypeC",
			"Option3,Loc 3,Hold3,3,true,TypeC"
		];
		openMenu.apply(this, opts);
	}

  /* PUBLIC FUNCTIONS */
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (fadedOut())
			return;

		var nextClip = pathToFocus.shift();
		if (nextClip.handleInput(details, pathToFocus))
			return true;

		if (GlobalFunc.IsKeyPressed(details)) {
			switch (details.navEquivalent) {
				case NavigationCode.TAB:
				case NavigationCode.SHIFT_TAB:
				case NavigationCode.ESCAPE:
					closeMenu();
					break;
			}
		}
		return true;
	}

	public function closeMenu() {
		// TODO: Implement this
		var list = menu.mainOptions.entryList;
		for (var i = 0; i < list.length; i++) {
			var it = list[i];
			var argStr = it.types.join("/");
			trace("Sending Event with " + it.name + " / " + it.id + " / " + argStr);
			skse.Log("[Sluts] Updating Types for Actor: " + it.id + " -> " + argStr);
			skse.SendModEvent("SLUTS_UpdateTypes", argStr, it.id);
		}
		TweenLite.to(this, 0.6, {_alpha: 0, onComplete: skse.CloseMenu, onCompleteParams: ["CustomMenu"]});
	}

  /* PRIVATE FUNCTIONS */

	private function fadedOut()
	{
		return menu._alpha < 10;
	}

}
