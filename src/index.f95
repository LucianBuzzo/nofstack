program echostd
  use String_Functions
  use templates
  use, intrinsic :: iso_fortran_env, only: iostat_end
  implicit none

  character(len=30) :: path
  character(len=30) :: file_name = 'build/templates/layout.html'
  character(len=999999) :: template
  character (len=999):: line
  character(:), allocatable :: response_text

  integer :: io_status
  integer :: size

  call getarg(1, path)

  response_text = ''
  template = get_template(path)

  open (20, file=file_name, status='unknown', iostat=io_status)

  do
    read (20, '(A)', iostat=io_status, advance='no', size=size) line ! read line from input file
    line = Replace_Text(line, '{{title}}', path)
    line = Replace_Text(line, '{{content}}', '<p>The path requested is '//path//'</p>')
    response_text = response_text//trim(line)//NEW_LINE('A')
    !write(*, *) trim(line)        ! write line to the screen
    if(io_status == iostat_end) exit
    if(io_status > 0) error stop '*** Error occurred while reading file. ***'
  end do


  write(*, *) response_text        ! write response to the screen
 !print *, response_text        ! write line to the screen

  close(20)

end program echostd

