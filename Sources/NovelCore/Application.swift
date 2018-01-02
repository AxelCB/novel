import Vapor
import Leaf

public protocol Feature {
  var configurators: [Configurator] { get }
}

public final class Application {

  let drop: Droplet
    let config: Config

  let coreConfigurators: [Configurator] = [
    DatabaseConfigurator(),
    MiddlewareConfigurator()
  ]

  public var features: [Feature] = []
  public var configurators: [Configurator] = []

  public init() {
    do {
        drop = try Droplet()
        config = try Config()
    } catch {
        fatalError("Failed to initialize app")
    }
    
  }

  public func start() throws {
    try prepare(configurators: coreConfigurators)
    try prepare(features: features)
    try prepare(configurators: configurators)

    try drop.run()
  }

  func prepare(configurators: [Configurator]) throws {
    for configurator in configurators {
      try configurator.configure(config: config)
    }
  }

  func prepare(features: [Feature]) throws {
    for feature in features {
      try prepare(configurators: feature.configurators)
    }
  }
}
