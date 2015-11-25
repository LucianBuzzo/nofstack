module content
  use markdown
  implicit none
contains
  function get_content(path) result(resp)
    ! Variables used for reading the content file itself
    use, intrinsic :: iso_fortran_env, only: iostat_end
    character (len=30) :: file_name
    character(len=999):: line
    character (len=999999), allocatable :: tmp
    character (:), allocatable :: resp
    integer :: io_status, size

    ! Variables used for checking the content file exists
    character(LEN=100), dimension(:), allocatable :: menu
    character(len=30):: path
    integer :: i,reason,NstationFiles,iStation
    logical :: exists

    exists = .FALSE.

    open(41,FILE='build/content-files.txt',action="read")
    !how many
    i = 0
    do
     read(41,FMT='(a)',iostat=reason) line
     if (reason/=0) EXIT
     i = i+1
    end do
    NstationFiles = i
    allocate(menu(NstationFiles))
    rewind(41)
    do i = 1,NstationFiles
      read(41,'(a)') menu(i)
      if ( trim(path) == '/'//trim(menu(i)) ) then
        exists = .TRUE.
      endif
    end do
    close(41)

    if ( exists ) then
      tmp = ''

      open (20, file='content'//trim(path), status='unknown', iostat=io_status)

      ! Immediately read twice and skip over the first two lines
      read (20, *)
      read (20, *)

      do
        read (20, '(A)', iostat=io_status, advance='no', size=size) line ! read line from input file
        if ( trim(line) /= '' ) then
          tmp = trim(tmp)//md_format_line(line)//NEW_LINE('A')
        end if
        if(io_status == iostat_end) exit
        if(io_status > 0) error stop '*** Error occurred while reading file. ***'
      end do

      ! Allocate here to prevent a segfault
      allocate(character (len=len_trim(tmp)):: resp)

      resp = tmp
    else
      resp = '404 page not found: '//path
    end if
  end function
end module content
