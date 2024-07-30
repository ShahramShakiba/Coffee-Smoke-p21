uniform sampler2D uTexture;
uniform float uTime;

varying vec2 vUv;

void main() {
  //=== Scale and Animate - 02
  vec2 smokeUv = vUv;
  smokeUv.x *= 0.5;
  smokeUv.y *= 0.3;
  smokeUv.y -= uTime * 0.03;

  //=== Smoke - 01
  float smoke = texture(uTexture, smokeUv).r;

  //=== Remap - 03
  smoke = smoothstep(0.4, 1.0, smoke);

 //==== Final Color
  gl_FragColor = vec4(1.0, 1.0, 1.0, smoke);

  #include <tonemapping_fragment>
  #include <colorspace_fragment>
}




/* **************  Smoke
- switch the variable from "vec4 smoke" to a "float smoke" and only retrieve the "r" channel

* since the Perlin texture is a grayscale image, we can use the "red" channel only, because it's a grayscale image and (r, g, b, a) all of them has the same value
 
?  gl_FragColor = vec4(1.0, 1.0, 1.0, smoke);
  - in a way, we want to create holes where it's dark because we want to see through the smoke where it's dark and to create more realistic smoke effect, that's why we put smoke on the "alpha-channel"

  - also, add (transparent = true) on the material  */



/* ************ smokeUv
  - we need to change the UV coordinates

  - but we can not modify a varying directly, we need to create a new variable out of it

? smokeUv.x *= 0.5;
  - make the pattern bigger
  - we only pick from 0 to 0.5, half of it, instead of picking from 0 to 1
  - we want it not to be too detailed  */


/* **********  Remap the value
  - the perlin-texture pixels go from 0(black) to 1(white), which is why there are no large transparent areas within the texture

  - we need to "remap" the value so that it goes from 0 when it should be 0.4, to 1 when it should be 1


  ? smoke = smoothstep(0.4, 1.0, smoke);
  - 0.4: where it should start
  - 1.0: where it should end
  - smoke: the value we want to remap

  * smoothstep returns a 0 to 1 clamped value
*/

