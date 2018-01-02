import Foundation
import Vapor
import Fluent

public final class Setting: Model {
    
    public enum General: String {
        case siteName
        case siteUrl

        public var title: String {
            let result: String
            switch self {
            case .siteName:
                result = "Site name"
            case .siteUrl:
                result = "Site URL"
            }
            return result
        }
    }

    public enum Key: String {
        case id
        case name
        case handle
        case value
    }
    
    public var storage = Storage()
    public var validator: NodeValidator.Type? = SettingValidator.self

    // Fields
    public var name: String
    public var handle: String
    public var value: String
    
    public init(name: String, handle: String, value: String) {
        self.name = name
        self.handle = handle
        self.value = value
    }
    
    public init(row: Row) throws {
        name = try row.get(Key.name.value)
        handle = try row.get(Key.handle.value)
        value = try row.get(Key.value.value)
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(Key.name.value, name)
        try row.set(Key.handle.value, handle)
        try row.set(Key.value.value, value)
        return row
    }
    
    public static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Key.name.value, length: 50)
            builder.string(Key.handle.value, length: 50, unique: true)
            builder.string(Key.value.value)
        }
    }
    
    public convenience init(json: JSON) throws {
        try self.init(
            name: json.get(Key.name.value),
            handle: json.get(Key.handle.value),
            value: json.get(Key.value.value)
        )
        id = try json.get(Key.id.value)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Key.id.value, id)
        try json.set(Key.name.value, name)
        try json.set(Key.handle.value, handle)
        try json.set(Key.value.value, value)
        return json
    }
}

// MARK: - Helpers

extension Setting {

  /*
 public static func new() throws -> Setting {
    let node = try Node(node: [])
    return try Setting(node: node)
  }*/
}
