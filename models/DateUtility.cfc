component singleton {

    /**
    * Helpful for running reports by quarter.
    * The return is like {start: "2018-01-01", end: "2018-03-31"}
    */
    public struct function getDatesByQuarter(numeric quarter=0, numeric year=0) {

        var _quarter = arguments.quarter;
        var _year = year(now());
        var result = {};

        if (_quarter < 1 || _quarter > 4) {
            throw(type="InvalidArgumentException", message="The valid range for a quarter is between 1 and 4.");
        }

        if (arguments.year != 0) {
            _year = arguments.year;
        }
        if (_year < 1900 || _year > 2200) {
            throw(type="InvalidArgumentException",message="The valid range for a year is between 1900 and 2200.");
        }

        if (_quarter == 1) {
            result.start = createDate(_year, 1, 1);
        } else if (_quarter == 2) {
            result.start = createDate(_year, 4, 1);
        } else if (_quarter == 3) {
            result.start = createDate(_year, 7, 1);
        } else if (_quarter == 4) {
            result.start = createDate(_year, 10, 1);
        }
        result.end = dateAdd("d", -1, dateAdd("m", 3, result.start));
        return result;
    }

    /**
    * Helpful for stepping forward/back through quarters.
    * The return is like {start: "2018-01-01", end: "2018-03-31"}
    * @name Either "this" (default), "previous", or "next"
    * @date An arbitrary CFML date may be specified to adjust calendar position
    */
    public struct function getDatesByQuarterName(string name="this", date date) {
        var _date = now();
        var cq = 0;
        var cy = 0;
        var q = 0;
        var y = 0;

        if (structKeyExists(arguments, "date") && isDate(arguments.date)) {
            _date = arguments.date;
        }

        cq = getQuarterByDate(_date);
        cy = year(_date);

        if (arguments.name == "previous") {
            if (cq == 1) {
                q = 4;
                y = cy - 1;
            } else {
                q = cq - 1;
                y = cy;
            }
        } else if (arguments.name == "this") {
            q = cq;
            y = cy;
        } else if (arguments.name == "next") {
            if (cq == 4) {
                q = 1;
                y = cy + 1;
            } else {
                q = cq + 1;
                y = cy;
            }
        } else {
            throw(type="InvalidArgumentException", message="The named quarter '#arguments.name#' is not supported.");
        }
        return getDatesByQuarter(q, y);
    }

    public numeric function getQuarterByDate(any date="") {
        var _date = now();

        if (isDate(arguments.date)) {
            _date = arguments.date;
        } else if (arguments.date != "") {
            try {
                _date = lsParseDateTime(arguments.date);
            } catch (any e) {
                throw(type="InvalidArgumentException", message="The date '#_date#' could not be parsed in the current locale.");
            }
        }
        return ceiling(month(_date) / 3);
    }


    /**
     * By default, we'll say that the start of the week is Monday.
     */
    public date function getWeekStartDate(any date="", numeric weekStartsOn=2) {
        var input = {};

        if (isDate(arguments.date)) {
            input.date = arguments.date;
        } else {
            input.date = now();
        }
        input.dayOfWeek = dayOfWeek(input.date);

        if (input.dayOfWeek == arguments.weekStartsOn) {
            return input.date;
        } else if (input.dayOfWeek < arguments.weekStartsOn) {
            return dateAdd("d", arguments.weekStartsOn - input.dayOfWeek - 6, input.date);
        } else {
            return dateAdd("d", arguments.weekStartsOn - input.dayOfWeek, input.date);
        }
    }

    /**
    * Simply get the last day of the month that contains the date specified.
    */
    public date function getEndOfMonth(required date date) {
        var firstOfThisMonth = createDate(year(arguments.date), month(arguments.date), 1);
        var firstOfNextMonth = dateAdd("m", 1, firstOfThisMonth);

        return dateAdd("d", -1, firstOfNextMonth);
    }

    public array function getDateParts(required date date) {
        var result = arrayNew(1);

        arrayAppend(result, year(arguments.date));
        arrayAppend(result, month(arguments.date));
        arrayAppend(result, day(arguments.date));
        arrayAppend(result, hour(arguments.date));
        arrayAppend(result, minute(arguments.date));
        arrayAppend(result, second(arguments.date));
        return result;
    }

    /**
    * This will definitely throw an exception if the caller specifies an unparsable date string or an invalid time zone.
    * @datetime The pattern expected is like "2018-03-11 02:30:00"
    * @timezone Any valid Java 8 time zone identifier
    */
    public numeric function getEpochSecondsUsingPattern(required string datetime, string timezone="America/Los_Angeles") {
        var zoneId = createObject("java", "java.time.ZoneId").of(arguments.timezone);
        var dtf = createObject("java", "java.time.format.DateTimeFormatter").ofPattern("uuuu-MM-dd HH:mm:ss");
        var dlt = createObject("java", "java.time.LocalDateTime").parse(massageDatetime(arguments.datetime), dtf);
        var zdt = dlt.atZone(zoneId);
        var s = 0;

        try {
            s = zdt.toEpochSecond();
        } catch (any e) {
            var cf = createObject("java", "java.time.temporal.ChronoField");
            s = zdt.getLong(cf.INSTANT_SECONDS);
        }
        return s;
    }

    /**
    * This will definitely throw an exception if the caller specifies an unparsable date string or an invalid time zone.
    * @datetime The pattern expected is like "2018-03-11 02:30:00.123"
    * @timezone Any valid Java 8 time zone identifier
    */
    public numeric function getEpochMillisUsingPattern(required string datetime, string timezone="America/Los_Angeles") {
        var zoneId = createObject("java", "java.time.ZoneId").of(arguments.timezone);
        var dtf = createObject("java", "java.time.format.DateTimeFormatter").ofPattern("uuuu-MM-dd HH:mm:ss.SSS");
        var dlt = createObject("java", "java.time.LocalDateTime").parse(massageDatetime(arguments.datetime), dtf);
        var zdt = dlt.atZone(zoneId);
        var ms = 0;

        try {
            ms = zdt.toInstant().toEpochMilli();
        } catch (any e) {
            var cf = createObject("java", "java.time.temporal.ChronoField");
            ms = (zdt.getLong(cf.INSTANT_SECONDS) * 1000) + zdt.getLong(cf.MILLI_OF_SECOND);
        }
        return ms;
    }

    /**
    * Conveniently fetch the number of seconds since the Epoch using the least complicated Java source
    */
    public numeric function getCurrentEpochSeconds() {
        return ceiling(createObject("java", "java.lang.System").currentTimeMillis() / 1000);
    }

    /**
    * Conveniently fetch the number of milliseconds since the Epoch using the least complicated Java source
    */
    public numeric function getCurrentEpochMillis() {
        return createObject("java", "java.lang.System").currentTimeMillis();
    }

    /**
    * Returns a Java 8 Instant for the given datetime pattern with a UTC offset
    * @datetime A datetime pattern like "2018-07-04 12:34:56 -04:00" or "2018-04-01 12:34:56.789 -08:00"
    */
    public any function getInstantFromOffsetDatetime(required string datetime) {
        if (reFind("^[-0-9]{10} [:0-9]{8}\.[0-9]{3} -[:0-9]{5}$", arguments.datetime)) {
            var dtf = createObject("java", "java.time.format.DateTimeFormatter").ofPattern("uuuu-MM-dd HH:mm:ss.SSS ZZZZZ");
        } else if (reFind("^[-0-9]{10} [:0-9]{8} -[:0-9]{5}$", arguments.datetime)) {
            var dtf = createObject("java", "java.time.format.DateTimeFormatter").ofPattern("uuuu-MM-dd HH:mm:ss ZZZZZ");
        } else {
            throw(type="InvalidArgumentException", message="Invalid datetime string. '#arguments.datetime#' does not match a known format.");
        }
        var odt = createObject("java", "java.time.OffsetDateTime").parse(arguments.datetime, dtf);
        return odt.toInstant();
    }

    /**
    * Returns the current Instant, to the best of our ability
    */
    public any function getCurrentInstant() {
        return createObject("java", "java.time.Instant").now();
    }

    /**
    * Returns an instance of java.time.Instant, which is a tall order for poor ol' Adobe ColdFusion
    * @seconds The number of seconds since the Epoch
    */
    public any function getInstantFromEpochSeconds(required numeric seconds) {
        return createObject("java", "java.time.Instant").ofEpochSecond(arguments.seconds);
    }

    /**
    * Returns an instance of java.time.Instant, which is a tall order for poor ol' Adobe ColdFusion
    * @millis The number of millis since the Epoch
    */
    public any function getInstantFromEpochMillis(required numeric millis) {
        return createObject("java", "java.time.Instant").ofEpochMilli(arguments.millis);
    }

    /**
    * Returns the desired DateTimeFormatter
    * @pattern The datetime formatting string
    */
    public any function getDatetimeFormatter(required string pattern) {
        return createObject("java", "java.time.format.DateTimeFormatter").ofPattern(arguments.pattern);
    }

    /**
    * This is just a developer convenience to reduce the steps required to format a datetime and simplify the most typically used options
    * @seconds The number of seconds since the Epoch
    * @timezone Any valid Java 8 time zone identifier
    * @pattern A named pattern or a valid DateTimeFormatter expression
    */
    public string function formatEpochSeconds(required numeric seconds, string timezone="America/Los_Angeles", string pattern="US_DATE") {
        return formatInstant(getInstantFromEpochSeconds(arguments.seconds), arguments.timezone, arguments.pattern);
    }

    /**
    * This is just a developer convenience to reduce the steps required to format a datetime and simplify the most typically used options
    * @millis The number of milliseconds since the Epoch
    * @timezone Any valid Java 8 time zone identifier
    * @pattern A named pattern or a valid DateTimeFormatter expression
    */
    public string function formatEpochMillis(required numeric millis, string timezone="America/Los_Angeles", string pattern="US_DATE") {
        return formatInstant(getInstantFromEpochMillis(arguments.millis), arguments.timezone, arguments.pattern);
    }

    /**
    * This is mostly used internally, but external callers are welcome to use it if they have an Instant reference.
    * @instant An instance of Instant to be formatted
    * @timezone Any valid Java 8 time zone identifier
    * @pattern A named pattern or a valid DateTimeFormatter expression
    */
    public string function formatInstant(required any instant, required string timezone, required string pattern) {
        var dtfs = getDatetimeFormats();
        var zoneId = createObject("java", "java.time.ZoneId").of(arguments.timezone);

        if (structKeyExists(dtfs, arguments.pattern)) {
            return arguments.instant.atZone(zoneId).format(getDatetimeFormatter(dtfs[arguments.pattern]));
        }
        return arguments.instant.atZone(zoneId).format(getDatetimeFormatter(arguments.pattern));
    }


    private string function massageDatetime(required string datetime) {
        return reReplaceNoCase(arguments.datetime, "^([-0-9]+)(T| )([.:0-9]+).*$", "\1 \3");
    }

    private struct function getDatetimeFormats() {
        if (structKeyExists(variables, "datetimeFormats")) {
            return variables.datetimeFormats;
        }
        variables.datetimeFormats = {
            US_DATE: "MM/dd/uuuu",
            US_DATETIME: "MM/dd/uuuu h:mm:ss a",
            US_DATETIME_TZ: "MM/dd/uuuu h:mm:ss a z",
            ISO_8601: "uuuu-MM-dd'T'HH:mm:ss",
            ISO_8601_FRACTIONAL: "uuuu-MM-dd'T'HH:mm:ss.SSS",
            ISO_8601_ZULU: "uuuu-MM-dd'T'HH:mm:ss'Z'",
            ISO_8601_FRACTIONAL_ZULU: "uuuu-MM-dd'T'HH:mm:ss.SSS'Z'",
            MSSQL_DATETIME: "uuuu-MM-dd HH:mm:ss.SSS"
        };
        return variables.datetimeFormats;
    }

}