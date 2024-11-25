//
//  IntervalCalculatorView.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-25.
//
import SwiftUI
struct IntervalCalculatorView: View {
    @State private var startDateComponents: DateComponents
    @State private var endDateComponents: DateComponents
    @State private var intervalDays: Int? = nil // 计算间隔天数
    @Environment(\.presentationMode) private var presentationMode // 用于返回主界面

    init() {
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        _startDateComponents = State(initialValue: today) // 起始日期默认当天
        _endDateComponents = State(initialValue: today)   // 结束日期默认当天
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("选择日期范围")
                    .font(.headline)
                    .padding()

                // 起始日期选择器
                VStack(alignment: .leading, spacing: 10) {
                    Text("起始日期")
                        .font(.subheadline)
                        .bold()
                    DatePickerWheel(dateComponents: $startDateComponents)
                }

                // 结束日期选择器
                VStack(alignment: .leading, spacing: 10) {
                    Text("结束日期")
                        .font(.subheadline)
                        .bold()
                    DatePickerWheel(dateComponents: $endDateComponents)
                }

                Button(action: calculateIntervalDays) {
                    Text("计算日期间隔")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                if let intervalDays = intervalDays {
                    Text("日期间隔为 \(intervalDays) 天")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("日期间隔计算")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        presentationMode.wrappedValue.dismiss() // 返回主界面
                    }
                }
            }
        }
    }

    // 计算日期间隔的方法
    private func calculateIntervalDays() {
        let calendar = Calendar.current

        // 转换 DateComponents 为 Date
        if let startDate = calendar.date(from: startDateComponents),
           let endDate = calendar.date(from: endDateComponents) {
            let components = calendar.dateComponents([.day], from: startDate, to: endDate)
            intervalDays = components.day ?? 0
        }
    }
}

