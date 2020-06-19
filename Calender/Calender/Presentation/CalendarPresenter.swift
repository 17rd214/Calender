import Foundation

protocol ResponseForCalendar {
    func responseDateManager(response: [String])
    func responseNumberOfWeeks(response: Int)
}

class CalendarPresenter: ResponseForCalendar {

    var viewLogic: ViewLogic?
    
    func responseDateManager(response: [String]) {
        viewLogic?.daysArray2 = response
    }
    
    func responseNumberOfWeeks(response: Int) {
        viewLogic?.numberOfWeeks = response
    }
    
}
