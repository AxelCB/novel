import Vapor
import Fluent
import HTTP
import AuthProvider

public final class User: Model {

    public enum Key: String {
        case id
        case username
        case email
        case password
        case firstname
        case lastname
        case fullname
    }

    public enum Error: Swift.Error {
        case invalidUserType
    }
    
    public var validator: NodeValidator.Type? = UserValidator.self
    public var storage = Storage()
    
    public var entityName: String {
        return "users"
    }

    // Fields
    public var username: String
    public var email: String
    public var password: String?
    public var firstname: String
    public var lastname: String?

    public var fullname: String {
        return "\(firstname) \(lastname ?? "")"
    }

    //Initializer
    public init(username: String, email: String, firstname: String) {
        self.username = username
        self.email = email
        self.firstname = firstname
    }
    
    // MARK: - RowInitializable
    public init(row: Row) throws {
        username = try row.get(Key.username.value)
        email = try row.get(Key.email.value)
        password = try row.get(Key.password.value)
        firstname = try row.get(Key.firstname.value)
        lastname = try row.get(Key.lastname.value)
    }
        
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set(Key.username.value, username)
        try row.set(Key.email.value, email)
        try row.set(Key.password.value, password)
        try row.set(Key.firstname.value, firstname)
        try row.set(Key.lastname.value, lastname)
        return row
    }
    
    // MARK: - Preparation
    /// Prepares a table/collection in the database
    /// for storing Users
    public static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Key.username.value, length: 50, unique: true)
            builder.string(Key.email.value, length: 50, unique: true)
            builder.string(Key.password.value)
            builder.string(Key.firstname.value, length: 50)
            builder.string(Key.lastname.value, length: 50)
        }
    }
    
    // MARK: JSON
    
    // How the model converts from / to JSON.
    // For example when:
    //     - Creating a new User (POST /users)
    //     - Fetching a user (GET /users, GET /users/:id)
    //
    public convenience init(json: JSON) throws {
        try self.init(
            username: json.get(Key.username.value),
            email: json.get(Key.email.value),
            firstname: json.get(Key.firstname.value)
        )
        id = try json.get(Key.id.value)
        password = try json.get(Key.password.value)
        lastname = try json.get(Key.lastname.value)
    }
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Key.id.value, id)
        try json.set(Key.username.value, username)
        try json.set(Key.email.value, email)
        try json.set(Key.firstname.value, firstname)
        try json.set(Key.lastname.value, lastname)
        try json.set(Key.fullname.value, fullname)
        return json
    }
}

// MARK: HTTP

// This allows User models to be returned
// directly in route closures
extension User: ResponseRepresentable { }

// MARK: - Authentication
extension User: PasswordAuthenticatable {

  /**
    Authenticates the user with given credentials.
  */
  public static func authenticate(credentials: Credentials) throws -> Auth.User {
    var identity: User?

    switch credentials {
    // Tries to authenticate the user with username and password
    case let credentials as UsernamePassword:
      identity = try findIdentity(with: credentials)
    case let node as Node:
      guard let credentials = try? node.credentials() else { break }
      identity = try findIdentity(with: credentials)
    // Fetches the user by session ID
    case let credentials as Identifier:
      identity = try User.find(credentials.id)
    // Credentials type is not supported yet
    default:
      throw UnsupportedCredentialsError()
    }

    guard let user = identity else {
      throw IncorrectCredentialsError()
    }

    return user
  }

  /**
   Registers the user with credentials.
   */
  public static func register(credentials: Credentials) throws -> Auth.User {
    var user: User

    switch credentials {
    case let node as Node:
      user = try User(node: node)
      user.password = BCrypt.hash(password: user.password)
    default:
      throw UnsupportedCredentialsError()
    }

    guard try User.makeQuery().filter(Key.email.value, user.email).first() == nil else {
      throw AccountTakenError()
    }

    guard try User.makeQuery().filter(Key.username.value, user.username).first() == nil else {
      throw AccountTakenError()
    }

    try user.save()
    return user
  }

  public static func findIdentity(with credentials: UsernamePassword) throws -> User? {
    var user: User?

    if let foundUser = try User.query().filter(Key.email.value, credentials.username).first() {
      user = foundUser
    } else if let foundUser = try User.query().filter(Key.username.value, credentials.username).first() {
      user = foundUser
    }

    guard
      let identity = user,
      !identity.password.isEmpty,
      (try? BCrypt.verify(password: credentials.password, matchesHash: identity.password)) == true
      else {
        return nil
    }

    return user
  }
}

// MARK: - Request

extension Request {

  public func user() throws -> User {
    guard let user = try auth.assertAuthenticated() else {
      throw User.Error.invalidUserType
    }
    return user
  }
}

// MARK: - Node

extension Node: Credentials {

  fileprivate func credentials() throws -> UsernamePassword {
    return UsernamePassword(
      username: try extract(User.Key.username.value),
      password: try extract(User.Key.password.value)
    )
  }
}
