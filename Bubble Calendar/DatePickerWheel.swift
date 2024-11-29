import SwiftUI

struct DatePickerWheel: View {
    @Binding var dateComponents: DateComponents

    var body: some View {
        HStack {
            // 月份滚轮
            Picker("Month", selection: $dateComponents.month) {
                ForEach(1...12, id: \.self) { month in
                    Text(Calendar.current.monthSymbols[month - 1]).tag(month) // 使用英文月份名称
                }
            }
            .frame(width: 140) // 增加宽度
            .clipped()
            .pickerStyle(WheelPickerStyle())

            // 日期滚轮
            Picker("Day", selection: $dateComponents.day) {
                ForEach(1...31, id: \.self) { day in
                    Text("\(day)").tag(day)
                }
            }
            .frame(width: 80)
            .clipped()
            .pickerStyle(WheelPickerStyle())

            // 年份滚轮
            Picker("Year", selection: $dateComponents.year) {
                ForEach(1900...2100, id: \.self) { year in
                    Text("\(year)").tag(year)
                }
            }
            .frame(width: 100)
            .clipped()
            .pickerStyle(WheelPickerStyle())
        }
    }
}
