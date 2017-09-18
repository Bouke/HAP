
func root(device: Device) -> Application {
    return Router(routes: [
        ("/", { _,_  in Response(status: .ok, text: "Nothing to see here. Pair this Homekit Accessory with an iOS device.") }),
        ("/identify", identify(device: device)),
        ("/pair-setup", pairSetup(device: device)),
        ("/pair-verify", pairVerify(device: device)),
        ("/accessories", accessories(device: device)),
        ("/characteristics", characteristics(device: device)),
        ("/pairings", pairings(device: device))
    ]).application
}
