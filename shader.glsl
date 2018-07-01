uniform Image heightMap;
uniform Image colorMap;
uniform float phi;
uniform vec3 player;

float heightScale = 10000.0;
float horizon = 120.0;
float drawDistance = 100.0;

vec4 effect(vec4 loveColor, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // With rotation
    float sinPhi = sin(phi);
    float cosPhi = cos(phi);
    vec4 color = vec4(0, 0, 0, 0);

    float dz = 0.1;
    for (float z = 0; z < drawDistance; z += dz) {
      vec2 leftPoint = vec2(-cosPhi * z - sinPhi * z + player.x,
          sinPhi * z - cosPhi * z + player.y);
      vec2 rightPoint =  vec2(cosPhi * z - sinPhi * z + player.x,
          -sinPhi * z - cosPhi * z + player.y);

      // vec2 delta = vec2((rightPoint.x - leftPoint.x) / screenDimensions.x,
      //     (rightPoint.y - leftPoint.y) / screenDimensions.x);

      float dx = (rightPoint.x - leftPoint.x) / love_ScreenSize.x;
      float dy = (rightPoint.y - leftPoint.y) / love_ScreenSize.y;

      leftPoint.x += dx * screen_coords.x;
      leftPoint.y += dy * screen_coords.x;

      leftPoint /= 200.0;

      float drawHeight = (player.z - Texel(heightMap, leftPoint).r) / z * heightScale + horizon;

      if (drawHeight < screen_coords.y) {
        color = Texel(colorMap, leftPoint);
        // return Texel(heightMap, leftPoint);
        return color;


        // return vec4(1.0, drawHeight / 1000, 0, 1.0);
        // break;
      }

      // return vec4(1.0, leftPoint.x / 100, 0, 1.0);


      // return Texel(heightMap, mod(leftPoint, vec2(1024, 1024)));
      dz += 0.01;
      // dz *= 1.01;
    }

    // TODO return BG color, or maybe just transparency of 0
    // return vec4(1.0, 0, 0, 1.0);
    return color;

    // for (float z = 0; z < drawDistance; z++) {
    //   vec2 pLeft = vec2(-z + player.x, -z + player.y);
    //   vec2 pRight = vec2(z + player.x, -z + player.y);
    //
    //   float dx = (pRight.x - pLeft.x) / love_ScreenSize.x;
    //   pLeft.x += dx * screen_coords.x;
    //
    //   float drawHeight = (player.z - Texel(heightMap, pLeft).r) / z * heightScale + horizon;
    //
    //   if (drawHeight<= screen_coords.y) {
    //     return Texel(colorMap, pLeft/1000);
    //   }
    // }
}
