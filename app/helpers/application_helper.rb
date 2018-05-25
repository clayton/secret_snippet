module ApplicationHelper
  def navbar_logo
    image_tag(
      "secret_snippet_logo.svg",
      class: "d-inline-block align-top",
      width: 30,
      height: 30
    )
  end
end
