const gulp = require('gulp');
const gutil = require('gulp-util');
const elm = require('gulp-elm');
const uglify = require('gulp-uglify');
const postcss = require('gulp-postcss');
const cssnext = require('postcss-cssnext');
const atImport = require('postcss-import');
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
    .pipe(elm.bundle('bundle.js'))
    .pipe(onlyProd(uglify()))
    .pipe(gulp.dest('dist/js'));
});

gulp.task('css', () => {
  const processors = [
    atImport(),
    cssnext({ browsers: ['last 2 versions'] }),
  ];

  return gulp.src('src/css/**/*.css')
    .pipe(postcss(processors))
    .pipe(gulp.dest('dist/css'));
});

gulp.task('watch', () => {
  browserSync.init({
    open: false,
    server: { baseDir: './' },
  });

  gulp.watch('index.html', withReload());
  gulp.watch('src/elm/**/*.elm', withReload('elm'));
  gulp.watch('src/css/**/*.css', withReload('css'));
});

gulp.task('default', ['elm', 'css']);
