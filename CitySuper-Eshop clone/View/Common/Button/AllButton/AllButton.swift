//
//  AllButton.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/13.
//

import SwiftUI

struct AllButton: View {
    var body: some View {
        Text("ALL")
        .foregroundColor(.themeGreen)
        .font(.subheadline)
        .frame(width: 80, height: 27)
        .border(.green, width: 1)
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    LinearGradient(
                        colors: [
                                Color(hex: "20741B"),
                                Color(hex: "7DE489")],
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading))
        }
    }
}

#Preview {
    AllButton()
}
