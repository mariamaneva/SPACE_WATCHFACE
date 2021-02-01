using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

using Toybox.Activity;
using Toybox.ActivityMonitor;

using Toybox.Sensor;

using Toybox.Time;
using Toybox.Time.Gregorian;


class SpaceWatchfaceView extends WatchUi.WatchFace {
    var background;
    var font_clock;
    var font_date;
    var font_metrics;
    var font_batt;
    var font_icons;
    var highlghtColors;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        // load background
        background = WatchUi.loadResource(Rez.Drawables.Background);
        // load fonts
        font_clock = WatchUi.loadResource(Rez.Fonts.font_clock);
        font_date = WatchUi.loadResource(Rez.Fonts.font_date);
        font_metrics = WatchUi.loadResource(Rez.Fonts.font_metrics);
        font_batt = WatchUi.loadResource(Rez.Fonts.font_batt);
        font_icons = WatchUi.loadResource(Rez.Fonts.font_icons);
        
        highlghtColors = [dc.COLOR_BLUE, dc.COLOR_YELLOW, dc.COLOR_PINK, dc.COLOR_PURPLE, dc.COLOR_GREEN, dc.COLOR_ORANGE];
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        var app = Application;
        var width = dc.getWidth();
        var height = dc.getHeight();

        // get highlight color from settings
        var selectedColorKey = Application.Properties.getValue("Color");
        var hightlightColor = highlghtColors[selectedColorKey];
        // var hightlightColor = dc.COLOR_BLUE;
        var defaultColor = dc.COLOR_WHITE;
        var seconaryColor = dc.COLOR_LT_GRAY;
        var transparent = dc.COLOR_TRANSPARENT;

        // ENABLE ANTI-ALIAS IF EXISTS
        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        // RESET LAYOUT BEFORE DRAWING
        dc.setColor(dc.COLOR_BLACK, dc.COLOR_BLACK);
        dc.clear();

        // DRAW THE BACKGROUND
        dc.drawBitmap(0,0, background);

        // MOUNTAIN
        // dc.setColor(dc.COLOR_DK_GRAY, transparent);
        // dc.fillPolygon([[0, 264], [55, 226], [106, 240], [152, 220], [200, 236], [248, 200], [width, 220], [width, height], [0, height]]);

        // SHOW DATE
        var now = Time.now();
        var days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
        if (now != null) {
            var fullDate = Gregorian.info(now, Time.FORMAT_SHORT);
            var dateString = days[fullDate.day_of_week-1] + "  " + fullDate.day;

            dc.setColor(defaultColor, transparent);
            dc.drawText(width/2, 30 , font_date, dateString , dc.TEXT_JUSTIFY_CENTER);
        }

        // SHOW THE CURRENT TIME
        var clockRowY = 65;
        var clockTime = System.getClockTime();

        dc.setColor(defaultColor, transparent);
        dc.drawText((width/2)-10, clockRowY, font_clock, Lang.format("$1$",[clockTime.hour.format("%02d")]), dc.TEXT_JUSTIFY_RIGHT);
        
        dc.setColor(hightlightColor, transparent);

        dc.drawText(width/2, clockRowY, font_clock, ":", dc.TEXT_JUSTIFY_CENTER);
        dc.drawText((width/2)+10, clockRowY, font_clock, Lang.format("$1$", [clockTime.min.format("%02d")]), dc.TEXT_JUSTIFY_LEFT);

        // SHOWING BODY METRICS
        var firstRowY = 155;
        var firstRowOffset = 25;
        var firstRowOffsetRight = 75;
        var secondRowY = 195;
        var secondRowOffset = 40;
        var secondRowOffsetRight = 85;

        var HR = "--";
        var STEPS = "--";
        var FLOORS = "--";
        var CALORIES = "--";
        var ACTIVE_MINS = "--";

        var bodyData = Activity.getActivityInfo();
        var activityData = ActivityMonitor.getInfo();


        if (activityData != null) {
            if (activityData.steps != null) {
                STEPS = activityData.steps;
            }
            if (activityData.floorsClimbed != null) {
                FLOORS = activityData.floorsClimbed;
            }
            if (activityData.calories != null) {
                CALORIES = activityData.calories;
            }
            if (activityData.activeMinutesDay != null) {
                ACTIVE_MINS = activityData.activeMinutesDay.total;
            }
        }

        if (bodyData != null) {
            if (bodyData.currentHeartRate != null) {
                HR = bodyData.currentHeartRate;
            }
        }
        
        // icon code:
        // steps: "f",
        // floors: "a",
        // calories: "c",
        // heart: "g",
        // activity: "d",

        // draw steps
        dc.setColor(hightlightColor, transparent);
        dc.drawText(firstRowOffset, firstRowY, font_icons, "f", dc.TEXT_JUSTIFY_LEFT);
        dc.setColor(defaultColor, transparent);
        dc.drawText(firstRowOffset + 27, firstRowY, font_metrics, STEPS, dc.TEXT_JUSTIFY_LEFT);

        // draw floors
        dc.setColor(hightlightColor, transparent);
        dc.drawText((width-firstRowOffsetRight), firstRowY, font_icons, "a", dc.TEXT_JUSTIFY_LEFT);
        dc.setColor(defaultColor, transparent);
        dc.drawText((width-firstRowOffsetRight) + 25, firstRowY, font_metrics, FLOORS, dc.TEXT_JUSTIFY_LEFT);

        // draw calories
        dc.setColor(hightlightColor, transparent);
        dc.drawText(secondRowOffset, secondRowY, font_icons, "c", dc.TEXT_JUSTIFY_LEFT);
        dc.setColor(defaultColor, transparent);
        dc.drawText(secondRowOffset + 25, secondRowY, font_metrics, CALORIES, dc.TEXT_JUSTIFY_LEFT);
        
        // draw hr
        dc.setColor(hightlightColor, transparent);
        dc.drawText((width/2)-23, secondRowY, font_icons, "g", dc.TEXT_JUSTIFY_LEFT);
        dc.setColor(defaultColor, transparent);
        dc.drawText((width/2) + 5, secondRowY, font_metrics, HR, dc.TEXT_JUSTIFY_LEFT);


        // draw active mins
        dc.setColor(hightlightColor, transparent);
        dc.drawText((width-secondRowOffsetRight), secondRowY, font_icons, "d", dc.TEXT_JUSTIFY_LEFT);
        dc.setColor(defaultColor, transparent);
        dc.drawText((width-secondRowOffsetRight) + 23, secondRowY, font_metrics, ACTIVE_MINS, dc.TEXT_JUSTIFY_LEFT);

        
        // SHOW BATERRY
        var systemData = System.getSystemStats();

        if (systemData) {
            var batteryStatus = systemData.battery;
            var batStr = "batt " + batteryStatus.format("%d") + "%";

            dc.setColor(seconaryColor, transparent);
            dc.drawText(width/2, 240, font_batt, batStr, dc.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
