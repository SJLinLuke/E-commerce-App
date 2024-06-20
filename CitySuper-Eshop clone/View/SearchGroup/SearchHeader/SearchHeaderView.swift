//
//  SearchHeaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SearchHeaderView: View {
    
    let text           : Text
    var titleFont      : Font = .system(size: 16)
    var titleFontWeight: Font.Weight = .bold
    var buttonTitle    : String?
    var buttonAction   : (() -> Void)?
    
    var body: some View {
        HStack {
            text
                .font(titleFont)
                .fontWeight(titleFontWeight)
                .foregroundColor(Color(hex: "777777"))
            
            Spacer()
            
            if let buttonTitle = buttonTitle {
                Button(action: buttonAction ?? {})  {
                    Text(buttonTitle)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}


#Preview {
    SearchHeaderView(text: Text("TEST"))
}
