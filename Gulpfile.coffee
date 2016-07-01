Config = require './config'
path = require 'path'
gulp = require 'gulp'
browserSync = require('browser-sync').create()
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
runSequence = require "run-sequence"

# html
jade = require 'gulp-jade'
vinylYamlData = require 'vinyl-yaml-data'
deepExtend = require 'deep-extend-stream'
locals = null
# JS
webpack = require 'gulp-webpack'
uglify = require 'gulp-uglify'
modernizr = require 'gulp-modernizr'

# CSS
stylus = require 'gulp-stylus'
autoprefixer = require 'gulp-autoprefixer'
sourcemaps = require 'gulp-sourcemaps'
jeet = require 'jeet'

#Images
spritesmith = require 'gulp.spritesmith'

# lang
eng = false

##################
# HTML
######
gulp.task 'data',->
  locals = {}
  path = if eng is true then Config.data.pathEn else Config.data.pathJa
  gulp.src path
  .pipe plumber
    errorHandler: notify.onError('<%= error.message %>')
  .pipe vinylYamlData()
  .pipe deepExtend locals

gulp.task 'views',['data'],->
  dest = if eng is true then Config.data.destEn else Config.data.destJa
  gulp.src Config.data.viewPath
  .pipe plumber
    errorHandler: notify.onError('<%= error.message %>')
  .pipe jade
    pretty: true
    locals: locals
    basedir: Config.data.viewBasePath
  .pipe(gulp.dest(dest))

##################
# JS
######
gulp.task 'webpack',->
  gulp.src Config.webpack.src
  .pipe webpack require './webpack.config.coffee'
  .pipe uglify()
  .pipe gulp.dest Config.webpack.dest

gulp.task 'modernizr',->
  gulp.src [Config.webpack.dest+'*.js',Config.stylus.dest+'*.css']
  .pipe modernizr Config.modernizr.outputName,Config.modernizr.options
  .pipe uglify()
  .pipe gulp.dest Config.modernizr.dest

##################
# CSS
######
gulp.task 'stylus',->
  gulp.src Config.stylus.path
  .pipe plumber
    errorHandler: notify.onError('<%= error.message %>')
  .pipe sourcemaps.init()
  .pipe stylus
    compress: false
    lineou: true
    use: [
      jeet()
    ]
  .pipe autoprefixer
    browsers: ['last 2 versions','IE 8']
    cascade: false
  .pipe sourcemaps.write('.')
  .pipe gulp.dest Config.stylus.dest

##################
# sprite
######
gulp.task 'sprite',->
  console.log Config.sprite.path + '*-2x.png'
  spriteData = gulp.src Config.sprite.path+'*.png'
  .pipe spritesmith
    imgName: 'sprite.png'
    cssName: '_sprite.styl'
    padding: 10

  spriteData.img
    .pipe gulp.dest Config.sprite.imgDest

  spriteData.css
    .pipe gulp.dest Config.sprite.stylusPath

##################
# SERVER
######
gulp.task 'serve',->
  browserSync.init
    server:
      baseDir: Config.server.root


gulp.task 'startServer',->
  runSequence(
    ['views','webpack','stylus']
    'modernizr'
    'serve'
  )

##################
# WATCH
######
gulp.task 'watch',['startServer'],->
  changeHandler = (event)->
    console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'
    browserSync.reload()

  w1 = gulp.watch Config.data.path, ['views']
  w2 = gulp.watch Config.data.watchFiles, ['views']
  w3 = gulp.watch Config.webpack.watchFiles, ['webpack']
  w4 = gulp.watch Config.stylus.path[0], ['stylus']

  w1.on 'change',changeHandler
  w2.on 'change',changeHandler
  w3.on 'change',changeHandler
  w4.on 'change',changeHandler


##################
# default
######
gulp.task 'default',['watch']


##################
# Build Eng
######
gulp.task 'switchLang',->
  eng = true

gulp.task 'build-en',->
  runSequence(
    'switchLang'
    'views'
  )
