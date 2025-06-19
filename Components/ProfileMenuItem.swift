//
//  ProfileMenuItem.swift
//  Vrtko
//
//  Created by Mihael Lendvaj on 19.06.2025..
//


import SwiftUI

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    var textColor: Color = Color.primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(Color("vrtkoPrimary"))
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(textColor)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
