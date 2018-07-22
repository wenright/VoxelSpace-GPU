uniform Image heightMap;
uniform Image colorMap;
uniform float phi;
uniform vec3 player;

vec4 backgroundColor = vec4(0.7, 0.8, 0.9, 1.0);
float heightScale = 16000.0;
float horizon = 100.0;
float drawDistance = 200.0;

vec4 effect(vec4 loveColor, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float sinPhi = sin(phi);
    float cosPhi = cos(phi);
    vec4 color = vec4(0, 0, 0, 0);

    float dz = 0.2;
    for (float z = 1; z < drawDistance; z += dz) {
      vec2 leftPoint = vec2(-cosPhi * z - sinPhi * z + player.x,
          sinPhi * z - cosPhi * z + player.y);
      vec2 rightPoint =  vec2(cosPhi * z - sinPhi * z + player.x,
          -sinPhi * z - cosPhi * z + player.y);

      vec2 delta = (rightPoint - leftPoint) / love_ScreenSize.x;
      leftPoint += delta * screen_coords.x;

      leftPoint /= 200.0;

      float drawHeight = (player.z - Texel(heightMap, leftPoint).r) / z * heightScale + horizon;

      if (drawHeight < screen_coords.y) {
        color = Texel(colorMap, leftPoint);

        // Add fog
        float amount = sqrt((drawDistance - z) / drawDistance);
        color = ((amount * color) + (1 - amount) * backgroundColor);

        return color;
      }

      // These are used as quality, basically. Lower means higher quality, but worse performance
      dz *= 1.006;
      dz += 0.0001;
    }

    return color;
}
