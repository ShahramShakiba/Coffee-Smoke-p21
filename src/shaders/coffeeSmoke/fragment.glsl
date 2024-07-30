uniform sampler2D uTexture;

varying vec2 vUv;

void main() {
  //=== Smoke
  float smoke = texture(uTexture, vUv).r;

 //==== Final Color
  gl_FragColor = vec4(1.0, 1.0, 1.0, smoke);

  #include <tonemapping_fragment>
  #include <colorspace_fragment>
}




/* ************** smoke
- switch the variable from "vec4 smoke" to a "float smoke" and only retrieve the "r" channel

* since the Perlin texture is a grayscale image, we can use the "red" channel only, because it's a grayscale image and (r, g, b, a) all of them has the same value
 
?  gl_FragColor = vec4(1.0, 1.0, 1.0, smoke);
  - in a way, we want to create holes where it's dark because we want to see through the smoke where it's dark and to create more realistic smoke effect, that's why we put smoke on the "alpha-channel"

  - also, add (transparent = true) on the material

*/