import Vapor
import AuthProvider

struct MiddlewareConfigurator: Configurator {

  func configure(drop: Droplet) throws {
    let cache = SessionCache()
    let authMiddleware = PasswordAuthenticationMiddleware(User.self)

    drop.addConfigurable(middleware: authMiddleware, name: "auth")
  }
}
