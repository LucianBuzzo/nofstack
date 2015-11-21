program echostd
  use templates
  use, intrinsic :: iso_fortran_env, only: iostat_end
  implicit none

  character(len=30) :: path

  character(len=30) :: file_name = 'build/templates/main.html'

  integer   :: lun, io_status
  character :: char

  call getarg(1, path)

  print *, 'The path requested is ', path

  file_name = get_template(path)

  open(newunit=lun, file=file_name, access='stream', status='old',  &
     action='read')

  do
    read(lun, iostat=io_status) char
    if(io_status == iostat_end) exit
    if(io_status > 0) error stop '*** Error occurred while reading file. ***'
    write(*, '(a)', advance='no') char
  end do

  close(lun)

end program echostd

