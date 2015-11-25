module menu
  implicit none

  type menu_item
    character(len=30) menu_name
    character(len=30) content_file
  end type

contains
  function theme_menu(menu_struct) result(markup)
    type(menu_item) menu_struct(100)
    character(LEN=10000):: markup
  end function

  function build_menu() result(menu_markup)
    character(LEN=100), dimension(:), allocatable :: menu
    character(LEN=10000):: menu_markup
    character(len=30):: line
    integer :: i,reason,NstationFiles,iStation
    type(menu_item) menu_list(100)

    menu_markup = ''
    ! Build menu file and place it in the build dir
    ! Reads the first line from every file in the content dir
    call system('find content -type f -exec head -1 \{\} \; > build/menu.txt')

    ! get the files
    call system('ls ./content > build/content-files.txt')
    open(31,FILE='build/content-files.txt',action="read")
    !how many
    i = 0
    do
     read(31,FMT='(a)',iostat=reason) line
     if (reason/=0) EXIT
     i = i+1
    end do
    NstationFiles = i
    allocate(menu(NstationFiles))
    rewind(31)
    do i = 1,NstationFiles
      read(31,'(a)') menu(i)
      open (22, file='content/'//trim(menu(i)), status='unknown')
      read (22, '(A)') line ! read line from input file
      close(22)
      menu_list(i)%menu_name = trim(line)
      menu_list(i)%content_file = 'content/'//trim(menu(i))
      menu_markup = trim(menu_markup)//'<a href="/'//trim(menu(i))//'">'&
        //trim(line)//'</a>'
    end do
    close(31)

  end function
end module menu
