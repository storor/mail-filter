var gulp = require('gulp'),
		gutil = require('gulp-util'),
		jasmine = require('gulp-jasmine'),
		coffee = require('gulp-coffee');

gulp.task('coffee', function() {
  return gulp.src('./*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dest/'));
});

gulp.task('test', ['coffee'], function() {
  gulp.src('./dest/*.js')
		.pipe(jasmine());
});
