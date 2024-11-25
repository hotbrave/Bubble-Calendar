//
//  CountdownView.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-25.
//
import SwiftUI
struct CountdownView: View {
    @State private var targetDate = Date() // 用户选择的目标日期
    @State private var remainingDays: Int? = nil // 计算剩余天数

    var body: some View {
        NavigationView {
            VStack {
                Text("选择目标日期")
                    .font(.headline)
                    .padding()

                // 日期选择器
                DatePicker("目标日期", selection: $targetDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                Button(action: calculateRemainingDays) {
                    Text("计算倒计时")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if let remainingDays = remainingDays {
                    Text("距离目标日期还有 \(remainingDays) 天")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("日期倒计时")
        }
    }

    // 计算剩余天数的方法
    private func calculateRemainingDays() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: targetDate)

        if target >= today {
            let components = calendar.dateComponents([.day], from: today, to: target)
            remainingDays = components.day
        } else {
            remainingDays = 0 // 如果目标日期在今天之前，则显示 0 天
        }
    }
}
