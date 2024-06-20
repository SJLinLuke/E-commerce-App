//
//  SearchHeaderView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/20.
//

import SwiftUI

struct SearchHeaderView: View {
    
    let title       : String
    var buttonTitle : String?
    var buttonAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.bold)
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
    SearchHeaderView(title: "TEST")
}
