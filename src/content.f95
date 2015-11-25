module content
  implicit none
contains
  function get_content(path) result(resp)
    character(LEN=100), dimension(:), allocatable :: menu
    character(LEN=10000):: resp
    character(len=30):: line, path
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
      resp = path//' content has been found'
    else
      resp = '404 page not found: '//path
    end if
  end function
end module content
