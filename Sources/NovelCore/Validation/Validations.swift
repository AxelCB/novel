import Foundation
import Vapor
import Validation

public struct NameValidation: Validator {
    public typealias Input = String
    public func validate(_ input: String) throws {
        let evaluation = OnlyAlphanumeric.self && Count.containedIn(low: 3, high: 50)
        try evaluation.validate(input: input)
    }
}

public struct FieldValidation: Validator {
    public typealias Input = Int

    public func validate(_ input: Int) throws {
        let kinds = FieldKind.all().map { $0.rawValue }
        try In(kinds).validate(input)
    }
}

public struct PasswordValidation: Validator {
    public typealias Input = String
    fileprivate let confirmation: String

    public init(confirmation: String) {
        self.confirmation = confirmation
    }

    public func validate(_ input: String) throws {
        let evaluation = Count<String>.containedIn(low: 7, high: 50)
        try evaluation.validate(input)

        if input != confirmation {
            throw error("Passwords don't match")
        }
    }
}
