using Toybox.Application;
using Toybox.WatchUi;

class SpaceWatchfaceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new SpaceWatchfaceView() ];
    }

    // Returns a view that allows for changing the watch settings
    function getSettingsView() {
        return [ new SettingsMenu(), new SettingsMenuInputDelegate() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        WatchUi.requestUpdate();
    }

}