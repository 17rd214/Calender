import Foundation

enum DateItems {
    
    enum ThisMonth {
        struct Request {
            //月を更新するたび値消される？
           
            var year1: Int
            var month1: Int
            var day1: Int
            
            
            init() {
                let calendar = Calendar(identifier: .gregorian)
                let date = calendar.dateComponents([.year, .month, .day], from: Date())
                year1 = date.year!
                month1 = date.month!
                day1 = date.day!
            }
        }
    }
    
    enum MoveMonth {
        struct Request {
            
            var year2: Int
            var month2: Int
            
            init(_ monthCounter: Int) {
                let calendar = Calendar(identifier: .gregorian)
                let date = calendar.date(byAdding: .month, value: monthCounter, to: Date())
                let newDate = calendar.dateComponents([.year, .month], from: date!)
                year2 = newDate.year!
                month2 = newDate.month!
            }
        }
    }
    
}
