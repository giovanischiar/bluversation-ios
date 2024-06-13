struct IconForeground: Foregroundable {
    let dimensions = Traits.shared.dimensions
    var size: Double { dimensions.iconSize }

    var foreground: Foreground {
        Foreground(size: size) {
            Div {
                MessageBalloon(x: -27.2, y: 2, received: false)
                MessageBalloon(x: -12, y: -22)
            }
            .position(x: 0, y: 0)
        }
    }
}
