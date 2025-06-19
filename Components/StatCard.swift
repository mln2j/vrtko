//
//  StatCard.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 19.06.2025..
//


import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Group {
                if icon.unicodeScalars.first?.properties.isEmoji == true {
                    Text(icon)
                        .font(.system(size: 24))
                        .frame(height: 28) // Fiksna visina za emoji
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                        .frame(height: 28)
                }
            }

            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("vrtkoPrimaryText"))

            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Color("vrtkoSecondaryText"))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding(.vertical, 16)
        .background(Color("vrtkoGrayBackground"))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}
