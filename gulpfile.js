var gulp = require('gulp');
var copy = require('gulp-copy');
var exec = require('child_process').exec;
var config = require('./package.json').nofstack;

function puts(error, stdout, stderr) {
  if ( error ) console.log(error);
  if ( stderr ) console.log(stderr);
  console.log(stdout);
}

function gfortranBuild(input, output) {
  exec('gfortran src/index.f95 -o build/nof.out', puts);
}

gulp.task('default', function() {
  gfortranBuild(config.mainIn, config.mainOut);

  return  gulp.src('./src/templates/*.html')
    .pipe(gulp.dest('./build/templates'));

});

gulp.task('watch', function() {
  gulp.watch('./src/*', ['default']);
});
