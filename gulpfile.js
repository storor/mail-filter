var gulp = require('gulp'),
		gutil = require('gulp-util'),
		jasmine = require('gulp-jasmine'),
		coffee = require('gulp-coffee'),
		browserify = require('gulp-browserify'),
		rename = require('gulp-rename');

gulp.task('coffee', function() {
  return gulp.src(['*.coffee', './spec/*.coffee'])
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dest/'));
});

gulp.task('bro', function() {
	gulp.src('index.js')
		.pipe(browserify({
			insertGlobals : true
		}))
		.pipe(rename('app.js'))
		.pipe(gulp.dest('./dest'))
});

gulp.task('test', ['coffee'], function() {
  gulp.src('./dest/*.js')
		.pipe(jasmine());
});

gulp.task('wt', function() {
  gulp.watch('./*.coffee', ['test']);
});
