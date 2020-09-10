import UIKit
import PlaygroundSupport
import EventKit
var str = "Hello, playground"

enum WeekDays: Int, CustomStringConvertible, CaseIterable, Comparable {
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    var description: String {
        switch self {
            case .mon: return "COMMON_MONDAY"
            case .tue: return "COMMON_TUESDAY"
            case .wed: return "COMMON_WEDNESDAY"
            case .thu: return "COMMON_THURSDAY"
            case .fri: return "COMMON_FRIDAY"
            case .sat: return "COMMON_SATURDAY"
            case .sun: return "COMMON_SUNDAY"
        }
    }
    var ekWeekDay: EKWeekday {
        switch self {
            case .mon: return EKWeekday.monday
            case .tue: return EKWeekday.tuesday
            case .wed: return EKWeekday.wednesday
            case .thu: return EKWeekday.thursday
            case .fri: return EKWeekday.friday
            case .sat: return EKWeekday.saturday
            case .sun: return EKWeekday.sunday
        }
    }
    
    static func currentWeekDay() -> WeekDays? {
        let currentWeekDay = Calendar.current.component(.weekday, from: Date())
        guard let ekWeekday = EKWeekday(rawValue: currentWeekDay) else { return nil }
        switch ekWeekday {
            case .monday: return WeekDays.mon
            case .tuesday: return WeekDays.tue
            case .wednesday: return WeekDays.wed
            case .thursday: return WeekDays.thu
            case .friday: return WeekDays.fri
            case .saturday: return WeekDays.sat
            case .sunday: return WeekDays.sun
        }
    }
    
    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    static func < (lhs: WeekDays, rhs: WeekDays) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

func createDateFromTime(_ time: String, weekDay: WeekDays) -> Date? {
    guard let hourString = time.components(separatedBy: ":").first,
        let minuteString = time.components(separatedBy: ":").last,
        let hour = Int(hourString),
        let minute = Int(minuteString) else {
            return nil
    }
    let weekDayComponent = DateComponents(calendar: Calendar.current, weekday: weekDay.ekWeekDay.rawValue)
    guard let selectDate = Calendar.current.nextDate(after: Date(), matching: weekDayComponent, matchingPolicy: .nextTimePreservingSmallerComponents) else {
        return nil
    }
    return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: selectDate)
}


let a = createDateFromTime("19:00", weekDay: WeekDays.tue)

let padding: CGFloat = 8
let outerView = UIView(frame: CGRect(x: 0, y: 0, width: padding * 2 + 23, height: 23))
let imageView = UIImageView(frame: CGRect(x: padding, y: 0, width: 23, height: 23))
imageView.image = image
outerView.addSubview(imageView)
leftView = outerView // Or rightView = outerView
leftViewMode = .always // Or rightViewMode = .always


PlaygroundPage.current.needsIndefiniteExecution = true
