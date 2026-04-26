#let _plugin = plugin("target/wasm32-unknown-unknown/release/typst_plantuml.wasm")
#import "@preview/prequery:0.2.0": image

#let plantuml-url(code, server: "https://www.plantuml.com/plantuml") = {
  let encoded = str(_plugin.encode(bytes(code)))
  let url = server + "/svg/" + encoded
  url
}

#let plantuml(code, path, server: "https://www.plantuml.com/plantuml") = {
  let url = plantuml-url(code, server: server)
  image(url, path)
}