//
//  DatePickerSheet.swift
//  DesignSystem
//
//  Created by mohamed ramadan on 22/08/2025.
//

import SwiftUI

// MARK: - Date Picker Sheet Component
public struct DSDatePickerSheet: View {
    private let title: String
    private let selection: Binding<Date>
    private let range: Any?
    private let onDone: () -> Void
    private let onCancel: () -> Void
    
    public init(
        title: String,
        selection: Binding<Date>,
        range: Any? = nil,
        onDone: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.selection = selection
        self.range = range
        self.onDone = onDone
        self.onCancel = onCancel
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                datePickerView
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDone()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var datePickerView: some View {
        if let startRange = range as? PartialRangeFrom<Date> {
            DatePicker(
                "",
                selection: selection,
                in: startRange,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
        } else if let endRange = range as? PartialRangeThrough<Date> {
            DatePicker(
                "",
                selection: selection,
                in: endRange,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
        } else if let closedRange = range as? ClosedRange<Date> {
            DatePicker(
                "",
                selection: selection,
                in: closedRange,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
        } else {
            DatePicker(
                "",
                selection: selection,
                in: Date.distantPast...Date.distantFuture,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
        }
    }
}

// MARK: - View Extension
public extension View {
    func dsDatePickerSheet(
        title: String,
        selection: Binding<Date>,
        range: Any? = nil,
        onDone: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> some View {
        DSDatePickerSheet(
            title: title,
            selection: selection,
            range: range,
            onDone: onDone,
            onCancel: onCancel
        )
    }
}

// MARK: - Preview
#Preview {
    DSDatePickerSheet(
        title: "Select Date",
        selection: .constant(Date()),
        onDone: {},
        onCancel: {}
    )
} 