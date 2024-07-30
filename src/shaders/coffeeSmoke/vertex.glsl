varying vec2 vUv;

void main() {
  //===== Final Position
  gl_Position = 
    projectionMatrix * modelViewMatrix * vec4(position, 1.0);

  //=== Varyings
  vUv = uv;
}