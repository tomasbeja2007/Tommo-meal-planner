import SwiftUI

struct CookTimePicker: View {
    @Binding var maxMinutes: Int
    var onPick: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            ForEach(CookTimeOption.allCases) { option in
                OptionTile(
                    title: option.title,
                    subtitle: option.subtitle,
                    systemImage: option.systemImage,
                    isSelected: maxMinutes == option.rawValue
                ) {
                    maxMinutes = option.rawValue
                    onPick?()
                }
            }
        }
    }
}

#Preview {
    CookTimePicker(maxMinutes: .constant(30)).padding().creamBackground()
}
