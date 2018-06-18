# Date Utility

This is a ColdBox Module to assist in dealing with dates, especially converting between timezones and formatting for data transfer.

## Requirements

- Lucee 5+ or Adobe ColdFusion 10+
- ColdBox 4.3+
- Java 8+

## Installation

Install using [CommandBox](https://www.ortussolutions.com/products/commandbox):
`box install date-utility`

## Usage

Get an instance of DateUtility from WireBox:
```
property name="dateutil" inject="dateUtility@DateUtility";
```

There are several examples in the test specification that might be helpful to browse.

### Conversions

If you have a date and know its timezone, you can get the seconds/milliseconds since the Epoch:
```
dateutil.getEpochSecondsUsingPattern("2018-03-11 01:30:00", "US/Pacific");
// Returns 1520760600

dateutil.getEpochMillisUsingPattern("2018-03-11 01:30:00.050", "US/Pacific");
// Returns 1520760600050
```

If you have the number of seconds/milliseconds since the Epoch, and you'd like to express it as an ISO 8601 string:
```
dateutil.formatEpochSeconds(1523830577, "UTC", "ISO_8601_ZULU");
// Returns "2018-04-15T22:16:17Z"

dateutil.formatEpochMillis(1523830577123, "UTC", "ISO_8601_FRACTIONAL_ZULU");
// Returns "2018-04-15T22:16:17.123Z"
```

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
