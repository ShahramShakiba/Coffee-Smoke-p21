uniform float uTime;
uniform sampler2D uTexture;

varying vec2 vUv;

vec2 rotate2D(vec2 value, float angle) {
  float s = sin(angle);
  float c = cos(angle);

  mat2 m = mat2(c, s, -s, c);

  return m * value;
}

void main() {
  vec3 newPosition = position;

  //========== Twist 
  float twistPerlin = texture(
      uTexture, 
      vec2(0.5, uv.y * 0.2 - uTime * 0.009)
  ).r;

  float angle = twistPerlin * 10.0; 
  newPosition.xz = rotate2D(newPosition.xz, angle);

  //========== Wind 
  vec2 windOffset = vec2(
      texture(uTexture, vec2(0.25, uTime * 0.01)).r - 0.5, 
      texture(uTexture, vec2(0.75, uTime * 0.01)).r - 0.5 
  );

  windOffset *= pow(uv.y, 2.0) * 10.0; 
  newPosition.xz += windOffset;

  //========= Final Position
  gl_Position = 
    projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);

  //========= Varyings
  vUv = uv;
}






/* **************** Twist
- we want the vertices to rotate around the center of the plane and to have that rotation changing according to the elevation

- this means that the vertices are going to rotate on an xz plane along to the y axis



- now we need to pick the color on the uTexture using "texture()" to get a random value

- we just want one value that will change according to the elevation

- we are going to set that line at the center of the texture (0.5)



* float twistPerlin = texture(uTexture, vec2(0.5, uv.y * 0.2)).r;

- we are picking the values from that texture randomly

? uTexture
  - pick the color from uTexture

? vec2()
  - where it should pick the value
  - we need to send a vec2, because it's a 2d texture 

? uv.y
  - we use elevation

? uv.y * 0.2
  - to reduce the frequency

? r
  - we retrieve from "red" channel



* float angle = twistPerlin * 10.0;
  - the angle is quite small and there is not enough variation, we need the angle be high, so we get full rotation, that's why we multiply it by 10
*/


/* ******************  Wind
?  texture(uTexture, vec2(0.25, uTime * 0.01)).r - 0.5 
` - to get different pattern this time we set it to 0.25 instead 0.5

  - wind effect goes from -0.5 to 0.5
  - it's kind of having an effect that moves from left to right and vice versa


*  windOffset *= pow(uv.y, 2.0) * 10.0; 
  - uv.y:
    we want to steam to be at the center of our mug, it start from there and then as it goes up it gets effected by the wind

  - pow(...)
  - it starts slowely and gets fast as it goes up, it's kind of take more time to gets up
  - it's kind of more power will make the steam less affected by the wind.


  * vec2 windOffset = vec2(
  *    texture(uTexture, vec2(0.25, uTime * 0.01)).r - 0.5,  // X
  *    texture(uTexture, vec2(0.75, uTime * 0.01)).r - 0.5   // Z
  );
*/


/* ******************** Transparency occluding(blocking)
  - if you look from some angle, it seems that the plane is occluding itself

  - it's because the plane is writing on the depth buffer and will occlude anything behind it, including itself

  * to fix that in js, material section add:
    depthWrite: false,
*/