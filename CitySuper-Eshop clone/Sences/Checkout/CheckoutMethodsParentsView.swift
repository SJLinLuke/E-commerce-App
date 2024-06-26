//
//  CheckoutDelivery.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/24.
//

import SwiftUI

struct CheckoutMethodsParentsView: View {
    
    enum methodsType: String {
        case delivery = "Delivery"
        case pickup   = "Pickup"
    }
    
    @State private var currentMethod: methodsType = .delivery
    
    private let methods: [methodsType] = [.delivery, .pickup]
    
    private let width = UIScreen.main.bounds.width / 2
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(methods, id: \.self) { method in
                    
                    let isSelected: Bool = method == currentMethod
                    
                    Text(method.rawValue)
                        .frame(width: width, height: 75)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .overlay(alignment: .bottom) {
                            if (isSelected) {
                                Spacer()
                                    .frame(height: 2)
                                    .background(Color(hex: "#46742D"))
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                self.currentMethod = method
                            }
                        }
                }
            }
            .background(Color(hex: "F2F2F2"))
            .padding()
            
            
            TabView(selection: $currentMethod) {
                ForEach(methods, id: \.self) { method in
                    switch currentMethod {
                    case .delivery:
                        delivery()
                    case .pickup:
                        pickup()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(EdgeInsets(top: -15, leading: 0, bottom: -10, trailing: 0))
            
            Spacer()
        }
        .modifier(NavigationModifier(isHideCollectionsList: true, isHideShoppingCart: true))
    }
}

struct delivery: View {
    
    @State var firstName: String = ""
    @State var isSave: Bool = false
    @State var currentDate: String = ""
    @State private var currentMonth: Date = Date()
    @State private var selectedMonthIndex = 1
    @State private var availableMonth:[Int] = []
    private let screenWidth = UIScreen.main.bounds.width * 0.9
    
    let data = [1, 2]
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let startDate = "2024-06-20"
    let endDate = "2024-07-05"
    // 获取当前月份的天数
    @State var currentMonthDays: [String] = []
    func collectMonthsInRange(startDate: Date, endDate: Date) -> [Int] {
        let calendar = Calendar.current
            let startComponents = calendar.dateComponents([.year, .month], from: startDate)
            let endComponents = calendar.dateComponents([.year, .month], from: endDate)
            
            var collectedMonths: Set<Int> = []
            
            // Iterate through each month and collect unique month components
            var currentDate = calendar.date(from: startComponents)!
            while currentDate <= endDate {
                let month = calendar.component(.month, from: currentDate)
                collectedMonths.insert(month)
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
            }
            
            return collectedMonths.sorted()
    }
     // 获取当前月份和年份的字符串
    var currentMonthYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
    private func loadNextMonthDays() {
        currentMonthDays = []
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
        perpareDates()
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
        
        // 使用空字串來代替空白部分
        let range = calendar.range(of: .day, in: .month, for: date)!
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        var arr: [String] = []
        arr.insert(contentsOf: Array(repeating: "", count: spacesCount), at: 0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for day in range {
            if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
                arr.append(dateFormatter.string(from: date))
            }
        }
        currentMonthDays = arr
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
//                HStack {
//                    Text("Delivery Address")
//                        .font(.system(size: 16))
//                        .fontWeight(.bold)
//                    
//                    Spacer()
//                }
//                .padding(.leading, 8)
//                .padding(.vertical)
                
//                ForEach(data, id: \.self) { index in
//                    HStack(spacing: 10) {
//                        Circle()
//                            .frame(width: 15)
//                            .foregroundColor(.clear)
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 50)
//                                    .stroke(.secondary, lineWidth: 0.5)
//                                Circle()
//                                    .frame(width: 5.5)
//                                    .foregroundColor(.themeDarkGreen)
//                            }
//                            .shadow(radius: 10)
//                            .padding(.leading, 10)
//                        
//                        HStack {
//                            Text("TESTER USER\nNO ADDRESS TEST\n123458999")
//                                .padding(8)
//                                .lineSpacing(5)
//                                .font(.callout)
//                                .fontWeight(.regular)
//                                .foregroundColor(Color(hex: "666666"))
//                            
//                            Spacer()
//                        }
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color(hex: "D2D2D2") ,lineWidth: 1)
//                        }
//                        .background(Color(hex: "F2F2F2"))
//                        
//                        
//                    }
//                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
//                    
//                    if index == data.last {
//                        HStack(spacing: 10) {
//                            VStack {
//                                Circle()
//                                    .frame(width: 15)
//                                    .foregroundColor(.clear)
//                                    .overlay {
//                                        RoundedRectangle(cornerRadius: 50)
//                                            .stroke(.secondary, lineWidth: 0.5)
//                                        Circle()
//                                            .frame(width: 5.5)
//                                            .foregroundColor(.themeDarkGreen)
//                                    }
//                                    .shadow(radius: 10)
//                                    .padding(.leading, 10)
//                                    .padding(.top, 10)
//                                
//                                Spacer()
//                            }
//                            
//                            
//                            VStack {
//                                CustomTextField(placeHolder: "Your first name", text: $firstName)
//                                CustomTextField(placeHolder: "Your last name", text: $firstName)
//                                CustomTextField(placeHolder: "Company(Optional)", text: $firstName)
//                                CustomTextField(placeHolder: "Address", text: $firstName)
//                                CustomTextField(placeHolder: "District", text: $firstName)
//                                HStack {
//                                    CustomTextField(placeHolder: "Country/Region", isDropDown: true, dropDownItem: ["Hong kong"], text: $firstName)
//                                    CustomTextField(placeHolder: "Region", isDropDown: true, dropDownItem: ["Hong kong"], text: $firstName)
//                                }
//                                CustomTextField(placeHolder: "Your phone number", text: $firstName)
//                                HStack {
//                                    Rectangle()
//                                        .frame(width: 20, height: 20)
//                                        .foregroundColor(.clear)
//                                        .overlay {
//                                            if isSave {
//                                                Image("checkbox_icon")
//                                            } else {
//                                                Rectangle()
//                                                    .stroke(Color(hex: "D2D2D2"), lineWidth: 1)
//                                            }
//                                        }
//                                        .onTapGesture {
//                                            isSave.toggle()
//                                        }
//                                    
//                                    Text("Save this information for next time")
//                                        .font(.system(size: 14))
//                                    Spacer()
//                                }
//                            }
//                        }
//                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
//                    }
//                }
                
                HStack {
                    Text("Delivery time :")
                        .bold()
                    Text(currentDate.convertDataFormat(fromFormat: "yyyy-MM-dd", toFormat: "yyyy/MM/dd"))
                    Spacer()
                }
                .font(.system(size: 14))
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                
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
                            let month = Calendar.current.date(byAdding: .month, value: index, to: currentMonth)!
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: screenWidth / 8, maximum: screenWidth / 8))]) {
                                
                               
                                
                                ForEach(currentMonthDays, id: \.self) { day in
                                    let isSelected: Bool = currentDate == day
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
                                                    currentDate = day
                                                } else {
                                                    loadNextMonthDays()
                                                    currentDate = currentMonthDays.first ?? ""
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
                        self.availableMonth = [6, 7]
//                        collectMonthsInRange(startDate: startDate, endDate: endDate)
                    }
                    .frame(height: 400)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .gesture(DragGesture()
                        .onEnded({ value in
                            // 根据滑动方向更新选中的月份索引
//                            if value.translation.width < 0 {
//                                // 左滑，切换到下一个月份
//                                print("左滑，切换到下一个月份")
//                                selectedMonthIndex = selectedMonthIndex + 1
//                            } else if value.translation.width > 0 {
//                                // 右滑，切换到上一个月份
//                                print("右滑，切换到上一个月份")
//                                selectedMonthIndex = selectedMonthIndex - 1
//                            }
                            print(value)

                        })
                    )
                    .onChange(of: selectedMonthIndex) {
                        print(selectedMonthIndex)
                        loadNextMonthDays()
                    }
                    
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(hex: "DADADA"),lineWidth: 2)
                }
                .background(Color(hex: "F7F7F7"))
                .padding(.horizontal, 10)
                
                ThemeButton(title: "Confirm", width: screenWidth )
                    .padding(.top)
            }
        }
    }
}

struct pickup: View {
    var body: some View {
        Text("pickup")
    }
}

#Preview {
    CheckoutMethodsParentsView()
        .environmentObject(CartEnvironment())
}
