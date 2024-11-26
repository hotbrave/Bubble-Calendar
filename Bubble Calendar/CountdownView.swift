//
//  CountdownView.swift
//  Bubble Calendar
//
//  Created by Ethan on 2024-11-25.
//
import SwiftUI

struct CountdownView: View {
    @State private var countdowns: [Countdown] = [] // 倒计时列表
    @State private var isAddCountdownPresented = false // 是否展示添加倒计时界面
    @Environment(\.presentationMode) private var presentationMode // 返回主界面的控制
    private let storage = CountdownStorage() // 倒计时存储管理器

    var body: some View {
        NavigationView {
            VStack {
                if countdowns.isEmpty {
                    Text("暂无倒计时")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(countdowns) { countdown in
                            HStack {
                                Text("\(countdown.name)")
                                    .font(.headline)
                                    .foregroundColor(textColor(for: countdown.targetDate))
                                Spacer()
                                Text(displayText(for: countdown.targetDate))
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(rowBackgroundColor(for: countdown.targetDate))
                            .cornerRadius(10)
                        }
                        .onDelete(perform: deleteCountdown) // 添加删除功能
                    }
                }
                Spacer()
            }
            .navigationTitle("日期倒计时")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddCountdownPresented = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear(perform: loadCountdowns) // 加载倒计时
            .sheet(isPresented: $isAddCountdownPresented) {
                AddCountdownView { name, date in
                    addCountdown(name: name, date: date)
                }
            }
        }
    }

    // 计算剩余天数
    private func daysRemaining(until date: Date) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: today, to: target)
        return max(components.day ?? 0, 0)
    }
    
    // 显示倒计时文本
    private func displayText(for date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: today, to: target)

        if let days = components.day {
            if days >= 0 {
                return "还有 \(days) 天"
            } else {
                return "已经 \(abs(days)) 天"
            }
        }
        return ""
    }

    // 返回文字颜色
    private func textColor(for date: Date) -> Color {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)

        if target < today {
            return .gray // 过去的日期
        } else if target == today {
            return .blue // 今天的日期
        } else {
            return .green // 将来的日期
        }
    }

    // 返回行背景颜色
    private func rowBackgroundColor(for date: Date) -> Color {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)

        if target < today {
            return Color.gray.opacity(0.2) // 过去的日期
        } else if target == today {
            return Color.blue.opacity(0.2) // 今天的日期
        } else {
            return Color.green.opacity(0.2) // 将来的日期
        }
    }
    
    // 添加倒计时
    private func addCountdown(name: String, date: Date) {
        let countdown = Countdown(name: name, targetDate: date)
        countdowns.insert(countdown, at: 0) // 添加到列表顶部
        saveCountdowns()
    }
    
    // 删除倒计时
    private func deleteCountdown(at offsets: IndexSet) {
        countdowns.remove(atOffsets: offsets) // 从列表中删除
        saveCountdowns() // 保存更新后的列表
    }
    
    // 保存倒计时
    private func saveCountdowns() {
        storage.save(countdowns)
    }

    // 加载倒计时
    private func loadCountdowns() {
        countdowns = storage.load()
    }
}

struct Countdown: Codable, Identifiable {
    let id: UUID = UUID() // 每个倒计时的唯一标识符
    let name: String // 倒计时名称
    let targetDate: Date // 倒计时目标日期
}

class CountdownStorage {
    private let storageKey = "Countdowns"

    // 保存倒计时列表到 UserDefaults
    func save(_ countdowns: [Countdown]) {
        if let encoded = try? JSONEncoder().encode(countdowns) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    // 从 UserDefaults 加载倒计时列表
    func load() -> [Countdown] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Countdown].self, from: data) {
            return decoded
        }
        return []
    }
}

