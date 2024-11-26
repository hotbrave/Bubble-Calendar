//
//  AddCountdownView.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-25.
//
import SwiftUI
struct AddCountdownView: View {
    @Environment(\.presentationMode) private var presentationMode // 返回日期倒计时界面的控制
    @State private var countdownName: String = "" // 倒计时名称
    @State private var targetDateComponents = DateComponents(year: 2024, month: 1, day: 1) // 默认倒计时日期
    let onSave: (String, Date) -> Void // 保存时的回调

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Form {
                    // 倒计时名称输入
                    Section(header: Text("倒计时名称")) {
                        TextField("请输入倒计时名称", text: $countdownName)
                    }

                    // 倒计时日期选择
                    Section(header: Text("选择日期")) {
                        DatePickerWheel(dateComponents: $targetDateComponents)
                    }
                }

                Spacer()
            }
            .navigationTitle("添加倒计时")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveCountdown()
                    }
                }
            }
        }
    }

    // 保存倒计时
    private func saveCountdown() {
        let calendar = Calendar.current

        // 转换日期组件为日期对象
        if let date = calendar.date(from: targetDateComponents), !countdownName.isEmpty {
            onSave(countdownName, date) // 回调保存
        }

        // 返回日期倒计时界面
        presentationMode.wrappedValue.dismiss()
    }
}
 
