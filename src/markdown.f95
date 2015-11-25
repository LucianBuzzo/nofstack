
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
