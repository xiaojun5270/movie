import SwiftUI

struct AppView: View {
  @EnvironmentObject private var session: AppSession

  var body: some View {
    Group {
      if session.isAuthenticated, session.isBootstrapping {
        ProgressView("恢复登录中…")
      } else if session.isAuthenticated {
        TabView {
          DashboardView()
            .tabItem {
              Label("首页", systemImage: "house")
            }

          SubscribeListView()
            .tabItem {
              Label("订阅", systemImage: "bookmark")
            }

          DownloadListView()
            .tabItem {
              Label("下载", systemImage: "arrow.down.circle")
            }

          if let api = session.api {
            MediaSearchView(api: api)
              .tabItem {
                Label("搜索", systemImage: "magnifyingglass")
              }
          }

          SettingsView()
            .tabItem {
              Label("设置", systemImage: "gearshape")
            }
        }
      } else {
        LoginView()
      }
    }
  }
}
