import Shared.GlobalFunc;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;

import skyui.defines.Input;
import skyui.util.ConfigLoader;
import skyui.util.GlobalFunctions;
import skyui.components.list.ListLayout;
import skyui.components.list.SortedListHeader;
import skyui.components.list.ScrollingList;
import skyui.filter.IFilter;
import skyui.util.ConfigManager;


class SubList extends skyui.components.list.ScrollingList
{
	/* VARIABLES */

	public var activeTypes:Array;

	public var _highLightColor;
	public var _selectDisable;

	/* INITIALIZATION */

	public function SubList()
	{
		super();
    activeTypes = new Array();
		_selectDisable = false;
	}

	// public functions

	public function setHighlightColor(color)
	{
		_highLightColor = color;
	}

	public function updateEnabledStatus(enabledTypes:Array)
	{
    activeTypes = enabledTypes;
		InvalidateData();
	}

	// @Override ScrollingList
	public function InvalidateData()
	{
		super.InvalidateData();

		doSetSelectedIndex(-1,SELECT_MOUSE);
	}

}