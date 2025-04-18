shader_type canvas_item;
render_mode unshaded;

uniform sampler2D color_ramp;
uniform sampler2D pulse_ramp;

uniform float pulse_speed = 1.0;
uniform float min_alpha = 0.2;
uniform float max_alpha = 1.0;

void fragment() {
    // Avancement dans la pulsation, entre 0.0 et 1.0
    float t = mod(TIME * pulse_speed, 1.0);

    // Lecture de la courbe de pulsation
    float pulse = texture(pulse_ramp, vec2(t, 0.0)).r;
    float alpha = mix(min_alpha, max_alpha, pulse);

    // Lecture de la couleur du gradient selon l'avancement de la pulsation
    vec4 ramp_color = texture(color_ramp, vec2(t, 0.0));
    vec4 tex_color = texture(TEXTURE, UV);

    COLOR = tex_color * vec4(ramp_color.rgb * 1.5, alpha);
}
