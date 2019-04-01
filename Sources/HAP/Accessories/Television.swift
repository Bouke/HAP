extension Accessory {
    open class Television: Accessory {
        public let television = Service.Television()
        public let speaker: Service.SpeakerBase
        public var sources = [Service.InputSource]()

        public init(info: Service.Info, inputs: [(String, Enums.InputSourceType)], additionalServices: [Service] = []) {

            precondition(!inputs.isEmpty)
            var idx: UInt32 = 0
            for (name, type) in inputs {
                sources.append(Service.InputSource(identifier: idx, name: name, input: type))
                idx += 1
            }
            speaker = Service.TelevisionSpeaker(name: "\(info.name.value ?? "TV") Speaker")
            super.init(info: info,
                       type: .television,
                       services: ([television, speaker] + sources as [Service]) + additionalServices)

            television.configuredName.value = info.name.value
            television.activeIdentifier.value = sources[0].identifier?.value
            television.addLinkedService(speaker)

            for source in sources {
                television.addLinkedService(source)
            }
        }
    }
}

extension Service {
    open class Television: TelevisionBase {
        public init() {
            super.init(characteristics: [.powerModeSelection(), .remoteKey()])
            self.primary = true
            sleepDiscoveryMode.value = .alwaysdiscoverable
        }
    }
}

extension Service {
    open class InputSource: InputSourceBase {
        public init(identifier: UInt32, name: String, input: Enums.InputSourceType) {
            super.init(characteristics: [.identifier()])

            self.name.value = name.replacingOccurrences(of: " ", with: "")
            configuredName.value = name
            inputSourceType.value = input
            self.identifier?.value = identifier
            isConfigured.value = .configured
        }
    }
}

extension Service {
    open class TelevisionSpeaker: SpeakerBase {
        public init(name: String) {
            super.init(characteristics: [.active(), .volumeControlType(), .volumeSelector(), .volume(), .name(name)])
        }
    }
}
