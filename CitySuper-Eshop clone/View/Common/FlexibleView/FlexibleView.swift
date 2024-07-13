//
//  FlexibleView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/17.
//
// from https://www.fivestars.blog/articles/flexible-swiftui/

import SwiftUI

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    let availableWidth: CGFloat
    let data          : Data
    let spacing       : CGFloat
    let alignment     : HorizontalAlignment
    let isShowMore    : Bool
    let content       : (Data.Element) -> Content
    
    var body : some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(generateRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .background(GeometryReader { geometry in
                                Color.clear.onAppear {
                                    elementsSize[element] = geometry.size
                                }
                            })
                            .fixedSize()
                    }
                    
                    Spacer()
                }
                .padding(.leading)
            }
        }
    }
    
    func generateRows() -> [[Data.Element]] {
        
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
                 
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }
        
        if !isShowMore && !rows[0].isEmpty {
            return [rows[0]]
        }
        
        return rows
    }
}
    
//#Preview {
//    FlexibleView()
//}
