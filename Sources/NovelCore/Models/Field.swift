import Vapor
import Fluent

public final class Field: Model {

    public enum Key: String {
        case id
        case kind
        case name
        case handle
        case isRequired
        case minLength
        case maxLength
        case prototypeId
    }
    
    public var storage = Storage()
    public var validator: NodeValidator.Type? = FieldValidator.self

    // Fields
    public var kind: Int
    public var name: String
    public var handle: String
    public var isRequired: Bool
    public var minLength: Int?
    public var maxLength: Int?

    // Relations
    public var prototypeId: Identifier?

    public func prototype() throws -> Parent<Field, Prototype> {
        return parent(id: prototypeId)
    }

    public func set(prototype: Prototype) {
        prototypeId = prototype.id
    }
    
    public init(row: Row) throws {
        kind = try row.get(Key.kind.value)
        name = try row.get(Key.name.value)
        handle = try row.get(Key.handle.value)
        isRequired = try row.get(Key.isRequired.value)
        minLength = try row.get(Key.minLength.value)
        maxLength = try row.get(Key.maxLength.value)
        prototypeId = try row.get(Key.prototypeId.value)
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(Key.kind.value, kind)
        try row.set(Key.name.value, name)
        try row.set(Key.handle.value, handle)
        try row.set(Key.isRequired.value, isRequired)
        try row.set(Key.minLength.value, minLength)
        try row.set(Key.maxLength.value, maxLength)
        try row.set(Key.prototypeId.value, prototypeId)
        return row
    }
    
    public init(json: JSON) throws {
        kind = try json.get(Key.kind.value)
        name = try json.get(Key.name.value)
        handle = try json.get(Key.handle.value)
        isRequired = try json.get(Key.isRequired.value)
        minLength = try json.get(Key.minLength.value)
        maxLength = try json.get(Key.maxLength.value)
        prototypeId = try json.get(Key.prototypeId.value)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Key.kind.value, kind)
        try json.set(Key.name.value, name)
        try json.set(Key.handle.value, handle)
        try json.set(Key.isRequired.value, isRequired)
        try json.set(Key.minLength.value, minLength)
        try json.set(Key.maxLength.value, maxLength)
        try json.set(Key.prototypeId.value, prototypeId)
        return json
    }

    /**
    Preparation.
    */
    public static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.int(Key.kind.value)
            builder.string(Key.name.value, length: 50)
            builder.string(Key.handle.value, length: 50)
            builder.bool(Key.isRequired.value, default: false)
            builder.int(Key.minLength.value, optional: true)
            builder.int(Key.maxLength.value, optional: true)
            builder.parent(Prototype.self, optional: false)
        }
    }
}
