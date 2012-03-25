module ApplicationHelper
  MOVIES_SORTING_FIELDS = [:name, :release_date]

  def css_for_column(name)
    return "hilite" if params[name] == "true"
    return "hilite" if !params[:name] && !params[:release_date] && name == :title
  end

  def movies_url_for_column(name)
    params_hash           = {}
    params_hash[name]     = true
    params_hash[:desc]    = params[:desc] == "false" && params[name] ? "true" : "false"
    params_hash[:ratings] = params[:ratings] || {}
    movies_path(params_hash)
  end
end