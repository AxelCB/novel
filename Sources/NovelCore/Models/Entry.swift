import Foundation
import Vapor
import Fluent

public final class Entry: Model {
    
    public static var entityName: String {
        return "entries"
    }

    public enum Key: String {
        case id
        case title
        case publishedAt
        case prototypeId
    }
    
    public var storage = Storage()
    public var validator: NodeValidator.Type? = EntryValidator.self

    // Fields
    public var title: String
    public var publishedAt: Date

    // Relations
    public var prototypeId: Identifier?

    public func prototype() throws -> Parent<Entry, Prototype> {
        return parent(id: prototypeId)
    }

    public func set(prototype: Prototype) {
        prototypeId = prototype.id
    }

    public func contents() -> Children<Entry, Content> {
        return children()
    }
    
    public init(row: Row) throws {
        title = try row.get(Key.title.value)
        publishedAt = try row.get(Key.publishedAt.value)
        prototypeId = try row.get(Key.prototypeId.value)
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(Key.title.value, title)
        try row.set(Key.publishedAt.value, publishedAt)
        try row.set(Key.prototypeId.value, prototypeId)
        return row
    }
    
    public init(json: JSON) throws {
        title = try json.get(Key.title.value)
        publishedAt = try json.get(Key.publishedAt.value)
        prototypeId = try json.get(Key.prototypeId.value)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Key.title.value, title)
        try json.set(Key.publishedAt.value, publishedAt)
        try json.set(Key.prototypeId.value, prototypeId)
        return json
    }

    /**
    Preparation.
    */
    public static func prepare(_ database: Database) throws {
        try database.create(Entry.self) { (builder) in
            builder.string(Key.title.value, length: 100)
            builder.timestamp(Key.publishedAt.value)
            builder.parent(Prototype.self, optional: false)
        }
    }
}
