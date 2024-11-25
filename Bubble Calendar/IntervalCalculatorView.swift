//
//  IntervalCalculatorView.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-25.
//
import SwiftUI
struct IntervalCalculatorView: View {
    @State private var startDate = Date() // 用户选择的起始日期
    @State private var endDate = Date() // 用户选择的结束日期
    @State private var intervalDays: Int? = nil // 计算间隔天数

    var body: some View {
        NavigationView {
            VStack {
                Text("选择日期范围")
                    .font(.headline)
                    .padding()

                // 起始日期选择器
                DatePicker("起始日期", selection: $startDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                // 结束日期选择器
                DatePicker("结束日期", selection: $endDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                Button(action: calculateIntervalDays) {
                    Text("计算日期间隔")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if let intervalDays = intervalDays {
                    Text("日期间隔为 \(intervalDays) 天")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("日期间隔计算")
        }
    }

    // 计算日期间隔的方法
    private func calculateIntervalDays() {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)

        let components = calendar.dateComponents([.day], from: start, to: end)
        intervalDays = components.day ?? 0
    }
}
