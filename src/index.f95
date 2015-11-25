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

  menu_markup = build_menu()

  content_text = get_content(path)

  response_text = Replace_Text(response_text, '{{title}}', path)
  response_text = Replace_Text(response_text, '{{menu}}', menu_markup)
  response_text = Replace_Text(response_text, '{{content}}', content_text)

  write(*, *) response_text        ! write response to the screen

  close(20)

end program echostd

