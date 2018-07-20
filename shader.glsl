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

    float dz = 0.25;
    for (float z = 1; z < drawDistance; z += dz) {
      vec2 leftPoint = vec2(-cosPhi * z - sinPhi * z + player.x,
          sinPhi * z - cosPhi * z + player.y);
      vec2 rightPoint =  vec2(cosPhi * z - sinPhi * z + player.x,
          -sinPhi * z - cosPhi * z + player.y);

      float dx = (rightPoint.x - leftPoint.x) / love_ScreenSize.x;
      float dy = (rightPoint.y - leftPoint.y) / love_ScreenSize.x;

      leftPoint.x += dx * screen_coords.x;
      leftPoint.y += dy * screen_coords.x;

      leftPoint.x = floor(leftPoint.x);
      leftPoint.y = floor(leftPoint.y);

      leftPoint /= 200.0;

      float drawHeight = (player.z - Texel(heightMap, leftPoint).r) / z * heightScale + horizon;

      if (drawHeight < screen_coords.y) {
        color = Texel(colorMap, leftPoint);

        // Add fog
        float amount = sqrt((drawDistance - z) / drawDistance);
        color = ((amount * color) + (1 - amount) * backgroundColor);

        return color;
      }

      dz *= 1.01;
      // dz = dz + 0.008;
    }

    return color;
}
