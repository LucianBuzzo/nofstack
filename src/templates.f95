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

