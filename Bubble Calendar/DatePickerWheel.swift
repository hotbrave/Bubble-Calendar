//
//  DatePickerWheel.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-25.
//
import SwiftUI
struct DatePickerWheel: View {
    @Binding var dateComponents: DateComponents

    var body: some View {
        HStack {
            // 年份滚轮
            Picker("年份", selection: $dateComponents.year) {
                ForEach(1900...2100, id: \.self) { year in
                    Text("\(year) 年").tag(year)
                }
            }
            .frame(width: 100)
            .clipped()
            .pickerStyle(WheelPickerStyle())

            // 月份滚轮
            Picker("月份", selection: $dateComponents.month) {
                ForEach(1...12, id: \.self) { month in
                    Text("\(month) 月").tag(month)
                }
            }
            .frame(width: 80)
            .clipped()
            .pickerStyle(WheelPickerStyle())

            // 日期滚轮
            Picker("日期", selection: $dateComponents.day) {
                ForEach(1...31, id: \.self) { day in
                    Text("\(day) 日").tag(day)
                }
            }
            .frame(width: 80)
            .clipped()
            .pickerStyle(WheelPickerStyle())
        }
    }
}

