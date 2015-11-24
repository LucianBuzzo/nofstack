program echostd
  use String_Functions
  use templates
  use, intrinsic :: iso_fortran_env, only: iostat_end
  implicit none

  character(len=30) :: path
  character(len=30) :: file_name = 'build/templates/layout.html'
  character(len=999999) :: template
  character (len=999):: line
  integer :: io_status

  call getarg(1, path)

  template = get_template(path)

  open (20, file=file_name, status='unknown', iostat=io_status)

  do
    read (20, '(A)', iostat=io_status) line ! read line from input file
    line = Replace_Text(line, '{{title}}', path)
    line = Replace_Text(line, '{{content}}', '<p>The path requested is '//path//'</p>')
    write(*, '(999A)') line        ! write line to the screen
    if(io_status == iostat_end) exit
    if(io_status > 0) error stop '*** Error occurred while reading file. ***'
  end do

  close(20)

end program echostd

