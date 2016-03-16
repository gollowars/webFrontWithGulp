module.exports = 
  server:
    root:'./dist/'
  webpack:
    dest: './dist/assets/js/'
    src: './source/js/'
    watchFiles: ['./source/js/**/*.js','./source/js/**/*.coffee']
  data:
    destJa: './dist/'
    destEn: './dist/en/'
    pathJa:'source/data/ja/**/*.y{,a}ml'
    pathEn:'source/data/en/**/*.y{,a}ml'
    viewBasePath:'source/views/'
    viewPath: ['./source/views/**/*.jade','!./source/views/**/_*.jade']
    watchFiles: ['./source/views/**/*.jade']
  stylus:
    path: ['./source/css/**/*.stylus','./source/css/**/*.styl']
    dest: './dist/assets/css/'
    sourcemaps: './dist/assets/css/'
  sprite:
    path: 'source/sprite-images/'
    imgDest: 'dist/assets/images/'
    stylusPath: 'source/css/'