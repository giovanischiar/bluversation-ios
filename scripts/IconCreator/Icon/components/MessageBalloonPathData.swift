struct MessageBalloonPathData : PathDatable {
    var commands: [PathDataCommand]
    
    init (x: Double = 0, y: Double = 0, received: Bool = true) {
        var commandString = ""
        switch(received) {
            case false: commandString = "M 0.028871391 18.10105 l 9.0 -1.4986877 l 30.249342 0.12598419 l 0 -16.687664 l -37.81365 0.060367454 l 0 10.251969 z"
            case true: commandString = "M 39.278214 0.040682416 l -8.999998 1.4986876 l -30.249344 -0.12598419 l 0 16.687664 l 37.81365 -0.060367584 l 0 -10.251968 z"
        }
        commands = commandString.commands
        commands.move(x: x, y: y)
    }
}
