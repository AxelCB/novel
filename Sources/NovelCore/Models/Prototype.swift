import Vapor
import Fluent

public final class Prototype: Model {
    
    public enum Key: String {
        case id
        case name
        case handle
        case description
    }

    public var storage = Storage()
    public var validator: NodeValidator.Type? = PrototypeValidator.self
    
    // Fields
    public var name: String
    public var handle: String
    public var description: String?

    // Relations
    public func fields() -> Children<Prototype, Field> {
        return children()
    }

    public func entries() -> Children<Prototype, Entry> {
        return children()
    }
    
    public init(row: Row) throws {
        name = try row.get(Key.name.value)
        handle = try row.get(Key.handle.value)
        description = try row.get(Key.description.value)
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(Key.name.value, name)
        try row.set(Key.handle.value, handle)
        try row.set(Key.description.value, description)
        return row
    }
    
    public init(json: JSON) throws {
        name = try json.get(Key.name.value)
        handle = try json.get(Key.handle.value)
        description = try json.get(Key.description.value)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Key.name.value, name)
        try json.set(Key.handle.value, handle)
        try json.set(Key.description.value, description)
        return json
    }

  /**
   Preparation.
   */
    public static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Key.name.value, length: 50)
            builder.string(Key.handle.value, length: 50, unique: true)
            builder.string(Key.description.value)
        }
    }
}

// MARK: - Helpers

extension Prototype {


  public static func find(handle: String) throws -> Prototype? {
    return try Prototype.makeQuery().filter(Prototype.Key.handle.value, handle).first()
  }
}
