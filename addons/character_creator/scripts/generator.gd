
@tool
# Assemble layers (placeholder) into a single texture
extends Node

# Assemble layers (placeholder) into a single texture
func compose(dna: Dictionary) -> ImageTexture:
    # TODO: load your layered PNGs based on dna
    var img := Image.new()
    # …composite logic…
    return ImageTexture.create_from_image(img)
