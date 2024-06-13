struct MessageBalloon: Tag {
    var x: Double
    var y: Double
    var received: Bool = true
    
    let dimensions = Traits.shared.dimensions
    var size: Double { dimensions.iconSize }
        
    var body: [any Tag] {
        Path()
            .d(MessageBalloonPathData(x: x, y: y, received: self.received))
            .stroke(color: self.received ? -"receivedBalloonColor" : -"sentBalloonColor")
            .stroke(width: 1)
            .fill(color: self.received ? -"receivedBalloonColor" : -"sentBalloonColor")
            .strokeLine(cap: "round")
            .strokeLine(join: "round")
    }
}
