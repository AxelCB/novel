import Vapor
import Fluent

public final class Session: Model {
    
    public enum Key: String {
        case id
        case token
        case userId
    }
    
    public var storage = Storage()
    public var validator: NodeValidator.Type?

    // Fields
    public var token: String

    // Relations
    public var userId: Identifier?

    public func user() throws -> Parent<Session, User> {
        return parent(id: userId)
    }

    public func set(user: User) {
        userId = user.id
    }
    
    public init(row: Row) throws {
        token = try row.get(Key.token.value)
        userId = try row.get(Key.userId.value)
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(Key.token.value, token)
        try row.set(Key.userId.value, userId)
        return row
    }
    
    public init(json: JSON) throws {
        token = try json.get(Key.token.value)
        userId = try json.get(Key.userId.value)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Key.token.value, token)
        try json.set(Key.userId.value, userId)
        return json
    }

    /**
     Preparation.
     */
    public static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Key.token.value, unique: true)
            builder.parent(User.self, optional: false)
        }
    }
}
