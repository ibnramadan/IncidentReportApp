//
//  OTPInputField.swift
//  IncidentReportApp
//
//  Created by mohamed ramadan on 21/08/2025.
//
import SwiftUI
public struct OTPInputField: View {
    @Binding var otp: String
    let onOTPChange: (String) -> Void
    @FocusState private var isFieldFocused: Bool
    
    public init(otp: Binding<String>, onOTPChange: @escaping (String) -> Void, isFieldFocused: Bool) {
        self._otp = otp
        self.onOTPChange = onOTPChange
        self.isFieldFocused = isFieldFocused
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { index in
                    OTPDigitBox(
                        digit: digitAt(index: index),
                        isActive: isFieldFocused && index == otp.count
                    )
                }
            }
            
            // Hidden TextField for actual input
            TextField("", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFieldFocused)
                .onChange(of: otp) { oldValue, newValue in
                    // Filter to only numbers and limit to 4 digits
                    let filtered = String(newValue.filter { $0.isNumber }.prefix(4))
                    if filtered != newValue {
                        otp = filtered
                    }
                    onOTPChange(filtered)
                }
                .opacity(0)
                .frame(height: 1)
                .disabled(false)
        }
        .onTapGesture {
            isFieldFocused = true
        }
        .onAppear {
            // Auto-focus when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFieldFocused = true
            }
        }
    }
    
    private func digitAt(index: Int) -> String {
        guard index < otp.count else { return "" }
        return String(otp[otp.index(otp.startIndex, offsetBy: index)])
    }
}
