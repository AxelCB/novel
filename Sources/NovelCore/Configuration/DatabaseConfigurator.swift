import Vapor
import Fluent
import PostgreSQLProvider

struct DatabaseConfigurator: Configurator {

  func configure(drop: Droplet) throws {
    try drop.addProvider(PostgreSQLProvider.Provider.self)
    drop.preparations = [
      Content.self,
      Entry.self,
      Field.self,
      Prototype.self,
      Session.self,
      Setting.self,
      User.self
    ]
  }
}
