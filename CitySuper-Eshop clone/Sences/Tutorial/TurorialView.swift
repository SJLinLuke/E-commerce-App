//
//  TurorialView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/7/13.
//

import SwiftUI

struct TurorialView: View {
    
    @AppStorage("isShowedTurorial") private var isShowed: Bool?
    
    @State private var selectedIndex: Int = 0
    
    @Binding var isShow: Bool
    
    private let tutorialData: [String] = ["Tutorial_1_en", "Tutorial_2_en", "Tutorial_3_en"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $selectedIndex) {
                    ForEach(tutorialData.indices, id: \.self) { index in
                        VStack {
                            Image(tutorialData[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: geometry.size.height, alignment: .top)
                                .overlay(alignment: .topTrailing) {
                                    Button { isShow = false } label: {
                                        Text("Skip")
                                            .underline()
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                }
                        }
                        .tag(index)
                    }
                }
                .overlay(alignment: .bottom) {
                    VStack(spacing: 30) {
                        customPageControl(selectedIndex: $selectedIndex, data: tutorialData)
                        
                        Button {
                            tapNext()
                        } label: { 
                            ThemeButton(title: selectedIndex == tutorialData.count - 1 ? "Start Shopping" : "Next")
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 25)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                    .background(Color.white.opacity(0.5))
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .onAppear { isShowed = true }
        }
    }
    
    private func tapNext() {
        withAnimation {
            if selectedIndex == tutorialData.count - 1 {
                isShow = false
            }
            
            if selectedIndex < tutorialData.count - 1 {
                selectedIndex += 1
            }
        }
    }
}

#Preview {
    TurorialView(isShow: .constant(true))
}

struct customPageControl: View {
    
    @Binding var selectedIndex: Int
    
    let data: [String]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(data.indices, id: \.self) { index in
                Circle()
                    .fill(index == selectedIndex ? .themeDarkGreen : Color.gray)
                    .frame(width: 8, height: 8)
                    .onTapGesture {
                        withAnimation {
                            self.selectedIndex = index
                        }
                    }
            }
        }
    }
}
