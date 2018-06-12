# SwedishSSN

[![CI Status](https://img.shields.io/travis/diamantidis/SwedishSSN.svg?style=flat)](https://travis-ci.org/diamantidis/SwedishSSN)
[![Version](https://img.shields.io/cocoapods/v/SwedishSSN.svg?style=flat)](https://cocoapods.org/pods/SwedishSSN)
[![License](https://img.shields.io/cocoapods/l/SwedishSSN.svg?style=flat)](https://cocoapods.org/pods/SwedishSSN)
[![Platform](https://img.shields.io/cocoapods/p/SwedishSSN.svg?style=flat)](https://cocoapods.org/pods/SwedishSSN)
[![Swift](https://img.shields.io/badge/Swift-4.0-blue.svg)](https://swift.org)

A swift library to validate and extract information from a string that represents a Swedish Social Security Number.

## Requirements
- iOS 9.3+
- Xcode 9.3+
- Swift 4.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwedishSSN into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3'

target 'TargetName' do
    pod 'SwedishSSN'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage 

You can ``import SwedishSSN`` into your files

### Validate each case with `switch`

```swift

let ssn = "XXXXXX-XXXX"

switch SwedishSSN(ssn) {
case .personnummer(let gender):
    // Do something if it is a valid personnummer
case .samordningsnummer(let gender):
    // Do something if it is a valid samordningsnummer
case .organisationsnummer(let companyType):
    // Do something if it is a valid organisationsnummer
case .invalid:
    // Do something if it is an invalid ssn
}
```

### Validate one specific type with `guard case`

```swift
let ssn = "XXXXXX-XXXX"

guard case SwedishSSN.personnummer(let gender) = SwedishSSN(ssn) else {
    return false
}
```

### Validate one specific type with `if case`

```swift
let ssn = "XXXXXX-XXXX"

if case SwedishSSN.personnummer(let gender) = SwedishSSN(ssn) {
    // Do something if it is a valid personnummer
}
```

## Author

Ioannis Diamantidis, diamantidis@outlook.com

## License

SwedishSSN is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments

* https://fejk.se for the fake data :stuck_out_tongue_winking_eye:
