// pixelate.glsl
extern number pixelation;   // 0.0 (no pixelation) -> 1.0 (max pixelation)
extern vec2 resolution;     // send love.graphics.getWidth(), getHeight()
extern number maxPixelSize; // max size in pixels (e.g. 32)

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // Map pixelation 0..1 to pixel size range
    float pixelSize = mix(1.0, maxPixelSize, clamp(pixelation, 0.0, 1.0));

    // Convert screen coordinates into pixelated grid
    vec2 uv = texture_coords * resolution;
    uv = floor(uv / pixelSize) * pixelSize;
    uv /= resolution;

    return Texel(tex, uv) * color;
}