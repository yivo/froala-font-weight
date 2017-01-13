gulp    = require 'gulp'
concat  = require 'gulp-concat'
coffee  = require 'gulp-coffee'
umd     = require 'gulp-umd-wrap'
plumber = require 'gulp-plumber'
fs      = require 'fs'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  dependencies = [
    {require: 'jquery', global: '$'}
    {require: 'froala-editor'}
  ]
  header = fs.readFileSync('source/__license__.coffee')
  
  gulp.src('source/plugin.coffee')
    .pipe plumber()
    .pipe umd({dependencies, header})
    .pipe concat('plugin.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('plugin.js')
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
