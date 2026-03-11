import SwiftUI

struct MetricCardView: View {
 let title: String
 let value: String
 let icon: String
 let tint: Color

 var body: some View {
 VStack(alignment: .leading, spacing:10) {
 Image(systemName: icon)
 .font(.title2)
 .foregroundStyle(tint)
 Text(title)
 .font(.subheadline)
 .foregroundStyle(.secondary)
 Text(value)
 .font(.title2.bold())
 .foregroundStyle(.primary)
 }
 .frame(maxWidth: .infinity, alignment: .leading)
 .padding()
 .background(.ultraThinMaterial)
 .clipShape(RoundedRectangle(cornerRadius:16, style: .continuous))
 }
}
