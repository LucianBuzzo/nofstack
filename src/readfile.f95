module readfile
  implicit none
contains
  function read_file(file_name) result(resp)
    use, intrinsic :: iso_fortran_env, only: iostat_end
    character (len=30) :: file_name
    character (len=99):: line
    character (len=999), allocatable :: tmp
    character (:), allocatable :: resp
    integer :: io_status, size

    tmp = ''

    open (20, file=file_name, status='unknown', iostat=io_status)

    do
      read (20, '(A)', iostat=io_status, advance='no', size=size) line ! read line from input file
      tmp = trim(tmp)//trim(line)//NEW_LINE('A')
      if(io_status == iostat_end) exit
      if(io_status > 0) error stop '*** Error occurred while reading file. ***'
    end do

    ! Allocate here to prevent a segfault
    allocate(character (len=len_trim(tmp)):: resp)

    resp = tmp

  end function
end module readfile
