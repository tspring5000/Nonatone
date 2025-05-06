import SwiftUI

// ----- Composition
struct BackgroundRect: View {
    @Binding var height: CGFloat
    
    var body: some View {
        Rectangle()
            .background(
                GeometryReader { proxy in Color.clear
                    .onAppear() {height = proxy.size.height}
                    .onChange(of: proxy.size) { sz in
                        height = sz.height
                    }
                }
            )
    }
}

struct ForegroundRect: View {
    @Binding var height: CGFloat
    @Binding var value: Float
    
    var body: some View {
        Rectangle()
            .frame(height: CGFloat(value) * height)
    }
}

struct BoxMod: ViewModifier {
    @State private var startingValue: Float = 0.0
    @Binding var value: Float
    @Binding var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .gesture(
                LongPressGesture(minimumDuration: 0)
                    .onEnded { _ in
                        self.startingValue = self.value
                    }
                .sequenced(before: DragGesture(minimumDistance: 0)
                .onChanged({ v in
                    let t = self.startingValue - Float((v.location.y - v.startLocation.y) / height)
                    self.value = min(max(0.0, t), 1.0)
                }))
            )
            .clipShape(RoundedRectangle(cornerRadius: height / 20))
            .animation(.bouncy, value: value)    }
}

struct foregroundTint: ViewModifier {
    var colour: Color
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .foregroundStyle(colour)
        } else {
            content
                .foregroundColor(colour)
        }
    }
}

// ----- Actual views
struct BoxSlider: View {
    @Binding var value: Float
    @State private var height = CGFloat(0)
    @State private var colour: Color
    
    init(value: Binding<Float>, col: Color) {
        self._value = value
        self.colour = col
    }
    
    var body: some View {
        BackgroundRect(height: $height)
            .modifier(foregroundTint(colour: value <= 0.0 ? .gray.opacity(0.2) : colour.opacity(0.8)))
        .overlay(
            ForegroundRect(height: $height, value: $value)
                .modifier(foregroundTint(colour: .white.opacity(0.5))),
            alignment: .bottom
        )
        .modifier(BoxMod(value: $value, height: $height))
    }
}

// ----- Preview
struct BoxSliderPreview: View {
    @State private var sliderVal: Float = 0.5
    
    var body: some View {
        HStack {
            BoxSlider(value: $sliderVal, col: .orange)
            BoxSlider(value: $sliderVal, col: .red)
        }
        .padding()
    }
}

#Preview {
    BoxSliderPreview()
}
