using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;


const COLOR_ITEMS_TO_STRING  = [
    Rez.Strings.ColorBlue,
    Rez.Strings.ColorYellow,
    Rez.Strings.ColorPink,
    Rez.Strings.ColorPurple,
    Rez.Strings.ColorGreen,
    Rez.Strings.ColorOrange,
];


/**
 * Implements the top-level settings menu and acts as its input delegate.
 */
class SettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({
            :title => loadResource(Rez.Strings.SettingsMenuTitle)
        });

        // Color theme
        for (var i = 0; i < 6; i++) {
            addItem( new WatchUi.MenuItem(
            COLOR_ITEMS_TO_STRING[i],
            null,
            :i,
            {}));
        }
    }
        
    // Update the subtitles of our buttons.
    public function onShow() {

    }
    
}

/**
 * Handles menu item selections in SettingsMenu.
 */
class SettingsMenuInputDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    function closeMenu() {
        // Ensure that the watchface reloads any settings that have been changed
        Application.getApp().onSettingsChanged();
        
        // We're done here!
        popView(WatchUi.SLIDE_RIGHT);
    }
    
    public function onSelect(item) {
        var itemLabel = item.getLabel().toString();

        for (var i = 0; i < 6; i++) {
            var rezLabel = WatchUi.loadResource(COLOR_ITEMS_TO_STRING[i]).toString();
            if (rezLabel.equals(itemLabel)) {
                Application.Properties.setValue("Color", i);
            }
        }
        closeMenu();
    }
    
    public function onBack() {
        closeMenu();
    }
    public function onHide() {
        closeMenu();
    }
    
}


