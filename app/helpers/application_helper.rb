module ApplicationHelper

  def css_for_column(name)
    return "hilite" if params["sort_by"] == name.to_s
    if !params["sort_by"] && name == :title
      "hilite"
    end
  end

  def movies_url_for_column(name)
    is_asc_current  = params[:order] == "asc" && params[:sort_by] == name.to_s
    params_hash     = {
      sort_by: name,
      order:   is_asc_current ? "desc" : "asc",
      ratings: params[:ratings]
    }
    movies_path(params_hash)
  end
end