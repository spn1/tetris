shader_type canvas_item;
render_mode world_vertex_coords;

uniform uint sides[256];
uniform vec4 outline_color:source_color;
uniform float tile_size = 16;
uniform float chunk_size = 16;

varying vec2 world_coord;

void vertex() {
    world_coord = VERTEX;
}

void fragment() {
	vec2 block_coord = floor(world_coord / tile_size);
	vec2 relative_world_coord = floor(world_coord - (tile_size * block_coord));
	vec2 chunk_coord = floor(block_coord / chunk_size);
	vec2 relative_block_coord = floor(block_coord - (chunk_size * chunk_coord));
	uint side_index = uint(relative_block_coord.x + relative_block_coord.y * tile_size);
	uint side_data = sides[side_index];
	
	if (side_data == uint(1) || side_data == uint(5) || side_data == uint(9) || side_data == uint(15) || side_data == uint(8) || side_data == uint(11) || side_data == uint(12) || side_data == uint(13)) {
		if (uint(0) == uint(relative_world_coord.y)) { //Outlining the top of the shape
			COLOR = outline_color;
		}
	}
	if (side_data == uint(2) || side_data == uint(6) || side_data == uint(10) || side_data == uint(15) || side_data == uint(5) || side_data == uint(9) || side_data == uint(12) || side_data == uint(14)) {
		if (uint(tile_size - 1.0) == uint(relative_world_coord.x)) { //Outlining the right of the shape
			COLOR = outline_color;
		}
	}
	if (side_data == uint(3) || side_data == uint(7) || side_data == uint(11) || side_data == uint(15) || side_data == uint(6) || side_data == uint(9) || side_data == uint(10) || side_data == uint(13)) {
		if (uint(tile_size - 1.0) == uint(relative_world_coord.y)) { //Outlining the bottom of the shape
			COLOR = outline_color;
		}
	}
	if (side_data == uint(4) || side_data == uint(8) || side_data == uint(12) || side_data == uint(15) || side_data == uint(7) || side_data == uint(10) || side_data == uint(11) || side_data == uint(14)) {
		if (uint(0) == uint(relative_world_coord.x)) { //Outlining the left of the shape
			COLOR = outline_color;
		}
	}
}