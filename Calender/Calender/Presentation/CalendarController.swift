import Foundation

protocol RequestForCalendar: class {
    func requestNumberOfWeeks(request: DateItems.ThisMonth.Request)
    func requestDateManager(request: DateItems.ThisMonth.Request)
    
    func requestNumberOfWeeks(request: DateItems.MoveMonth.Request)
    func requestDateManager(request: DateItems.MoveMonth.Request)
}

class CalendarController: RequestForCalendar {

    var calendarLogic: CalendarLogic?
    
    func requestNumberOfWeeks(request: DateItems.ThisMonth.Request) {
        calendarLogic?.numberOfWeeks(year: request.year1, month: request.month1)
    }
    
    func requestDateManager(request: DateItems.ThisMonth.Request) {
        calendarLogic?.dateManager(year: request.year1, month: request.month1)
    }
    
    func requestDateManager(request: DateItems.MoveMonth.Request) {
        calendarLogic?.dateManager(year: request.year2, month: request.month2)
    }
    
    func requestNumberOfWeeks(request: DateItems.MoveMonth.Request) {
        calendarLogic?.numberOfWeeks(year: request.year2, month: request.month2)
    }
    
}
