//
//  CalendarViewModel.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/28.
//

import Foundation

@MainActor final class CalendarViewModel: ObservableObject {
    
    @Published var availableMonth: [Int] = []
    @Published var frameHeight: CGFloat = .zero
    @Published var currentMonth: Date = Date()
    @Published var currentMonthDays: [String] = []
    @Published var currentMonthYear: String = ""
    @Published var selectedMonthIndex: Int = 1

    private let calendar = Calendar.current
    
    private var startDate: String = ""
    private var endDate  : String = ""

    init(startDate: String, endDate: String) {
        self.startDate = startDate
        self.endDate   = endDate
        self.availableMonth = self.collectAvailableMonthes(startDate: startDate, endDate: endDate)
        self.perpareDates()
    }
    
    func loadNextMonthDays() {
        if let maxMonth = availableMonth.max() {
            let currentMonthComponent = Calendar.current.component(.month, from: currentMonth)
            
            if currentMonthComponent >= maxMonth {
                currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
            } else {
                currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
            }
            
            currentMonthDays = []
            perpareDates()
        }
    }

    private func perpareDates() {
        
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        let firstDayOfMonth = calendar.date(from: components)!
        let spacesCount = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        currentMonthYear = dateFormatter.string(from: currentMonth)
        
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let year = calendar.component(.year, from: currentMonth)
        let month = calendar.component(.month, from: currentMonth)
        
        var arr: [String] = []
        arr.insert(contentsOf: Array(repeating: "", count: spacesCount), at: 0)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for day in range {
            if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
                arr.append(dateFormatter.string(from: date))
            }
        }
        currentMonthDays = arr
    }

    private func collectAvailableMonthes(startDate: String, endDate: String) -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: startDate),
              let endDate = dateFormatter.date(from: endDate) else {
            return []
        }
        
        let startMonth = calendar.component(.month, from: startDate)
        let endMonth = calendar.component(.month, from: endDate)
        
        var monthRange: [Int] = []
        if startMonth <= endMonth {
            monthRange = Array(startMonth...endMonth)
        } else {
            // Handle case where start month is after end month (crossing year boundary)
            monthRange = Array(startMonth...12) + Array(1...endMonth)
        }
        
        // default value setup
        self.selectedMonthIndex = monthRange.sorted().first ?? 1
        
        var components = calendar.dateComponents([.year], from: Date())
        components.month = monthRange.sorted().first
        components.day = 1
        self.currentMonth = calendar.date(from: components) ?? Date()
        
        return monthRange.sorted()
    }
    
    func isDateBlocked(_ date: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let startDate = formatter.date(from: startDate),
              let endDate = formatter.date(from: endDate),
              let checkDate = formatter.date(from: date) else {
            return false
        }
        
        return (startDate...endDate).contains(checkDate)
    }
}
