//
//  DateUtils.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation

open class DateUtils {
    // there is no timezone. this is an old format and eventually we'll convert to a new format with timezone
    
    //"2018-03-07T14:47:41Z"
    fileprivate static let dateTimeFormatCompact = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    fileprivate static let dateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    fileprivate static let dateTimeWithTimezoneFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    fileprivate static let dateTimeWithTimezoneFormatFilenameSafe = "yyyy_MM_dd'T'HH_mm_ss_SSSZ"
    fileprivate static let dateFormat = "yyyy-MM-dd"
    fileprivate static let displayableDateFormat = "MM/dd/yyyy"
    fileprivate static let displayableDateFormatWithDay = "E MMM dd, yyyy"
    fileprivate static let displayableTimeFormat = "hh:mm:ss a"
    fileprivate static let displayableDateTimeFormat = "MM/dd/yyyy hh:mm a z"
    fileprivate static let displayableLunchTimeFormat = "h:mm a"
    fileprivate static let displayableTimeFrameFormat = "h:mm a" // For Delivery Restrictions
    fileprivate static let dayOfWeekFormat = "EEEE" // eg: Monday
    fileprivate static let monthFormat = "MM" // eg: January
    fileprivate static let timezonedSimpleTimeFormat = "HH:mmZ" // e.g. 23:43-0500
    fileprivate static let simpleTimeFormat = "HH:mm" // e.g. 23:43
    fileprivate static let dayOfWeekShortFormat = "E" // eg. Mon
    
    fileprivate static let formatterDateTimeCompactUTC: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateTimeFormatCompact
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    fileprivate static let formatterDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    fileprivate static let formatterDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateTimeFormat
        return formatter
    }()
    
    public static let formatterDateTimeWithTimezone: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateTimeWithTimezoneFormat
        return formatter
    }()
    
    fileprivate static let formatterDateTimeWithTimezoneFilenameSafe: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateTimeWithTimezoneFormatFilenameSafe
        return formatter
    }()
    
    fileprivate static let displayableLunchTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = displayableLunchTimeFormat
        return formatter
    }()
    
    fileprivate static let displayableTimeFrameFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = displayableTimeFrameFormat
        return formatter
    }()
    
    fileprivate static let displayableDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = displayableDateFormat
        return dateFormatter
    }()
    
    fileprivate static let displayableDateFormatterWithDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = displayableDateFormatWithDay
        return dateFormatter
    }()
    
    fileprivate static let displayableTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = displayableTimeFormat
        return dateFormatter
    }()
    
    fileprivate static let displayableDateTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = displayableDateTimeFormat
        return dateFormatter
    }()
    
    fileprivate static let dayOfWeekFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dayOfWeekFormat
        return dateFormatter
    }()
    
    public static let monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = monthFormat
        return dateFormatter
    }()
    
    fileprivate static let simpleTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = simpleTimeFormat
        return dateFormatter
    }()
    
    fileprivate static let timezonedSimpleTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timezonedSimpleTimeFormat
        return dateFormatter
    }()
    
    fileprivate static let dayOfWeekShortFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dayOfWeekShortFormat
        return dateFormatter
    }()
    
    // MARK: - NSCalendar
    
    /// Gets the gregorian calendar. wrapper to avoid the optional
    public static func getNSCalendar() -> Calendar {
        return DateUtils.calendar
    }
    
    static let calendar : Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    /// Adds number of days to a date. wrapper to avoid the optional
    public static func addDays(_ date: Date, numberOfDays: Int) -> Date {
        if let date = (DateUtils.getNSCalendar() as NSCalendar).date(
            byAdding: .day,
            value: numberOfDays,
            to: date,
            options: NSCalendar.Options(rawValue: 0)) {
            return date
        } else {
            fatalError("\(#function) Could not add \(numberOfDays) to date \(date)")
        }
    }
    
    /// Adds number of hours to a date time. wrapper to avoid the optional
    public static func addHours(_ dateTime: Date, numberOfHours: Int) -> Date {
        if let date = (DateUtils.getNSCalendar() as NSCalendar).date(
            byAdding: .hour,
            value: numberOfHours,
            to: dateTime,
            options: NSCalendar.Options(rawValue: 0)) {
            return date
        } else {
            fatalError("\(#function) Could not add \(numberOfHours) to date-time \(dateTime)")
        }
    }
    
    /// Adds number of years to a date. wrapper to avoid the optional
    public static func addYears(_ date: Date, numberOfYears: Int = 1) -> Date {
        if let date = (DateUtils.getNSCalendar() as NSCalendar).date(
            byAdding: .year,
            value: numberOfYears,
            to: date,
            options: NSCalendar.Options(rawValue: 0)) {
            return date
        } else {
            fatalError("\(#function) Could not add \(numberOfYears) to date \(date)")
        }
    }
    
    /// Adds number of seconds to a date time. wrapper to avoid the optional
    public static func addSeconds(_ dateTime: Date, numberOfSeconds: Int) -> Date {
        if let date = (DateUtils.getNSCalendar() as NSCalendar).date(
            byAdding: .second,
            value: numberOfSeconds,
            to: dateTime,
            options: NSCalendar.Options(rawValue: 0)) {
            return date
        } else {
            fatalError("\(#function) Could not add \(numberOfSeconds) to date-time \(dateTime)")
        }
    }
    
    public static func isWeekday(_ date: Date) -> Bool {
        return !DateUtils.calendar.isDateInWeekend(date)
    }
    
    /// Checks if two days are equal, ignoring time stamp
    public static func equalsIgnoreTime(_ first: Date, second: Date) -> Bool {
        // re-creating the calendar causes significant performance problems. reuse our static field
        let calendar = getNSCalendar()
        let granularity: NSCalendar.Unit = .day
        
        let comparison = (calendar as NSCalendar).compare(
            first,
            to: second,
            toUnitGranularity: granularity)
        
        switch comparison {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    // monthIndex must be 0-11, returns "January" for 0
    public static func nameOfMonth(monthIndex: Int) -> String {
        return monthFormatter.monthSymbols[monthIndex]
    }
    
    public static func nameOfDayOfWeek(_ date: Date) -> String {
        return dayOfWeekFormatter.string(from: date)
    }
    
    // MARK: - Convenience Dates
    
    public static func isDateInToday(date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    
    /*
    // returns if startDate <= date <= endDate
    public static func isBetweenInclusive(date: Date, startDate: Date, endDate: Date) -> Bool {
        return date.isGreaterThanEqualTo(startDate) && date.isLessThanEqualTo(endDate)
    }
    
    /// Gets today's date without time stamp
    public static func todayDate() -> Date {
        return stringToDate(dateToString(Date()))
    }
    
    public static func truncateTimeFromDateTime(_ dateTime: Date) -> Date {
        return stringToDate(dateToString(dateTime))
    }
    
    public static func isDateRangeActive(_ startDate: Date, endDate: Date?, date: Date = DateUtils.todayDate()) -> Bool {
        //remove timestamps, should the nsdates have them
        let truncatedDate = truncateTimeFromDateTime(date)
        let startDateOnly = truncateTimeFromDateTime(startDate)
        if startDateOnly.isGreaterThan(truncatedDate) {
            // active date hasn't started yet
            return false
        }
        guard let endDate = endDate else {
            // no end date, so it's active
            return true
        }
        let endDateOnly = truncateTimeFromDateTime(endDate)
        if truncatedDate.isGreaterThan(endDateOnly) {
            // already end-dated
            return false
        }
        return true
    }
    */
    
    
    
    
    // used for our calendar stuff. gets the year from a date
    public static func getYear(_ date: Date) -> String {
        let calendar = DateUtils.getNSCalendar()
        let components = (calendar as NSCalendar).components([.year], from: date)
        let year = String(describing: components.year!)
        return year
    }
    
    public static func getHours(_ date: Date) -> String {
        let calendar = DateUtils.getNSCalendar()
        let components = (calendar as NSCalendar).components([.hour], from: date)
        let hour = String(describing: components.hour!)
        return hour
    }
    
    public static func getMinutes(_ date: Date) -> String {
        let calendar = DateUtils.getNSCalendar()
        let components = (calendar as NSCalendar).components([.minute], from: date)
        let minute = String(describing: components.minute!)
        return minute
    }
    
    public static func getSeconds(_ date: Date) -> String {
        let calendar = DateUtils.getNSCalendar()
        let components = (calendar as NSCalendar).components([.second], from: date)
        let second = String(describing: components.second!)
        return second
    }
    
    // MARK: - Convert between dates and strings
    
    public static func dateTimeToCompactUTCString(_ dateTime: Date) -> String {
        return formatterDateTimeCompactUTC.string(from: dateTime)
    }
    
    public static func dateTimeToString(_ dateTime: Date) -> String {
        return formatterDateTimeWithTimezone.string(from: dateTime)
    }
    
    public static func dateTimeToStringFilenameSafe(_ dateTime: Date) -> String {
        return formatterDateTimeWithTimezoneFilenameSafe.string(from: dateTime)
    }
    
    public static func dateTimeWithTimezoneToString(_ dateTime: Date) -> String {
        return formatterDateTimeWithTimezone.string(from: dateTime)
    }
    
    public static func dateToString(_ date: Date) -> String {
        return formatterDate.string(from: date)
    }
    
    public static func displayableTime(from date: Date) -> String? {
        return displayableTimeFormatter.string(from: date)
    }
    
//    public static func stringToDate(_ string: String) -> Date {
//        do {
//            return try stringToDateOrError(string)
//        } catch {
//            fatalError("\(error)")
//        }
//    }
    
//    public static func stringToDateOrError(_ string: String) throws -> Date {
//        if let date = formatterDate.date(from: string){
//            return date
//        } else {
//           /// try DatabaseError.throwError("Date \(string) is not parsable in format \(dateFormat)")
//        }
//    }
    
//    public static func stringToDateTime(_ string: String) -> Date {
//        do {
//            return try stringToDateTimeOrError(string)
//        } catch {
//            fatalError("\(error)")
//        }
//    }
    
//    public static func stringToDateTimeOrError(_ string: String) throws -> Date {
//        if let dateTime = formatterDateTime.date(from: string){
//            return dateTime
//        } else if let dateTime = formatterDateTimeWithTimezone.date(from: string) {
//            // if it's not in the old format, see if we're getting data from the new format with timezone
//            return dateTime
//        } else {
//           // try DatabaseError.throwError("Date \(string) is not parsable in formats \(dateTimeFormat) or \(dateTimeWithTimezoneFormat)")
//        }
//    }
    
    public static func displayableDate(from date: String) -> Date? {
        return displayableDateFormatter.date(from: date)
    }
    
    public static func displayableDate(from date: Date) -> String? {
        return displayableDateFormatter.string(from: date)
    }
    
    public static func displayableDateWithDay(from date: String) -> Date? {
        return displayableDateFormatterWithDay.date(from: date)
    }
    
    public static func displayableDateWithDay(from date: Date) -> String? {
        return displayableDateFormatterWithDay.string(from: date)
    }
    
    public static func displayableDateTime(from date: String) -> Date? {
        return displayableDateTimeFormatter.date(from: date)
    }
    
    public static func displayableDateTime(from date: Date) -> String? {
        return displayableDateTimeFormatter.string(from: date)
    }
    
    public static func displayableLunchTime(from date: Date?) -> String {
        if let date = date {
            return displayableLunchTimeFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    public static func displayableTimeFrame(from date: Date?) -> String {
        if let date = date {
            return displayableTimeFrameFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    public static func stringSimpleTimeToDate(string: String) -> Date? {
        if let date = simpleTimeFormatter.date(from: string){
            return date
        }
        return nil
    }
    
    public static func dateToSimpleTime(date: Date) -> String {
        return simpleTimeFormatter.string(from: date)
    }
    
    public static func stringTimezonedSimpleTimeToDate(string: String) -> Date? {
        if let date = timezonedSimpleTimeFormatter.date(from: string){
            return date
        }
        return nil
    }
    
    public static func timeToTimezonedSimpleTime(date: Date) -> String {
        return timezonedSimpleTimeFormatter.string(from: date)
    }
    
    // MARK: - Convenience functions that allow optional inputs
    
    public static func dateTimeToCompactUTCStringOptional(_ dateTime: Date?) -> String? {
        guard let dateTime = dateTime else { return nil }
        return dateTimeToCompactUTCString(dateTime)
    }
    
    public static func dateTimeToStringOptional(_ dateTime: Date?) -> String? {
        // TODO: eventually we'll want to write the new format with time zone
        if let dateTime = dateTime {
            return dateTimeToString(dateTime)
        } else {
            return nil
        }
    }
    
    public static func dateTimeWithTimezoneToStringOptional(_ dateTime: Date?) -> String? {
        if let dateTime = dateTime {
            return dateTimeWithTimezoneToString(dateTime)
        } else {
            return nil
        }
    }
    
    public static func dateToStringOptional(_ date: Date?) -> String? {
        if let date = date {
            return dateToString(date)
        } else {
            return nil
        }
    }
    
//    public static func stringToDateOptional(_ string: String?) -> Date? {
//        do {
//            if let string = string, string.count > 0 {
//                return try stringToDateOrError(string)
//            } else {
//                return nil
//            }
//        } catch {
//
//            return nil
//        }
//    }
    
//    public static func stringToDateTimeOptional(_ string: String?) -> Date? {
//        do {
//            if let string = string, string.count > 0 {
//                return try stringToDateTimeOrError(string)
//            } else {
//                return nil
//            }
//        } catch {
//            
//            return nil
//        }
//    }
    
    public static func dateFrom(seconds: Int) -> Date? {
        return Date().addSecondsToCurrentDate(seconds)
    }
    
}

public extension Date {
    var displayableDate: String? {
        return DateUtils.displayableDate(from: self)
    }
    
    var displayableDateWithDay: String? {
        return DateUtils.displayableDateWithDay(from: self)
    }
    
    var displayableTime: String? {
        return DateUtils.displayableTime(from: self)
    }
    
    var displayableTimeFrame: String? {
        return DateUtils.displayableTimeFrame(from: self)
    }
    
    var formattedToHrsandMin: String {
        let hrs = DateUtils.getHours(self)
        let min = DateUtils.getMinutes(self)
        return String.localizedStringWithFormat(NSLocalizedString("CustomerDetailsViewController.DeliveryRestrictions.DeliveryDuration.TimeFormat %@%@", comment: ""), hrs, min)
    }
    
    func addSecondsToCurrentDate(_ seconds: Int?) -> Date? {
        guard let seconds = seconds else { return nil }
        let dateAfterSec = Calendar.current.startOfDay(for: self) + TimeInterval(seconds)
        return dateAfterSec
    }
}
