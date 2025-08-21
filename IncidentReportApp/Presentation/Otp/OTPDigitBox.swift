//
//  OTPDigitBox.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//
import SwiftUI
struct OTPDigitBox: View {
    let digit: String
    let isActive: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isActive ? Color.blue : (digit.isEmpty ? Color.gray.opacity(0.3) : Color.blue),
                    lineWidth: isActive ? 2 : 1
                )
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(digit.isEmpty ? Color.clear : Color.blue.opacity(0.05))
                )
            
            Text(digit)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(digit.isEmpty ? .clear : .primary)
            
            // Cursor for active field
            if isActive && digit.isEmpty {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.blue)
                    .frame(width: 2, height: 24)
                    .opacity(0.7)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .animation(.easeInOut(duration: 0.2), value: digit)
    }
}
