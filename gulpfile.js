const gulp = require('gulp');
const gutil = require('gulp-util');
const elm = require('gulp-elm');
const uglify = require('gulp-uglify');
const sass = require('gulp-sass');
const autoprefixer = require('gulp-autoprefixer');
const copy = require('gulp-copy');
const browserSync = require('browser-sync').create();

/**
 * Helpers
 */
const onlyProd = fn => gutil.env.type === 'prod' ? fn : gutil.noop();
const withReload = (...tasks) => [...tasks, browserSync.reload];

/**
 * Tasks
 */
gulp.task('elm', () => {
  return gulp.src('src/elm/Main.elm')
    .pipe(elm.bundle('bundle.js', { warn: true })).on('error', gutil.log)
    .pipe(onlyProd(uglify()))
    .pipe(gulp.dest('dist/js'));
});

gulp.task('css', () => {
  gulp.src([
    'node_modules/font-awesome/fonts/*',
  ]).pipe(copy('dist/fonts', {
    prefix: 3,
  }));

  return gulp.src('src/scss/main.scss')
    .pipe(sass({
      outputStyle: gutil.env.type == 'prod' ? 'compressed' : 'nested',
      includePaths: [
        'node_modules/bulma',
        'node_modules/font-awesome/scss',
      ],
    }).on('error', sass.logError))
    .pipe(onlyProd(autoprefixer({
      browsers: ['last 2 versions'],
    })))
    .pipe(gulp.dest('dist/css'));
});

gulp.task('watch', () => {
  browserSync.init({
    open: false,
    server: { baseDir: './' },
  });

  gulp.watch('index.html', browserSync.reload);
  gulp.watch('src/elm/**/*.elm', withReload('elm'));
  gulp.watch('src/scss/**/*.scss', withReload('css'));
});

gulp.task('default', ['elm', 'css']);
