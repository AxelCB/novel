import Vapor

public protocol Configurator {
  func configure(config: Config) throws
}
