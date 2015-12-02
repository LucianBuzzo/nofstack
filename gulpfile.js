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
  const tmp = output + '/tmp.f95';
  const cmds = [
    // cat the source files
    `cat ${src}`,
    // write the src files to a single tmp file
    `> ${tmp}`,
    // compile the tmp file
    `&& gfortran ${tmp}`,
    // specify the output dir for .mod file
    `-J ${output}`,
    // specify the output file for the compile executable
    `-o ${output}/nof.out`,
    // remove the tmp file
    `&& rm ${tmp}`
  ];
  exec(cmds.join(' '), puts);
}

gulp.task('default', () => {
  gfortranBuild(config.mainIn, config.mainOut);

  return  gulp.src('./src/templates/*.html')
    .pipe(gulp.dest('./build/templates'));

});

gulp.task('watch', () => {
  gulp.watch('./src/*', ['default']);
});
