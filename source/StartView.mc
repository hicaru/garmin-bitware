//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

class MainView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        onUpdate(dc);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(
            dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM,
            "ENTER to start",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}


class MainViewDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onKey(event) {
        var key = event.getKey();
        System.print(key);
        // logf(DEBUG, "onKey $1$", [key]);
        // if (key == KEY_MENU || key == KEY_ENTER) {
        //   var provider = currentProvider();
        //   switch (provider) {
        //   case instanceof CounterBasedProvider:
        //     provider.next();
        //     WatchUi.requestUpdate();
        //     return true;
        //   }
        // } else if (key == KEY_DOWN || key == KEY_UP) {
        //   var delta = key == KEY_DOWN ? 1 : -1;
        //   _currentIndex += delta;
        //   if (_currentIndex < 0) {
        //     _currentIndex = _providers.size() - 1;
        //   } else if (_currentIndex >= _providers.size()) {
        //     _currentIndex = 0;
        //   }
        //   logf(DEBUG, "quick switch to index $1$", [_currentIndex]);
        //   saveProviders();
        //   WatchUi.requestUpdate();
        //   return true;
        // }
        // return BehaviorDelegate.onKey(event);
    }

    function onSelect() {
//     if (_providers.size() == 0) {
//       var view = new TextInput.TextInputView("Enter name", Alphabet.ALPHANUM);
//       WatchUi.pushView(view, new NameInputDelegate(view), WatchUi.SLIDE_RIGHT);
//     } else {
//       var menu = new Menu.MenuView({ :title => "OTP Authenticator" });
//       menu.addItem(new Menu.MenuItem("Select entry", null, :select_entry, null));
//       menu.addItem(new Menu.MenuItem("New entry", null, :new_entry, null));
//       menu.addItem(new Menu.MenuItem("Delete entry", null, :delete_entry, null));
//       menu.addItem(new Menu.MenuItem("Delete all entries", null, :delete_all, null));
//       menu.addItem(new Menu.MenuItem("Export", "to settings", :export_providers, null));
//       menu.addItem(new Menu.MenuItem("Import", "from settings", :import_providers, null));
//       WatchUi.pushView(menu, new MainMenuDelegate(), WatchUi.SLIDE_LEFT);
//     }
    }
}
