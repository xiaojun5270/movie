import SwiftUI

struct SettingsView: View {
 @EnvironmentObject private var session: AppSession

 var body: some View {
 Form {
 Section("当前连接") {
 LabeledContent("服务器", value: session.serverURL.isEmpty ? "未配置" : session.serverURL)
 LabeledContent("用户", value: session.currentUser?.name ?? "未登录")
 LabeledContent("权限", value: session.currentUser?.isSuperuser == true ? "管理员" : "普通用户")
 }

 Section("说明") {
 Text("当前版本已打通登录、概览、订阅列表、下载列表。")
 Text("下一阶段补媒体搜索、详情页、创建订阅、基础设置。")
 }

 Section {
 Button(role: .destructive) {
 session.logout()
 } label: {
 Text("退出登录")
 }
 }
 }
 .navigationTitle("设置")
 }
}
