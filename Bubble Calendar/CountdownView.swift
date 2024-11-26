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
                                Spacer()
                                Text("还有 \(daysRemaining(until: countdown.targetDate)) 天")
                                    .foregroundColor(.blue)
                            }
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

