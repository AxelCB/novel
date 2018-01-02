import Vapor
import Fluent
import PostgreSQLProvider

struct DatabaseConfigurator: Configurator {

  func configure(config: Config) throws {
    try config.addProvider(PostgreSQLProvider.Provider.self)
    config.preparations = [
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
