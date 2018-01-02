import Vapor
import AuthProvider

struct MiddlewareConfigurator: Configurator {

  func configure(config: Config) throws {
    let authMiddleware = PasswordAuthenticationMiddleware(User.self)
    
    config.addConfigurable(middleware: authMiddleware, name: "auth")
  }
}
