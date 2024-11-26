//
//  AddCountdownView.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-25.
//
import SwiftUI

struct AddCountdownView: View {
    @Environment(\.presentationMode) private var presentationMode // 返回日期倒计时界面的控制
    @State private var countdownName: String = "默认倒计时" // 倒计时名称，默认值
    @State private var targetDateComponents: DateComponents // 默认倒计时日期
    @State private var isEditing: Bool = false // 标记是否正在编辑名称
    let onSave: (String, Date) -> Void // 保存时的回调

    init(onSave: @escaping (String, Date) -> Void) {
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        _targetDateComponents = State(initialValue: todayComponents) // 默认目标日期为当天
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Form {
                    // 倒计时名称输入
                    Section(header: Text("倒计时名称")) {
                        TextField("请输入倒计时名称", text: $countdownName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onTapGesture {
                                if !isEditing {
                                    countdownName = "" // 第一次点击清空默认值
                                    isEditing = true
                                }
                            }
                    }

                    // 倒计时日期选择
                    Section(header: Text("选择日期")) {
                        DatePickerWheel(dateComponents: $targetDateComponents)
                    }
                }
                .onTapGesture {
                    hideKeyboard() // 点击空白区域隐藏键盘
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
                    .disabled(countdownName.isEmpty) // 禁用按钮如果名称为空
                }
            }
        }
    }

    // 保存倒计时
    private func saveCountdown() {
        let calendar = Calendar.current

        // 转换日期组件为日期对象
        if let date = calendar.date(from: targetDateComponents) {
            let finalName = countdownName.isEmpty ? "默认倒计时" : countdownName
            onSave(finalName, date) // 回调保存
        }

        // 返回日期倒计时界面
        presentationMode.wrappedValue.dismiss()
    }

    // 隐藏键盘
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

 
