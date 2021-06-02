/*eslint strict: ["error", "global"]*/
'use strict';

//=======================================================
// Include gulp
//=======================================================
const gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var cssnano = require('cssnano');
var autoprefixer = require('autoprefixer');
var del = require('del');
var print = require('gulp-print').default;
var gulpCopy = require('gulp-copy');
var glob = require('gulp-sass-glob');
var log = require('fancy-log');

// Use the dart-sass compiler
$.sass.compiler = require('sass');

var sassPaths = [
  'node_modules/foundation-sites/scss',
  'node_modules/motion-ui/src',
  'node_modules/susy/sass'
];

// =======================================================
// clean
// =======================================================

function clean(cb) {
  log("Clean");
  // var arr = theme_in.split('/');
  // var theme = arr[arr.length-1] || arr[arr.length-2];
  // return del(theme + '/dist/**/*.*', { force: true });
  return del('./css/*.*', { force: true });
};

exports.clean = clean;

// =======================================================
// compile
// =======================================================

async function compile(cb) {
  log("Compile Scss");
  // var arr = theme_in.split('/');
  // var theme = arr[arr.length-1] || arr[arr.length-2];
  // var base = './' + theme + '/scss';
  // return src('./scss/**/*.scss', { base: base })
  return gulp.src('./scss/*.scss')
    .pipe(print())
    // .pipe(sassLint())
    // .pipe(sassLint.format())
    .pipe($.sourcemaps.init()) // initialize sourcemaps first
    .pipe(glob())
    .pipe($.sass({
      outputStyle: 'compressed',
      includePaths: sassPaths
    }).on('error', $.sass.logError)) // compile SCSS to CSS
    .pipe($.postcss([ autoprefixer(), cssnano() ])) // PostCSS plugins
    .pipe($.sourcemaps.write('./maps')) // write sourcemaps file in current directory
    .pipe(gulp.dest('./css'));
};


exports.compile = compile;

// =======================================================
// copyLibFiles
// =======================================================

async function copyFiles(cb) {
  gulp.src('node_modules/foundation-sites/dist/css/*.css')
    .pipe(gulpCopy('./css', {prefix: 4}));
  gulp.src('node_modules/foundation-sites/dist/js/*.js')
    .pipe(gulpCopy('./js', {prefix: 4}));
  gulp.src('node_modules/motion-ui/dist/*.css')
    .pipe(gulpCopy('./css', {prefix: 3}));
  gulp.src('node_modules/motion-ui/dist/*.js')
    .pipe(gulpCopy('./js', {prefix: 3}));
  var activity = "Stylesheets and scripts from /node_modules/foundation-sites/dist and";
  activity += " node_modules/motion-ui/dist copied to /css and /js.";
  log(activity);
};

exports.copyFiles = copyFiles;

// =======================================================
// Default Task
// =======================================================

exports.default = gulp.series(clean, compile, copyFiles);


// gulp.task('default', ['sass', 'copy'], function() {
//   // gutil.log('watching for .scss file changes in /scss.');
//   log('watching for .scss file changes in /scss.');
//   gulp.watch(['scss/**/*.scss'], ['sass']);
// });
