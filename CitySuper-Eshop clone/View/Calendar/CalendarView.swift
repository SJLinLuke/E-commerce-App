//
//  CalendarView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/27.
//

import SwiftUI

struct CalendarView: View {
    @Binding var currentSelectedDate: String

    @State private var currentMonth: Date = Date()
    @State private var selectedMonthIndex = 1
    @State private var availableMonth:[Int] = []
    @State private var currentMonthDays: [String] = []
    @State var currentMonthYear: String = ""
    
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    let startDate: String
    let endDate: String
    
    private let screenWidth = UIScreen.main.bounds.width * 0.9

    // 获取当前月份的天数
    
    func collectMonthsInRange(startDate: String, endDate: String) -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: startDate),
              let endDate = dateFormatter.date(from: endDate) else {
            return []
        }
        
        let calendar = Calendar.current
        
        let startMonth = calendar.component(.month, from: startDate)
        let endMonth = calendar.component(.month, from: endDate)
        
        var monthRange: [Int] = []
        if startMonth <= endMonth {
            monthRange = Array(startMonth...endMonth)
        } else {
            // Handle case where start month is after end month (crossing year boundary)
            monthRange = Array(startMonth...12) + Array(1...endMonth)
        }
        
        return monthRange.sorted()
    }

    
    private func loadNextMonthDays() {
        let currentMonthComponent = Calendar.current.component(.month, from: currentMonth)
            
            // 檢查當前月份是否在範圍內，且是否能夠增加
            if let maxMonth = availableMonth.max(), currentMonthComponent < maxMonth {
                currentMonthDays = []
                currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
                perpareDates()
            }
            if let maxMonth = availableMonth.max(), currentMonthComponent >= maxMonth {
                currentMonthDays = []
                currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
                perpareDates()
            }
    }
    
    private func isDateBlocked(_ date: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let startDate = formatter.date(from: startDate),
              let endDate = formatter.date(from: endDate),
              let checkDate = formatter.date(from: date) else {
            return false
        }
        
        return (startDate...endDate).contains(checkDate)
    }
    
    private func perpareDates() {
        let calendar = Calendar.current
        let date = currentMonth
        
        // 获取当前月份的第一天是星期几
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = calendar.date(from: components)!
        let spacesCount = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        currentMonthYear = dateFormatter.string(from: currentMonth)
        
        // 使用空字串來代替空白部分
        let range = calendar.range(of: .day, in: .month, for: date)!
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
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
    
    var body: some View {
        VStack {
            Text(currentMonthYear)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .padding(.top, 10)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: screenWidth / 8, maximum: screenWidth / 8))]) {
                ForEach(days, id: \.self) { day in
                    
                    Text(day)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "B1B1B1"))
                        .padding(.vertical, 10 )
                }
            }
            
            TabView(selection: $selectedMonthIndex) {
                ForEach(availableMonth, id: \.self) { index in
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: screenWidth / 8, maximum: screenWidth / 8))]) {
                        
                        ForEach(currentMonthDays, id: \.self) { day in
                            let isSelected: Bool = currentSelectedDate == day
                            if let dayNumber = day.split(separator: "-").last, let dayNumber_int = Int(dayNumber) {
                                Text("\(dayNumber_int)")
                                    .frame(width: screenWidth / 7.5, height: screenWidth / 7.5)
                                    .font(.system(size: 16))
                                    .background(isSelected ? .themeGreen : Color(hex: "F7F7F7"))
                                    .foregroundColor(isSelected ? .white : isDateBlocked(day) ? .black : .gray)
                                    .cornerRadius(50)
                                    .padding(.bottom, 5)
                                    .onTapGesture {
                                        if isDateBlocked(day) {
                                            currentSelectedDate = day
                                        } else {
                                            loadNextMonthDays()
                                            currentSelectedDate = currentMonthDays.first ?? ""
                                        }
                                    }
                            } else {
                                Text(day)
                            }
                           
                        }.id(UUID())
                    }
                }
            }
            .onAppear {
                perpareDates()
                self.availableMonth = collectMonthsInRange(startDate: startDate, endDate: endDate)
            }
            .frame(height: 400)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selectedMonthIndex) {
                loadNextMonthDays()
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(hex: "DADADA"),lineWidth: 2)
        }
        .background(Color(hex: "F7F7F7"))
        .padding(.horizontal, 10)
    }
}

#Preview {
    CalendarView(currentSelectedDate: .constant(""), startDate: "", endDate: "")
}
