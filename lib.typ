#let _plugin = plugin("target/wasm32-unknown-unknown/release/typst_plantuml.wasm")

// Renders an image or a placeholder if it doesn't exist.
// Based on the "maybe-image" pattern by laurmaedje.
#let _maybe-image(path, ..args) = context {
  let path-label = label(path)
  let first-time = query((context {}).func()).len() == 0
  if first-time or query(path-label).len() > 0 {
    [#image(path, ..args)#path-label]
  } else {
    rect(fill: luma(245), stroke: luma(180), radius: 4pt, inset: 0.5em)[
      #align(center, text(fill: luma(120), size: 0.8em)[⚠ Image not preprocessed])
    ]
  }
}

#let plantuml(code, server: "https://www.plantuml.com/plantuml", path: none) = {
  let encoded = str(_plugin.encode(bytes(code)))
  let url = server + "/svg/" + encoded
  let path = if path == none { "assets/plantuml-" + encoded + ".svg" } else { path }

  // Register as web resource for prequery preprocessing
  [#metadata((url: url, path: path)) <web-resource>]

  // Show the image if it exists, otherwise show a placeholder
  _maybe-image(path)
}
