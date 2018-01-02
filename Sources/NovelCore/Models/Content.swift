import Vapor
import Fluent

public final class Content: Model {
    
    public enum Key: String {
        case id
        case body
        case fieldId
        case entryId
    }
    
    public var storage = Storage()
    public var validator: NodeValidator.Type? = ContentValidator.self

    // Fields
    public var body: String

    // Relations
    public var fieldId: Identifier?
    public var entryId: Identifier?

    public func field() throws -> Parent<Content, Field> {
        return parent(id: fieldId)
    }

    public func set(field: Field) {
        fieldId = field.id
    }

    public func set(entry: Entry) {
        entryId = entry.id
    }
    
    public init(row: Row) throws {
        body = try row.get(Key.body.value)
        fieldId = try row.get(Key.fieldId.value)
        entryId = try row.get(Key.entryId.value)
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(Key.body.value, body)
        try row.set(Key.fieldId.value, fieldId)
        try row.set(Key.entryId.value, entryId)
        return row
    }
    
    public init(json: JSON) throws {
        body = try json.get(Key.body.value)
        fieldId = try json.get(Key.fieldId.value)
        entryId = try json.get(Key.entryId.value)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Key.body.value, body)
        try json.set(Key.fieldId.value, fieldId)
        try json.set(Key.entryId.value, entryId)
        return json
    }

    /**
    Preparation.
    */
    public static func prepare(_ database: Database) throws {
        try database.create(Content.self) { builder in
            builder.text(Key.body.snaked)
            builder.parent(Field.self, optional: false)
            builder.parent(Entry.self, optional: false)
        }
    }
}
