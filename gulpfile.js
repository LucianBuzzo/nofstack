var gulp = require('gulp');
var copy = require('gulp-copy');
var exec = require('child_process').exec;
const config = require('./package.json').nofstack;

function puts(error, stdout, stderr) {
  if ( error ) console.log(error);
  if ( stderr ) console.log(stderr);
  console.log(stdout);
}

function gfortranBuild(input, output) {
  const src = input.join(' ');
  const tmp = output.split('/').slice(0, -1).join('/') + '/tmp.f95';
//  exec(`cat ${src} > ${tmp} && gfortran ${tmp} -o ${output} && rm ${tmp}`, puts);
  exec('cat ' + src + ' > ' + tmp + ' && gfortran ' + tmp + ' -o ' + output + ' && rm ' + tmp, puts);
}

gulp.task('default', () => {
  gfortranBuild(config.mainIn, config.mainOut);

  return  gulp.src('./src/templates/*.html')
    .pipe(gulp.dest('./build/templates'));

});

gulp.task('watch', () => {
  gulp.watch('./src/*', ['default']);
});
