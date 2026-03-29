use wasm_minimal_protocol::*;

initiate_protocol!();

/// Takes a PlantUML diagram string (as raw bytes) and returns the
/// deflate-encoded string suitable for use in PlantUML server URLs.
#[wasm_func]
fn encode(plantuml: &[u8]) -> Result<Vec<u8>, String> {
    let input = std::str::from_utf8(plantuml)
        .map_err(|e| format!("Invalid UTF-8 input: {}", e))?;

    let encoded = plantuml_encoding::encode_plantuml_deflate(input)
        .map_err(|e| format!("Encoding failed: {:?}", e))?;

    Ok(encoded.into_bytes())
}
