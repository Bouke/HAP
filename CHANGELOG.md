## [Unreleased]

### Added
- Additional accessory and service types.
- Support for Raspberry Pi / Raspbian Stretch.
- Services / Characteristics are now generated from Apple's Homekit framework
  on macOS. This means that those definitions are more easily kept up-to-date.
  Contribution by Guy Brooker.
- Television accessory support. Contribution by Guy Brooker.

### Changed
- Network stack rewritten with SwiftNIO.
- Naming of some service / characteristic / enum types.
- Characteristics with read permission (Paired Read) require a value, no value
  is no longer valid.

### Fixed
- Allow bridges with spaces in name.

## 0.5.0 - 2017-11-19

### Added
- Swift 4.
- Improved HAP specification conformity (notification coalescence, multiple
  status return codes).
- Additional builtin accessory and service types.

### Fixed
- Resolved issue with pairings not being removed.
