module ApplicationHelper
  def css_for_column(name)
    return "hilite" if params[name]
    return "hilite" if name == :title
  end

  def movies_url_for_column(name)
    desc = request.referrer =~ /desc/
    params_hash = {}
    params_hash[name] = true
    params_hash[:desc] = params[:desc] == "true" ? "false" : "true"
    movies_path(params_hash)
  end
end