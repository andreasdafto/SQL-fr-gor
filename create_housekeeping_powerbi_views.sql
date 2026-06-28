/*
    Deprecated aggregate script.

    The views have been split into separate files so each one can be updated
    independently:

    00_create_CabinCleaningInfo_table.sql
    create_vw_Bokningar.sql
    create_vw_BookingItem.sql
    create_vw_BookingItemType.sql (creates dbo.vw_HousekeepingBookingItemType)
    create_vw_CabinCleaningInfo.sql (optional; redundant if vw_BookingItemType is used)
    create_vw_BookingStatus.sql
    create_vw_ArrivalCalendar.sql
    create_vw_DepartureCalendar.sql
    create_vw_CreatedCalendar.sql
*/
