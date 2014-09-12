gulp = require('gulp')
gutil = require('gulp-util')

coffee = require('gulp-coffee')
coffeelint = require('gulp-coffeelint')
jshint = require('gulp-jshint')
stylus = require('gulp-stylus')
nib = require('nib')
browserSync = require('browser-sync')

fs = require('fs')

paths = {
  coffee: 'src/jquery-ticker.coffee'
  coffeeDest: 'dist/jquery-ticker.js'
  staticJs: [
    'bower_components/jquery/dist/jquery.min.js'
    'bower_components/velocity/velocity.js'
  ]
  staticJsDest: [
    'demo/jquery.min.js'
    'demo/velocity.js'
  ]
  stylus: 'src/*.styl'
  stylusDest: 'demo'
}


###
 * Coffee Script
###

gulp.task('coffee', (callback) ->
  coffeeStream = coffee({ bare: true }).on('error', (err) ->
    gutil.log(err)
    coffeeStream.end()
  )
  coffeelintStream = coffeelint(
    'no_trailing_whitespace':
      'level': 'error'
  ).on('error', (err) ->
    gutil.log(err)
    coffeelintStream.end()
  )
  gulp.src(paths.coffee)
    .pipe(coffeelintStream)
    .pipe(coffeelint.reporter())
    .pipe(coffeeStream)
    .pipe(gulp.dest('dist'))
    .pipe(browserSync.reload({ stream: true }))
)


###
 * jshint
###

gulp.task('jshint', (callback) ->
  jshintStream = jshint().on('error', (err) ->
    gutil.log(err)
    jshintStream.end()
  )
  gulp.src(paths.coffeeDest)
    .pipe(jshintStream)
    .pipe(jshint.reporter('default'))
)


###
 * Stylus
###

gulp.task('stylus', (callback) ->
  stream = stylus(
    use: [ nib() ]
  ).on('error', (err) ->
    gutil.log(err)
    stream.end()
  )

  gulp.src(paths.stylus)
    .pipe(stream)
    .pipe(gulp.dest(paths.stylusDest))
    .pipe(browserSync.reload({ stream: true }))
)


###
 * Copy
###

gulp.task('copy', () ->
  for sr, i in paths.staticJs
    src = paths.staticJs[i]
    dest = paths.staticJsDest[i]
    fs.createReadStream(src).pipe(fs.createWriteStream(dest))
)


###
 * watch
###

gulp.task('watch', [ 'browser-sync' ], (cb) ->
  gulp.watch(paths.coffee, [
    'coffee'
  ])
  gulp.watch(paths.scss, [
    'compassDev'
  ])
  cb()
)


###
 * static server
###
gulp.task('browser-sync', () ->
  browserSync(
    server:
      baseDir: './'
    startPath: '/demo'
  )
)


###
 * command
###

gulp.task('default', [
  'coffee'
  'jshint'
  'stylus'
  'watch'
])

gulp.task('deploy', [
  'copy'
  'coffee'
  'jshint'
  'stylus'
])

