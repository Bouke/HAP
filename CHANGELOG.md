## 0.6.0 - 2019-08-31

### Added
- Additional accessory and service types.
- Support for Raspberry Pi / Raspbian Stretch.
- Services / Characteristics are now generated from Apple's Homekit framework
  on macOS. This means that those definitions are more easily kept up-to-date.
  Contribution by Guy Brooker.
- Television accessory support. Contribution by Guy Brooker.
- Swift 5 support.

### Changed
- Network stack rewritten with SwiftNIO.
- Naming of some service / characteristic / enum types.
- Characteristics with read permission (Paired Read) require a value, no value
  is no longer valid.
- Characteristic bounds no longer trap when out of bound values are set
  programmatically, but will clip the value instead. This resolves an issue
  where setting a value to the minimum value would trap in some situations.

### Fixed
- Allow bridges with spaces in name.

### Removed
- Swift 4 support.

## 0.5.0 - 2017-11-19

### Added
- Swift 4 support.
- Improved HAP specification conformity (notification coalescence, multiple
  status return codes).
- Additional builtin accessory and service types.

### Fixed
- Resolved issue with pairings not being removed.
