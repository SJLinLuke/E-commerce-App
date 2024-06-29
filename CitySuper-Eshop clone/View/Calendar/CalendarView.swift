//
//  CalendarView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/27.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject private var VM     : CalendarViewModel
    
    @Binding var currentSelectedDate: String

    private let screenWidth = UIScreen.main.bounds.width * 0.9
    private let column = [
        GridItem(.adaptive(minimum: UIScreen.main.bounds.width * 0.9 / 8, maximum: UIScreen.main.bounds.width * 0.9 / 8))]
    
    init(currentSelectedDate: Binding<String>, startDate: String, endDate: String) {
        self._currentSelectedDate = currentSelectedDate
        self._VM = StateObject(wrappedValue: 
                                CalendarViewModel(startDate: startDate, endDate: endDate))
    }
    
    var body: some View {
        VStack {
            Text(VM.currentMonthYear)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .padding(.top, 10)
            
            WeekDaysView()
            
            TabView(selection: $VM.selectedMonthIndex) {
                ForEach(VM.availableMonth, id: \.self) { index in
                    GeometryReader { geometry in
                        LazyVGrid(columns: column) {
                            ForEach(VM.currentMonthDays.indices, id: \.self) { index in
                                let day = VM.currentMonthDays[index]
                                let isSelected: Bool = currentSelectedDate == day
                                if let dayNumber = day.split(separator: "-").last, let dayNumber_int = Int(dayNumber) {
                                    Text("\(dayNumber_int)")
                                        .frame(width: screenWidth / 7.5, height: screenWidth / 7.5)
                                        .font(.system(size: 16))
                                        .background(isSelected ? .themeGreen : Color(hex: "F7F7F7"))
                                        .foregroundColor(isSelected ? .white : VM.isDateBlocked(day) ? .black : .gray)
                                        .cornerRadius(50)
                                        .padding(.bottom, 5)
                                        .onTapGesture {
                                            handleDayTap(day)
                                        }
//                                        .id(index)
                                } else {
                                    Text(day)
//                                        .id(index)
                                }
                            }
                            .id(UUID())
                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                VM.frameHeight = geometry.size.height
                            }
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: VM.selectedMonthIndex) {
                VM.loadNextMonthDays()
            }
            .frame(height: VM.frameHeight == .zero ? 350 : VM.frameHeight)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(hex: "DADADA"),lineWidth: 2)
        }
        .background(Color(hex: "F7F7F7"))
        .padding(.horizontal, 10)
    }
    
    private func handleDayTap(_ day: String) {
        if VM.isDateBlocked(day) {
            currentSelectedDate = day
        } else {
            VM.loadNextMonthDays()
            currentSelectedDate = VM.currentMonthDays.first ?? ""
        }
    }
}

#Preview {
    CalendarView(currentSelectedDate: .constant("2024-07-01"), startDate: "2024-06-01", endDate: "2024-07-05")
}

struct WeekDaysView: View {
    
    private let weekdays    = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let screenWidth = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: screenWidth / 8, maximum: screenWidth / 8))]) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "B1B1B1"))
                    .padding(.vertical, 10)
            }
        }
    }
}
