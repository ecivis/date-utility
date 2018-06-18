component extends="testbox.system.BaseSpec" {

    function run() {
        describe("The DateUtility component", function () {

            beforeEach(function () {
                var du = getMockBox().prepareMock(new models.DateUtility());

                variables.dateUtility = du;
            });

            it("should return the correct week start date", function () {
                expect(variables.dateUtility.getWeekStartDate(createDate(2014, 4, 15), 1)).toBe(createDate(2014, 4, 13));
                expect(variables.dateUtility.getWeekStartDate(createDate(2014, 4, 14), 2)).toBe(createDate(2014, 4, 14));
                expect(variables.dateUtility.getWeekStartDate(createDate(2014, 4, 17), 2)).toBe(createDate(2014, 4, 14));
                expect(variables.dateUtility.getWeekStartDate(createDate(2014, 4, 18), 4)).toBe(createDate(2014, 4, 16));
                expect(variables.dateUtility.getWeekStartDate(createDate(2014, 4, 16), 6)).toBe(createDate(2014, 4, 12));
            });

            it("should return correct values for quarters", function () {
                expect(variables.dateUtility.getQuarterByDate("1/15/1998")).toBe(1);
                expect(variables.dateUtility.getQuarterByDate("4/30/1945")).toBe(2);
                expect(variables.dateUtility.getQuarterByDate("7/4/1976")).toBe(3);
                expect(variables.dateUtility.getQuarterByDate("10/28/1971")).toBe(4);
                expect(variables.dateUtility.getQuarterByDate()).toBeBetween(1, 4, "The quarter in which today falls should be between 1 and 4.");
            });

            it("should return correct date ranges for each quarter", function () {
                var y = year(now());

                expect(variables.dateUtility.getDatesByQuarter(1)).toBe({start:createDate(y, 1, 1), end:createDate(y, 3, 31)});
                expect(variables.dateUtility.getDatesByQuarter(2)).toBe({start:createDate(y, 4, 1), end:createDate(y, 6, 30)});
                expect(variables.dateUtility.getDatesByQuarter(3)).toBe({start:createDate(y, 7, 1), end:createDate(y, 9, 30)});
                expect(variables.dateUtility.getDatesByQuarter(4)).toBe({start:createDate(y, 10, 1), end:createDate(y, 12, 31)});
            });

            it("should return correct date ranges for quarters by names", function () {
                var y = year(now());

                expect(variables.dateUtility.getDatesByQuarterName("previous", createDate(y, 2, 15))).toBe({start:createDate(y - 1, 10, 1), end:createDate(y - 1, 12, 31)});
                expect(variables.dateUtility.getDatesByQuarterName("previous", createDate(y, 5, 15))).toBe({start:createDate(y, 1, 1), end:createDate(y, 3, 31)});
                expect(variables.dateUtility.getDatesByQuarterName("this", createDate(y, 5, 15))).toBe({start:createDate(y, 4, 1), end:createDate(y, 6, 30)});
                expect(variables.dateUtility.getDatesByQuarterName("next", createDate(y, 12, 15))).toBe({start:createDate(y + 1, 1, 1), end:createDate(y + 1, 3, 31)});
                expect(variables.dateUtility.getDatesByQuarterName("next", createDate(y, 5, 15))).toBe({start:createDate(y, 7, 1), end:createDate(y, 9, 30)});
            });

            it("should return correct end of month dates", function () {
                expect(variables.dateUtility.getEndOfMonth(createDate(2015, 1, 1))).toBe(createDate(2015, 1, 31));
                expect(variables.dateUtility.getEndOfMonth(createDate(2015, 12, 31))).toBe(createDate(2015, 12, 31));
                expect(variables.dateUtility.getEndOfMonth(createDate(2012, 2, 2))).toBe(createDate(2012, 2, 29));
                expect(variables.dateUtility.getEndOfMonth(createDate(2013, 2, 2))).toBe(createDate(2013, 2, 28));
            });

            it("should convert a datetime from the specified time zone into the number of seconds since Epoch", function () {
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-03-11 01:30:00", "US/Pacific")).toBe(1520760600);
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-03-11 02:05:00", "US/Pacific")).toBe(1520762700); // Note how the gap is resolved
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-03-11 02:55:00", "US/Pacific")).toBe(1520765700);
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-03-11 03:30:00", "US/Pacific")).toBe(1520764200); // 0330 PDT is 2 hrs after 0030 PDT

                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-11-04 00:30:00", "US/Pacific")).toBe(1541316600);
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-11-04 01:05:00", "US/Pacific")).toBe(1541318700); // Note how the overlap is resolved
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-11-04 01:55:00", "US/Pacific")).toBe(1541321700);
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-11-04 02:30:00", "US/Pacific")).toBe(1541327400); // 0230 PST is 3 hrs after 0030 PDT
            });

            it("should convert a datetime from the specified time zone into the number of milliseconds since Epoch", function () {
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-03-11 01:30:00.001", "US/Pacific")).toBe(1520760600001);
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-03-11 02:05:00.001", "US/Pacific")).toBe(1520762700001);
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-03-11 02:55:00.001", "US/Pacific")).toBe(1520765700001);
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-03-11 03:30:00.001", "US/Pacific")).toBe(1520764200001);

                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-11-04 00:30:00.001", "US/Pacific")).toBe(1541316600001);
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-11-04 01:05:00.001", "US/Pacific")).toBe(1541318700001);
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-11-04 01:55:00.001", "US/Pacific")).toBe(1541321700001);
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-11-04 02:30:00.001", "US/Pacific")).toBe(1541327400001);
            });

            it("should be lenient with the format of input datetime", function () {
                expect(variables.dateUtility.getEpochSecondsUsingPattern("2018-04-15T15:16:17", "America/Los_Angeles")).toBe(1523830577);
                expect(variables.dateUtility.getEpochMillisUsingPattern("2018-04-15T15:16:17.123", "America/Tijuana")).toBe(1523830577123);
            });

            it("should create an ISO 8601-ish datetime string from a number of seconds/millis since Epoch", function () {
                expect(variables.dateUtility.formatEpochSeconds(1523830577, "US/Pacific", "ISO_8601")).toBe("2018-04-15T15:16:17");
                expect(variables.dateUtility.formatEpochMillis(1523830577123, "US/Pacific", "ISO_8601_FRACTIONAL")).toBe("2018-04-15T15:16:17.123");
                expect(variables.dateUtility.formatEpochSeconds(1523830577, "UTC", "ISO_8601_ZULU")).toBe("2018-04-15T22:16:17Z");
                expect(variables.dateUtility.formatEpochMillis(1523830577123, "UTC", "ISO_8601_FRACTIONAL_ZULU")).toBe("2018-04-15T22:16:17.123Z");
            });

            it("should parse offset datetimes correctly", function () {
                expect(variables.dateUtility.getInstantFromOffsetDatetime("2018-04-16 14:50:26 -07:00").getEpochSecond()).toBe(1523915426);
                expect(variables.dateUtility.getInstantFromOffsetDatetime("2018-04-16 14:50:26.521 -07:00").toEpochMilli()).toBe(1523915426521);
            });

            it("should return comparable moments", function () {
                /*
                We want to see if the client's application cutoff datetime has passed
                  1. Get the seconds since Epoch based on a datetime string and a time zone
                  2. Get the current seconds since Epoch (but faked for the test)
                  3. Compare
                */
                var cutoff = variables.dateUtility.getEpochSecondsUsingPattern("2018-07-01 00:00:00", "US/Eastern");
                var now = variables.dateUtility.getEpochSecondsUsingPattern("2018-06-30 20:58:00", "US/Pacific");
                expect(cutoff > now).toBeTrue();

                /*
                At the exact moment of cutoff (with resolution of seconds).
                */
                cutoff = variables.dateUtility.getEpochSecondsUsingPattern("2018-07-01 00:00:00", "US/Eastern");
                now = variables.dateUtility.getEpochSecondsUsingPattern("2018-06-30 21:00:00", "US/Pacific");
                expect(cutoff == now).toBeTrue();

                /*
                This time, too late to submit.
                */
                cutoff = variables.dateUtility.getEpochSecondsUsingPattern("2018-07-01 00:00:00", "US/Eastern");
                now = variables.dateUtility.getEpochSecondsUsingPattern("2018-06-30 22:00:01", "US/Mountain");
                expect(cutoff < now).toBeTrue();
            });

            it("should format seconds/millis since Epoch accurately", function () {
                expect(variables.dateUtility.formatEpochSeconds(1523915426)).toBe("04/16/2018");
                expect(variables.dateUtility.formatEpochSeconds(1523915426, "US/Eastern")).toBe("04/16/2018");
                expect(variables.dateUtility.formatEpochSeconds(1523915426, "US/Hawaii", "US_DATETIME")).toBe("04/16/2018 11:50:26 AM");
                expect(variables.dateUtility.formatEpochSeconds(1523915426, "US/Pacific", "US_DATETIME_TZ")).toBe("04/16/2018 2:50:26 PM PDT");
                expect(variables.dateUtility.formatEpochSeconds(1523915426, "US/Arizona", "US_DATETIME_TZ")).toBe("04/16/2018 2:50:26 PM MST");

                expect(variables.dateUtility.formatEpochMillis(1523915426555)).toBe("04/16/2018");
                expect(variables.dateUtility.formatEpochMillis(1523915426555, "US/Eastern")).toBe("04/16/2018");
                expect(variables.dateUtility.formatEpochMillis(1523915426555, "US/Hawaii", "US_DATETIME")).toBe("04/16/2018 11:50:26 AM");
                expect(variables.dateUtility.formatEpochMillis(1523915426555, "US/Pacific", "US_DATETIME_TZ")).toBe("04/16/2018 2:50:26 PM PDT");
                expect(variables.dateUtility.formatEpochMillis(1523915426555, "US/Arizona", "US_DATETIME_TZ")).toBe("04/16/2018 2:50:26 PM MST");
            });

        });
    }

}
