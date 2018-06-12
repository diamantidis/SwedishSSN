import SwedishSSN
import XCTest

class Tests: XCTestCase {

    func testInvalidPNO() {
        let listOfPersonnummers: [String] = [
            "a",                    // Random 1 letter
            "abcdefghijkl",         // Random 12 letters
            "1",                    // Random 1 digit
            "123456789012",         // Random 12 digits
            "19811228*9874",        // Invalid seperator
            "811228-9875",          // Invalid checksum
            "671919-9534",          // Invalid month
            "1202301212"            // Invalid date
        ]

        for personnummer in listOfPersonnummers {
            XCTAssert(isInvalid(personnummer: personnummer), "Number \(personnummer) is not invalid")
        }
    }

    func testValidPersonummer() {
        let listOfPersonnummers: [(personnummer: String, gender: SwedishSSN.Gender)] = [
            ("201212121212", .male),
            ("191212121212", .male),
            ("1212121212", .male),
            ("121212-1212", .male),
            ("121212+1212", .male),
            ("780428-7527", .female),
            ("570129+2863", .female),
            ("197502132454", .male),
            ("189203184677", .male),
            ("19870321-5965", .female)
        ]

        for item in listOfPersonnummers {
            XCTAssert(
                isPersonnummer(personnummer: item.personnummer, with: item.gender),
                "Number \(item.personnummer) is not personummer"
            )
        }
    }

    func testValidSamordningsnummer() {

        let listOfSamordningsnummers: [(samordningsnummer: String, gender: SwedishSSN.Gender)] = [
            ("201212721219", .male),
            ("191212721219", .male),
            ("1212621211", .male),
            ("121262-1211", .male),
            ("121272+1219", .male),
            ("660567-2770", .male),
            ("961264+8445", .female),
            ("190406778167", .female),
            ("195405780486", .female),
            ("19820175-0836", .male)
        ]
        for item in listOfSamordningsnummers {
            XCTAssert(
                isSamordningsnummer(samordningsnummer: item.samordningsnummer, with: item.gender),
                "Number \(item.samordningsnummer) is not samordningsnummer"
            )
        }
    }

    func testValidOrganisationsnummer() {
        let listOfOrganisationsnummers: [(organisationsnummer: String, type: SwedishSSN.CompanyType)] = [
            ("122122-1144", .dödsbon),
            ("212000-0142", .offentlig),
            ("312122-1141", .utländskaFöretag),
            ("556784-3445", .aktiebolag),
            ("502032-9081", .aktiebolag),
            ("6121063959", .enkeltbolag),
            ("717905-2969", .ekonomiskFörening),
            ("884400-1381", .ideellFörening),
            ("802005-4691", .ideellFörening),
            ("969719-5593", .handelsKommanditBolag)
        ]

        for item in listOfOrganisationsnummers {
            XCTAssert(
                isOrganisationsnummer(organisationsnummer: item.organisationsnummer, with: item.type),
                "Number \(item.organisationsnummer) is not organisationsnummer"
            )
        }
    }

    private func isInvalid(personnummer: String) -> Bool {
        if case SwedishSSN.invalid = SwedishSSN(personnummer) {
            return true
        } else {
            return false
        }
    }

    private func isPersonnummer(personnummer: String, with expectedGender: SwedishSSN.Gender) -> Bool {
        guard case SwedishSSN.personnummer(let actualGender) = SwedishSSN(personnummer) else {
            return false
        }
        return actualGender == expectedGender
    }

    private func isSamordningsnummer(samordningsnummer: String, with expectedGender: SwedishSSN.Gender) -> Bool {
        guard case SwedishSSN.samordningsnummer(let actualGender) = SwedishSSN(samordningsnummer) else {
            return false
        }
        return actualGender == expectedGender
    }

    private func isOrganisationsnummer(organisationsnummer: String, with expectedType: SwedishSSN.CompanyType) -> Bool {
        guard case SwedishSSN.organisationsnummer(let actualType) = SwedishSSN(organisationsnummer) else {
            return false
        }
        return actualType == expectedType
    }
}
