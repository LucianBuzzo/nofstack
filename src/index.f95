program echostd
  use String_Functions
  use templates
  use readfile
  implicit none

  character (len=30) :: path
  character (len=30) :: file_name = 'build/templates/layout.html'
  character (len=999999) :: template
  character (:), allocatable :: response_text
  integer :: occurances

  call getarg(1, path)

  response_text = read_file(file_name)
  template = get_template_path(path)

  response_text = Replace_Text(response_text, '{{title}}', path)
  response_text = Replace_Text(response_text, '{{content}}', '<p>The path requested is '//path//'</p>')

 print *, Tally(response_text, 'blog')

  write(*, *) response_text        ! write response to the screen
 !print *, response_text        ! write line to the screen

  close(20)

end program echostd

