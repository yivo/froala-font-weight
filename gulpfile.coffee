gulp            = require 'gulp'
concat          = require 'gulp-concat'
coffee          = require 'gulp-coffee'
coffeeComments  = require 'gulp-coffee-comments'
preprocess      = require 'gulp-preprocess'
iife            = require 'gulp-iife'
uglify          = require 'gulp-uglify'
rename          = require 'gulp-rename'
plumber         = require 'gulp-plumber'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  gulp.src('source/plugin.coffee')
  .pipe plumber()
  .pipe preprocess()
  .pipe iife dependencies: [require: 'jquery', global: '$']
  .pipe concat('plugin.coffee')
  .pipe gulp.dest('build')
  .pipe coffeeComments()
  .pipe coffee()
  .pipe concat('plugin.js')
  .pipe gulp.dest('build')
  .pipe uglify()
  .pipe rename('plugin.min.js')
  .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
