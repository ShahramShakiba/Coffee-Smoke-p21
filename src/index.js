//===================================================
/* "It is not an actual project; therefore,
I rely on comments to assess the code." */
//===================================================
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import GUI from 'lil-gui';
import * as THREE from 'three';
import vertexSmoke from './shaders/coffeeSmoke/vertex.glsl';
import fragmentSmoke from './shaders/coffeeSmoke/fragment.glsl';

const canvas = document.querySelector('canvas.webgl');
const gui = new GUI();
const scene = new THREE.Scene();

let width = window.innerWidth;
let height = window.innerHeight;
const clock = new THREE.Clock();

//================ Loaders ======================
const textureLoader = new THREE.TextureLoader();
const gltfLoader = new GLTFLoader();

//================ Camera ======================
const camera = new THREE.PerspectiveCamera(25, width / height, 0.1, 100);
camera.position.x = 8;
camera.position.y = 10;
camera.position.z = 12;
scene.add(camera);

//============ Orbit Controls ==================
const controls = new OrbitControls(camera, canvas);
controls.target.y = 3;
controls.enableDamping = true;

//=============== Renderer =====================
const renderer = new THREE.WebGLRenderer({
  canvas: canvas,
  antialias: true,
});
renderer.setSize(width, height);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

//============== Resize Listener ===================
let resizeTimeout;

const onWindowResize = () => {
  clearTimeout(resizeTimeout);

  resizeTimeout = setTimeout(() => {
    width = window.innerWidth;
    height = window.innerHeight;

    camera.aspect = width / height;
    camera.updateProjectionMatrix();

    renderer.setSize(width, height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.5));
  }, 200);
};

window.addEventListener('resize', onWindowResize);

//================ Model =======================
gltfLoader.load('./bakedModel.glb', (gltf) => {
  gltf.scene.getObjectByName('baked').material.map.anisotropy = 8;
  scene.add(gltf.scene);
});

//================== Smoke =======================
//==== Geometry
const smokeGeometry = new THREE.PlaneGeometry(1, 1, 16, 64);
smokeGeometry.translate(0, 0.5, 0);
smokeGeometry.scale(1.5, 6, 1.5);

//==== Perlin Texture
const perlinTexture = textureLoader.load('./perlin.png');
perlinTexture.wrapS = THREE.RepeatWrapping;
perlinTexture.wrapT = THREE.RepeatWrapping;

//==== Material
const smokeMaterial = new THREE.ShaderMaterial({
  vertexShader: vertexSmoke,
  fragmentShader: fragmentSmoke,

  uniforms: {
    uTexture: new THREE.Uniform(perlinTexture),
    uTime: new THREE.Uniform(0),
  },

  side: THREE.DoubleSide,
  transparent: true,
  // wireframe: true,
});

//==== Mesh
const smoke = new THREE.Mesh(smokeGeometry, smokeMaterial);
smoke.position.y = 1.83;
scene.add(smoke);

//================= Animate ======================
const tick = () => {
  const elapsedTime = clock.getElapsedTime();

  smokeMaterial.uniforms.uTime.value = elapsedTime;

  controls.update();
  renderer.render(scene, camera);
  window.requestAnimationFrame(tick);
};

tick();
