//
//  MoreListView.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/6/1.
//

import SwiftUI

struct MoreListView: View {
    
    @State private var isShowStaticPage: Bool   = false
    @State private var selectedPageName: String = "" {
        didSet {
            isShowStaticPage.toggle()
        }
    }
        
    let rows = [
        ProfileRowModel(title: "Language", icon: "arrow_icon", seperateType: true),
        ProfileRowModel(title: "Privacy Policy Statement", icon: "arrow_icon", seperateType: true),
        ProfileRowModel(title: "Terms and Conditions", icon: "arrow_icon", seperateType: true),
        ProfileRowModel(title: "License and Permit", icon: "arrow_icon", seperateType: true),
        ProfileRowModel(title: "Disclaimer", icon: "arrow_icon", seperateType: true),
        ProfileRowModel(title: "Explore city'super HK App", icon: "arrow_icon", seperateType: true),
        ProfileRowModel(title: "Explore city'super E-Shop Website", icon: "arrow_icon", seperateType: true),
        ProfileRowModel(title: "Terminate MemberShip", icon: "", seperateType: true),
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(rows) { rowData in
                        ProfileListCell(rowData: rowData)
                            .onTapGesture {
                                tapCell(rowData)
                            }
                    }
                } footer: {
                    Text("Version: 2.3.0(257)")
                        .fontWeight(.medium)
                        .padding(.top)
                }
            }
            .listStyle(.inset)
            .listSectionSeparator(.hidden, edges: .all)
            .environment(\.defaultMinListRowHeight, 55)
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationDestination(isPresented: $isShowStaticPage) {
            MoreListStaticPageView(pageName: selectedPageName)
        }
    }
    
    func tapCell(_ rowData: ProfileRowModel) {
        DispatchQueue.main.async {
            switch rowData.title {
            case "Language":
                print(rowData.title)
            case "Privacy Policy Statement":
                selectedPageName = rowData.title
            case "Terms and Conditions":
                selectedPageName = rowData.title
            case "License and Permit":
                selectedPageName = rowData.title
            case "Disclaimer":
                selectedPageName = rowData.title
            case "Explore city'super HK App":
                print(rowData.title)
            case "Explore city'super E-Shop Website":
                print(rowData.title)
            case "Terminate MemberShip":
                print(rowData.title)
            default:
                break
            }
            
        }
    }
}

#Preview {
    MoreListView()
}
