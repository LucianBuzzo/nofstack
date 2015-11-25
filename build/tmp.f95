! -----------------------------------------------
MODULE String_Functions  ! by David Frank  dave_frank@hotmail.com
IMPLICIT NONE            ! http://home.earthlink.net/~dave_gemini/strings.f90

! Copy (generic) char array to string or string to char array
! Clen           returns same as LEN      unless last non-blank char = null
! Clen_trim      returns same as LEN_TRIM    "              "
! Ctrim          returns same as TRIM        "              "
! Count_Items    in string that are blank or comma separated
! Reduce_Blanks  in string to 1 blank between items, last char not blank
! Replace_Text   in all occurances in string with replacement string
! Spack          pack string's chars == extract string's chars
! Tally          occurances in string of text arg
! Translate      text arg via indexed code table
! Upper/Lower    case the text arg

INTERFACE Copy    ! generic
   MODULE PROCEDURE copy_a2s, copy_s2a
END INTERFACE Copy

CONTAINS
! ------------------------
PURE FUNCTION Copy_a2s(a)  RESULT (s)    ! copy char array to string
CHARACTER,INTENT(IN) :: a(:)
CHARACTER(SIZE(a)) :: s
INTEGER :: i
DO i = 1,SIZE(a)
   s(i:i) = a(i)
END DO
END FUNCTION Copy_a2s

! ------------------------
PURE FUNCTION Copy_s2a(s)  RESULT (a)   ! copy s(1:Clen(s)) to char array
CHARACTER(*),INTENT(IN) :: s
CHARACTER :: a(LEN(s))
INTEGER :: i
DO i = 1,LEN(s)
   a(i) = s(i:i)
END DO
END FUNCTION Copy_s2a

! ------------------------
PURE INTEGER FUNCTION Clen(s)      ! returns same result as LEN unless:
CHARACTER(*),INTENT(IN) :: s       ! last non-blank char is null
INTEGER :: i
Clen = LEN(s)
i = LEN_TRIM(s)
IF (s(i:i) == CHAR(0)) Clen = i-1  ! len of C string
END FUNCTION Clen

! ------------------------
PURE INTEGER FUNCTION Clen_trim(s) ! returns same result as LEN_TRIM unless:
CHARACTER(*),INTENT(IN) :: s       ! last char non-blank is null, if true:
INTEGER :: i                       ! then len of C string is returned, note:
                                   ! Ctrim is only user of this function
i = LEN_TRIM(s) ; Clen_trim = i
IF (s(i:i) == CHAR(0)) Clen_trim = Clen(s)   ! len of C string
END FUNCTION Clen_trim

! ----------------
FUNCTION Ctrim(s1)  RESULT(s2)     ! returns same result as TRIM unless:
CHARACTER(*),INTENT(IN)  :: s1     ! last non-blank char is null in which
CHARACTER(Clen_trim(s1)) :: s2     ! case trailing blanks prior to null
s2 = s1                            ! are output
END FUNCTION Ctrim

! --------------------
INTEGER FUNCTION Count_Items(s1)  ! in string or C string that are blank or comma separated
CHARACTER(*) :: s1
CHARACTER(Clen(s1)) :: s
INTEGER :: i, k

s = s1                            ! remove possible last char null
k = 0  ; IF (s /= ' ') k = 1      ! string has at least 1 item
DO i = 1,LEN_TRIM(s)-1
   IF (s(i:i) /= ' '.AND.s(i:i) /= ',' &
                    .AND.s(i+1:i+1) == ' '.OR.s(i+1:i+1) == ',') k = k+1
END DO
Count_Items = k
END FUNCTION Count_Items

! --------------------
FUNCTION Reduce_Blanks(s)  RESULT (outs)
CHARACTER(*)      :: s
CHARACTER(LEN_TRIM(s)) :: outs
INTEGER           :: i, k, n

n = 0  ; k = LEN_TRIM(s)          ! k=index last non-blank (may be null)
DO i = 1,k-1                      ! dont process last char yet
   n = n+1 ; outs(n:n) = s(i:i)
   IF (s(i:i+1) == '  ') n = n-1  ! backup/discard consecutive output blank
END DO
n = n+1  ; outs(n:n)  = s(k:k)    ! last non-blank char output (may be null)
IF (n < k) outs(n+1:) = ' '       ! pad trailing blanks
END FUNCTION Reduce_Blanks

! ------------------
FUNCTION Replace_Text (s,text,rep)  RESULT(outs)
CHARACTER(*)        :: s,text,rep
INTEGER             :: i, nt, nr
CHARACTER(:), allocatable :: outs     ! provide outs with extra 100 char len
character (len=999999), allocatable :: tmp

tmp = s ; nt = LEN_TRIM(text) ; nr = LEN_TRIM(rep)
DO
   i = INDEX(tmp,text(:nt)) ; IF (i == 0) EXIT
   tmp = tmp(:i-1) // rep(:nr) // tmp(i+nt:)
END DO
! Allocate here to prevent a segfault
allocate(character (len=len_trim(tmp)):: outs)
outs = trim(tmp)
END FUNCTION Replace_Text

! ---------------------------------
FUNCTION Spack (s,ex)  RESULT (outs)
CHARACTER(*) :: s,ex
CHARACTER(LEN(s)) :: outs
CHARACTER :: aex(LEN(ex))   ! array of ex chars to extract
INTEGER   :: i, n

n = 0  ;  aex = Copy(ex)
DO i = 1,LEN(s)
   IF (.NOT.ANY(s(i:i) == aex)) CYCLE   ! dont pack char
   n = n+1 ; outs(n:n) = s(i:i)
END DO
outs(n+1:) = ' '     ! pad with trailing blanks
END FUNCTION Spack

! --------------------
INTEGER FUNCTION Tally (s,text)
CHARACTER(*) :: s, text
INTEGER :: i, nt

Tally = 0 ; nt = LEN_TRIM(text)
DO i = 1,LEN(s)-nt+1
   IF (s(i:i+nt-1) == text(:nt)) Tally = Tally+1
END DO
END FUNCTION Tally

! ---------------------------------
FUNCTION Translate(s1,codes)  RESULT (s2)
CHARACTER(*)       :: s1, codes(2)
CHARACTER(LEN(s1)) :: s2
CHARACTER          :: ch
INTEGER            :: i, j

DO i = 1,LEN(s1)
   ch = s1(i:i)
   j = INDEX(codes(1),ch) ; IF (j > 0) ch = codes(2)(j:j)
   s2(i:i) = ch
END DO
END FUNCTION Translate

! ---------------------------------
FUNCTION Upper(s1)  RESULT (s2)
CHARACTER(*)       :: s1
CHARACTER(LEN(s1)) :: s2
CHARACTER          :: ch
INTEGER,PARAMETER  :: DUC = ICHAR('A') - ICHAR('a')
INTEGER            :: i

DO i = 1,LEN(s1)
   ch = s1(i:i)
   IF (ch >= 'a'.AND.ch <= 'z') ch = CHAR(ICHAR(ch)+DUC)
   s2(i:i) = ch
END DO
END FUNCTION Upper

! ---------------------------------
FUNCTION Lower(s1)  RESULT (s2)
CHARACTER(*)       :: s1
CHARACTER(LEN(s1)) :: s2
CHARACTER          :: ch
INTEGER,PARAMETER  :: DUC = ICHAR('A') - ICHAR('a')
INTEGER            :: i

DO i = 1,LEN(s1)
   ch = s1(i:i)
   IF (ch >= 'A'.AND.ch <= 'Z') ch = CHAR(ICHAR(ch)-DUC)
   s2(i:i) = ch
END DO
END FUNCTION Lower

END MODULE String_Functions

module markdown
  implicit none
contains
  function md_format_line(input_line) result(resp)
    character(999) :: input_line
    character(999999), allocatable :: tmp
    character (:), allocatable :: resp
    integer :: i, l
    i = index(input_line, '#')
    l = len_trim(input_line)
    if ( i == 1 ) then
      tmp = '<h1>'//trim(input_line(2:l))//'</h1>'
    else if ( index(input_line, '>') == 1 ) then
      tmp = '<blockquote>'//trim(input_line(2:l))//'</blockquote>'
    else
      tmp = '<p>'//trim(input_line)//'</p>'
    end if
    allocate(character (len=len_trim(tmp)):: resp)

    resp = trim(tmp)
  end function
end module markdown
module readfile
  implicit none
contains
  function read_file(file_name) result(resp)
    use, intrinsic :: iso_fortran_env, only: iostat_end
    character (len=30) :: file_name
    character (len=99):: line
    character (len=999999), allocatable :: tmp
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
module templates
  implicit none
contains
  function get_template_path(path) result(template_file)
    character(len=30) :: path, template_file
    select case (path)
     case ('/blog')
       template_file = 'build/templates/blog.html'
     case default
       template_file = 'build/templates/main.html'
    end select
    return
  end
end module templates

program echostd
  use String_Functions
  use menu
  use content
  use templates
  use readfile
  implicit none

  character (len=30) :: path
  character (len=30) :: file_name = 'build/templates/layout.html'
  character (len=999999) :: template, menu_markup, content_text
  character (:), allocatable :: response_text
  integer :: occurances, size
  character (len=30) :: line

  call getarg(1, path)

  response_text = read_file(file_name)
  template = get_template_path(path)

  menu_struct = build_menu()

  content_text = get_content(path)

  response_text = Replace_Text(response_text, '{{title}}', path)
  response_text = Replace_Text(response_text, '{{menu}}', menu_markup)
  response_text = Replace_Text(response_text, '{{content}}', content_text)

  write(*, *) response_text        ! write response to the screen

  close(20)

end program echostd

