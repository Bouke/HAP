public extension Enums {
	enum ProgramMode: UInt8, CharacteristicValueType {
		case noProgramsScheduled = 0
		case programsScheduled = 1
		case manualOverride = 2
	}
}
