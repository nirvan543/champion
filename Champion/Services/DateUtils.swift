//
//  DateUtils.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import Foundation

struct DateUtils {
    static func date(year: Int, month: Month, day: Int? = nil) -> Date? {
        return Calendar.current.date(from: DateComponents(year: year,
                                                          month: month.rawValue,
                                                          day: day))
    }
}

enum Month: Int {
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12
}
