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

    var body: some View {
        NavigationView {
            Form {
                Toggle("显示农历2", isOn: $isShowChineseCalendar)
            }
            .navigationTitle("设置")
        }
    }
}
