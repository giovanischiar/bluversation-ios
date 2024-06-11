struct IconForeground: Foregroundable {
    let dimensions = Traits.shared.dimensions
    var size: Double { dimensions.iconSize }

    var foreground: Foreground {
        Foreground(size: size) {
            Div {

            }
            .position(x: 0, y: 0)
            .dimension(width: 50, height: 50)
            .stroke(color:  "#000000")
            .stroke(width: 2)
        }
    }
}
