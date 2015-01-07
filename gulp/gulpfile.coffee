gulp = require 'gulp' 
$ = require('gulp-load-plugins')()

gulp.task 'templates', ->
  gulp.src 'src/templates/*.mustache'
    .pipe $.mustache()
    .pipe $.rename({extname: '.html'})
    .pipe gulp.dest('public/templates')
    .pipe $.notify {message: 'Templates task complete'}

gulp.task 'styles', ->
  gulp.src 'src/styles/**/*.styl'
    .pipe $.stylus()
    .pipe $.concat('main.css')
    .pipe gulp.dest('public/css')
#    .pipe rename({suffix: '.min'})
#    .pipe $.minifycss()
#    .pipe gulp.dest('public/css')
    .pipe $.notify({ message: 'Styles task complete' })

gulp.task 'scripts', ->
  gulp.src 'src/scripts/**/*.coffee'
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()
    .pipe $.coffee({bare: true}).on('error', $.util.log)
    .pipe $.concat('main.js')
    .pipe gulp.dest('public/js') 
#    .pipe $.rename({suffix: '.min'})
#    .pipe $.uglify()
#    .pipe gulp.dest('public/js') 
    .pipe $.notify({ message: 'Scripts task complete' })

gulp.task 'images', ->
  gulp.src 'src/images/**/*'
    .pipe $.cache($.imagemin({ optimizationLevel: 3, progressive: true, interlaced: true }))
    .pipe gulp.dest('public/img')
    .pipe $.notify { message: 'Images task complete' } 

gulp.task 'clean', ->
  generated = ['public/js', 'public/css', 'public/templates']
  gulp.src(generated)
    .pipe $.rimraf()
    .pipe $.notify {message: 'Clean task complete'}

gulp.task 'watch', ->
  gulp.watch 'src/styles/**/*.styl', ['styles']
  gulp.watch 'src/scripts/**/*.coffee', ['scripts']
  gulp.watch 'src/images/**/*', ['images']
  gulp.watch 'src/images/**/*.mustache', ['templates']

  $.livereload.listen()
  gulp.watch(['public/css/**', 'public/js/**', 'public/img/**']).on('change', $.livereload.changed);

gulp.task 'default', ['styles', 'scripts', 'images', 'templates']

