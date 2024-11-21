//
//  SettingsView.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-19.
//

import SwiftUI
// SettingsView: 设置界面
struct SettingsView: View {
    @Binding var isShowChineseCalendar: Bool
    @Binding var isPresented: Bool // **修改部分：通过绑定控制界面关闭**

    var body: some View {
        NavigationView { // **修改部分：添加导航栏**
            Form {
                Toggle("显示农历", isOn: $isShowChineseCalendar)
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // **修改部分：左上角添加返回按钮**
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        isPresented = false // 关闭设置界面
                    }
                }
            }
        }
    }
}


