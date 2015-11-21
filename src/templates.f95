module templates
  implicit none
contains
  function get_template(path)
    character(len=30) :: path
    character(len=30) :: get_template
    select case (path)
     case ('/blog')
       get_template = 'build/templates/blog.html'
     case default
       get_template = 'build/templates/main.html'
    end select
    return
  end
end module templates

