# typst-plantuml

A [Typst](https://typst.app) plugin to encode [PlantUML](https://plantuml.com)
diagrams and render them via the PlantUML server using
[prequery](https://github.com/typst-community/prequery).

## Usage

Import the package and use the `plantuml` function:

```typst
#import "@preview/plantuml:0.1.0": plantuml

#plantuml("
@startuml
Alice -> Bob: Hello
Bob --> Alice: Hi there
@enduml
")
```

More examples can be found
[here](https://github.com/HSGamer/typst-plantuml/blob/master/test.typ)

### Options

- **`server`**: The PlantUML server URL. Defaults to
  `"https://www.plantuml.com/plantuml"`.

```typst
#plantuml(
  "@startuml\nA -> B: Hello\n@enduml",
  server: "https://my-plantuml-server.com/plantuml",
)
```

### How it works

1. The plugin encodes your PlantUML source using deflate compression (via
   [plantuml_encoding](https://crates.io/crates/plantuml_encoding)).
2. It constructs a URL to the PlantUML server SVG endpoint.
3. It uses [prequery](https://github.com/typst-community/prequery) to download
   the rendered SVG and cache it locally.

## Build from Source

To build the plugin and prepare it for distribution:

1. Install Rust and Cargo.
2. Install the `wasm32-unknown-unknown` target:
   ```sh
   rustup target add wasm32-unknown-unknown
   ```
3. Run the build script:
   ```sh
   just build
   ```

The build artifacts will be available in `dist/`.

## License

MIT
