# VoxelSpace-GPU
GPU accelerated Comanche style voxel engine using a GLSL shader

![demo](https://github.com/wenright/VoxelSpace-GPU/raw/master/img/demo.gif)

Voxel renderers are really cool, and I liked [VoxelSpace](http://github.com/s-macke/VoxelSpace). But, at least on the web demo, performance was not great. I was getting around 20 FPS. With nearly the same algorithm on my GPU, I get around 500 FPS.

## Running
Install [LÖVE 11.1](https://love2d.org/)

`git clone` and `cd` into this repo, then run `love .`

## How it works

> shaders/voxel.glsl
```glsl
// This function is applied to every pixel on the screen in parallel using your GPU
vec4 effect(vec4 loveColor, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Start at a point close to the camera, move forward checking until you hit something
    for (float z = 1; z < drawDistance; z += 0.2) {
        // Find the furthest left and right points at the current depth that the camera is able to see
        vec2 leftPoint = vec2(-cosPhi * z - sinPhi * z + player.x,
            sin(phi) * z - cosPhi * z + player.y);
        vec2 rightPoint =  vec2(cosPhi * z - sinPhi * z + player.x,
            -sin(phi) * z - cosPhi * z + player.y);

        // Determine the distance between the left point and the current screen pixel
        vec2 delta = (rightPoint - leftPoint) / love_ScreenSize.x * screen_coords.x;

        // Get the position in terms of color/height map
        vec2 pos = leftPoint + delta;

        // Calculate how high this point would be on the screen
        float drawHeight = (player.z - Texel(heightMap, pos).r) / z * heightScale + horizon;

        // Typically, you would draw a line from drawHeight to the bottom of the screen,
        //  but we can assume that the pixels below have already been drawn
        if (drawHeight < screen_coords.y) {
            // Get the color of the current pixel from the colormap
            return Texel(colorMap, pos);
        }
    }

    return skyColor;
}
```

This project is based off of [VoxelSpace](http://github.com/s-macke/VoxelSpace)
