import SwiftUI

@main
struct MoviePilotApp: App {
 @StateObject private var session = AppSession()

 var body: some Scene {
 WindowGroup {
 AppView()
 .environmentObject(session)
 .task {
 await session.bootstrap()
 }
 }
 }
}
