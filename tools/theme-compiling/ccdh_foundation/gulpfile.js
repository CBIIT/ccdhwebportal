(() => {

  'use strict';

  /**************** Gulp.js 4 configuration ****************/

  const

      // development or production
      devBuild = ((process.env.NODE_ENV || 'development').trim().toLowerCase() === 'development'),

      // directory locations
      dir = {
          // 'scss/' is the assumed folder watch location.  You can modify this below under CSS CONFIG.
          buildFolder: 'css/', // css will be generated to this folder. !! Files here will be cleaned before compile.
          imgSource: 'images-source/', // source image folder for image optimization.
          imgBuild: 'images/', // final location for optimized images.
      },

      // base modules
      gulp = require('gulp'),
      del = require('del'),
      noop = require('gulp-noop'),
      newer = require('gulp-newer'),
      size = require('gulp-size'),

      // @TODO finish browsersync work
      // browsersync = require('browser-sync').create(),

      // image modules
      imagemin = require('gulp-imagemin'),

      // SCSS modules
      sass = require('gulp-sass'),
      postcss = require('gulp-postcss'),
      sassLint = require('gulp-sass-lint'),
      sourcemaps = devBuild ? require('gulp-sourcemaps') : null,

      // IMG CONFIG
      imgConfig = {
          src: dir.imgSource + '**/*',
          build: dir.imgBuild,
          minOpts: {
              optimizationLevel: 5
          }
      },

      // CSS CONFIG
      cssConfig = {
          src: 'scss/*.scss',
          scssFolder: 'scss/**/*.scss',
          buildFolder: dir.buildFolder,
          sassOpts: {
              sourceMap: devBuild,
              outputStyle: 'nested',
              imagePath: '/images/', // @TODO redundant and needs to be removed.
              includePaths: [ // REQUIRED FOR ZURB
                  'node_modules/foundation-sites/scss',
                  'node_modules/motion-ui/src'
              ],
              precision: 3,
              errLogToConsole: true
          },

          postCSS: [
              require('postcss-assets')({
                  loadPaths: ['images/'],
                  basePath: dir.build
              }),
              require('autoprefixer')({
                  overrideBrowserslist: ['> 1%']
              })
          ]

      };

  console.log('Gulp', devBuild ? 'development' : 'production', 'build');

  /**************** clean task ****************/

  function cleanTask() {

      return del([dir.buildFolder]);

  }

  exports.clean = cleanTask;
  exports.wipe = cleanTask; // Redundant

  /**************** images task ****************/

  function imagesTask() {

      return gulp.src(imgConfig.src)
          .pipe(newer(imgConfig.build))
          .pipe(imagemin(imgConfig.minOpts))
          .pipe(size({showFiles: true}))
          .pipe(gulp.dest(imgConfig.build));

  }

  exports.images = imagesTask;

  /**************** CSS ****************/


  // CSS
  function cssTask(done) {
      cleanTask();
      return gulp.src(cssConfig.src)
          .pipe(sourcemaps ? sourcemaps.init() : noop())
          .pipe(sass(cssConfig.sassOpts).on('error', sass.logError))
          .pipe(postcss(cssConfig.postCSS))
          .pipe(sourcemaps ? sourcemaps.write() : noop())
          .pipe(size({showFiles: true}))
          .pipe(gulp.dest(cssConfig.buildFolder))
      //.pipe(browsersync ? browsersync.reload({stream: true}) : noop());

  }

  // Minify for production CSS
  if (!devBuild) {

      cssConfig.postCSS.push(
          // require('usedcss')({html: ['index.html']}),
          require('cssnano')
      );

  }

  // LINT WORK
  function lintTask(done) {
      return gulp.src(cssConfig.scssFolder)
          // use gulp-cached to check only modified files.
          .pipe(sassLint())
          .pipe(sassLint.format())
          .pipe(sassLint.failOnError());
  }

  exports.lint = lintTask;

  /**************** server task (now private) ****************/

  const syncConfig = {
      server: {
          baseDir: './',
          index: 'index.html'
      },
      port: 8000,
      open: false
  };

  // browser-sync
  function sync(done) {
      if (browsersync) browsersync.init(syncConfig);
      done();
  }

  /**************** watch task ****************/

  function watchTask(){
      gulp.watch(
          [cssConfig.scssFolder, imgConfig.src],
          gulp.series(imagesTask,lintTask,cssTask)
      );
  }

  /**************** default task ****************/
  exports.default = gulp.series(cssTask);

  /**************** watch task ******************/
  exports.watch = gulp.series(lintTask,cssTask,watchTask);

})();
