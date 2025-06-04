//
//  CustomTabBar.swift
//  Maknoon
//
//  Created by Mahmoud Diab on 04/06/2025.
//

import SwiftUI

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: QuranReaderView.Tab
    let theme: QuranTheme
    
    var body: some View {
        HStack(spacing: 20) {
            TabButton(
                title: "قراءة عادية",
                isSelected: selectedTab == .quran,
                theme: theme
            ) {
                withAnimation {
                    selectedTab = .quran
                }
            }
            
            TabButton(
                title: "قراءة تفاعلية",
                isSelected: selectedTab == .empty,
                theme: theme
            ) {
                withAnimation {
                    selectedTab = .empty
                }
            }
        }
        .padding(.horizontal,0)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let theme: QuranTheme
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 5) {
                Spacer()
                Image(isSelected ? AppAssets.Icons.bookEnabled : AppAssets.Icons.bookDisabled)
                
                Text(title)
                    .font(.custom("IBM Plex Sans Arabic", size: 14))
                    .foregroundColor(isSelected ? Color(red: 231/255, green: 182/255, blue: 102/255) : Color(red: 83/255, green: 106/255, blue: 123/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                Spacer()
            }.background(
                VStack {
                    Spacer()
                    if isSelected {
                        Rectangle()
                            .fill(Color(red: 231/255, green: 182/255, blue: 102/255))
                            .frame(height: 3)
                            .clipShape(
                                RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
                            )
                    }
                }
            )
        }
        .frame(width: 127)
    }
}
