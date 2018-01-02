import Foundation
import Vapor
import FluentProvider

public protocol Model: FluentProvider.Model, Preparation, Timestampable, SoftDeletable, JSONConvertible {
    static var entityName: String { get }
    static var entity: String { get }
    // Validation
    var validator: NodeValidator.Type? { get set }
}

// MARK: - Helpers

extension Model {
    public static var entityName: String {
        return name + "s"
    }
    
    public static var entity: String {
        return entityName
    }

    // Validation
    /*
    public func validate() throws {
        guard let Validator = self.validator else {
          return
        }

        let node = try makeNode()
        let validator = Validator.init(node: node)

        if !validator.isValid {
          throw InputError(data: node, errors: validator.errors)
        }
    }

    //
    public func updated(from node: Node, exists: Bool = false) throws -> Self {
        var updatedNode = try makeNode(context: EmptyNode)
        updatedNode.merge(with: node)

        let model = try type(of: self).init(node: updatedNode, in: EmptyNode)
        model.exists = exists

        return model
    }
    */
    
    // Database/ Fluent
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}


/*
 ESTO VA SEGURO

 
 enum ModelError: Error {
 case methodNotImplemented
 }
 
 enum Required: String {
 case id
 case createdAt
 case updatedAt
 }
 
 */


/*
 
 ESTO NO SE NI QUE HACE
 
 var storage: Storage = Storage()
 // Validation
 var validator: NodeValidator.Type?
 
 /**
 Fluent serialization.
 */
 public func makeNode(context: Context) throws -> Node {
 var node = try Node(node: [
 Required.id.value: id,
 Required.createdAt.value: createdAt.iso8601,
 Required.updatedAt.value: updatedAt.iso8601,
 ])
 
 node.merge(with: try makeNode())
 
 return node
 }
 
 public func makeNode() throws -> Node {
 return try Node(node: [])
 }
 
 // MARK: - Preparations
 
 public static func prepare(_ database: Database) throws {
 try database.create(entityName) { schema in
 try self.prepare(schema: schema)
 try self.create(schema: schema)
 }
 }
 
 public static func revert(_ database: Database) throws {
 try database.delete(entityName)
 }
 
 public class func create(schema: Schema.Creator) throws {
 throw ModelError.createNotImplemented
 }
 
 */
