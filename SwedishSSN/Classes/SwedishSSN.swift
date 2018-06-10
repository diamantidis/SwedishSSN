import Foundation

public enum SwedishSSN {
    case personnummer(gender: Gender?)
    case samordningsnummer(gender: Gender?)
    case organisationsnummer(companyType: CompanyType)
    case invalid

    public enum CompanyType {
        case dödsbon
        case offentlig
        case utländskaFöretag
        case aktiebolag
        case enkeltbolag
        case ekonomiskFörening
        case ideellFörening
        case handelsKommanditBolag
        case invalid
    }

    public enum Gender {
        case male
        case female
    }

    enum Seperator: String {
        case plus = "+"
        case minus = "-"

        func equals(_ string: String) -> Bool {
            return self.rawValue == string
        }
    }

    public init(_ ssn: String) {
        // Default value. To avoid `'self' used before 'self.init' call or assignment to 'self'`
        self = .invalid

        guard let parts = getPNOParts(forSSN: ssn) else {
            self = .invalid
            return
        }

        var (century, year, month, day, seperator, number, checksum) = parts

        seperator = update(seperator: seperator, withCentury: century, withYear: year)
        century = update(century: century, withSeperator: seperator, withYear: year)

        guard isLuhnValid(number: "\(year)\(month)\(day)\(number)\(checksum)") else {
            self = .invalid
            return
        }

        if isPersonummerValid(century: century, year: year, month: month, day: day) {
            self = .personnummer(gender: getGender(for: number))
        } else if isSamordningsnummerValid(century: century, year: year, month: month, day: day) {
            self = .samordningsnummer(gender: getGender(for: number))
        } else if isOrganisationsnummer(month: month) {
            self = .organisationsnummer(companyType: getCompanyType(for: year))
        }
    }

    private typealias PNOPartsType = (
        century: String,
        year: String,
        month: String,
        day: String,
        seperator: String,
        num: String,
        checksum: String
    )

    private func getPNOParts(forSSN ssn: String) -> PNOPartsType? {

        let pattern = "^(\\d{2}){0,1}(\\d{2})(\\d{2})(\\d{2})([\\+\\-\\s]?)(\\d{3})(\\d)$"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let matches = regex.matches(in: ssn, range: NSRange(ssn.startIndex..., in: ssn))

        guard let match = matches.first else {
            return nil
        }
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else {
            return nil
        }

        let century = ssn.getValue(for: match.range(at: 1))
        let year = ssn.getValue(for: match.range(at: 2))
        let month = ssn.getValue(for: match.range(at: 3))
        let day = ssn.getValue(for: match.range(at: 4))
        let seperator = ssn.getValue(for: match.range(at: 5))
        let num = ssn.getValue(for: match.range(at: 6))
        let checksum = ssn.getValue(for: match.range(at: 7))

        return (
            century: century,
            year: year,
            month: month,
            day: day,
            seperator: seperator,
            num: num,
            checksum: checksum
        )
    }

    private func update(seperator: String, withCentury century: String, withYear year: String) -> String {
        var result = seperator
        seperatorCondition:
            if seperator.isEmpty || (Seperator.plus.equals(seperator) && Seperator.minus.equals(seperator)) {
            if century.isEmpty {
                result = Seperator.minus.rawValue
            } else {
                guard let century = Int(century), let year = Int(year) else {
                    break seperatorCondition
                }
                if currentYear - (century * 100 + year) < 100 {
                    result = Seperator.minus.rawValue
                } else {
                    result = Seperator.plus.rawValue
                }
            }
        }
        return result
    }

    private func update(century: String, withSeperator seperator: String, withYear year: String) -> String {

        var result = century
        centuryCondition: if century.isEmpty {
            var baseYear = currentYear - 100
            if seperator == Seperator.plus.rawValue {
                baseYear = currentYear - 200
            }
            guard let year = Int(year) else {
                break centuryCondition
            }
            result = String((100 + baseYear + (year - baseYear) % 100) / 100)
        }

        return result
    }

    private var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return year
    }

    private func isValidDate(century: String, year: String, month: String, day: String) -> Bool {
        var components = DateComponents()
        components.month = Int(month)
        components.year = Int("\(century)\(year)")
        components.day = Int(day)
        components.calendar = Calendar.current

        return components.isValidDate
    }

    private func isLuhnValid(number: String) -> Bool {
        var sum = 0
        let reversedCharacters = number.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {

            guard let digit = Int(element) else {
                return false
            }

            switch ((idx % 2 == 1), digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        return sum % 10 == 0
    }

    private func isPersonummerValid(century: String, year: String, month: String, day: String) -> Bool {
        return isValidDate(century: century, year: year, month: month, day: day)
    }

    private func isSamordningsnummerValid(century: String, year: String, month: String, day: String) -> Bool {

        guard let intDay = Int(day) else {
            return false
        }
        let actualDay = String(intDay - 60)
        return isValidDate(century: century, year: year, month: month, day: actualDay)
    }

    private func isOrganisationsnummer(month: String) -> Bool {
        guard let intMonth = Int(month) else {
            return false
        }
        return intMonth >= 20
    }

    private func getGender(for number: String) -> Gender? {
        guard let intNumber = Int(number) else {
            return nil
        }

        return intNumber % 2 == 0 ? .female : .male
    }

    private func getCompanyType(for number: String) -> CompanyType {

        let digit = number.first
        switch digit {
        case "1":
            return CompanyType.dödsbon
        case "2":
            return CompanyType.offentlig
        case "3":
            return CompanyType.utländskaFöretag
        case "5":
            return CompanyType.aktiebolag
        case "6":
            return CompanyType.enkeltbolag
        case "7":
            return CompanyType.ekonomiskFörening
        case "8":
            return CompanyType.ideellFörening
        case "9":
            return CompanyType.handelsKommanditBolag
        default:
            return .invalid
        }
    }
}

extension String {

    func getValue(for range: NSRange) -> String {
        if range.location == NSNotFound {
            return ""
        } else {
            return (self as NSString).substring(with: range)
        }
    }
}
