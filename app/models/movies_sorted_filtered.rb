class MoviesSortedFiltered
  def initialize(params)
    @params = init(params.slice(:sort_by, :order, :filters))
    @params = yield @params if block_given?
  end

  def params_applied
    @params
  end

  def results
    @results = Movie.order_by("#{@params[:sort_by]} #{@params[:order]}")
    @params[:filters].keys.each do |key|
      if @params[:filters][key].present?
        @results = @results.send("filter_on_#{key}", @params[:filters][key])
      end
    end
    @results
  end

  private

  def init(params)
    sort_by       = params[:sort_by]  || "title"
    order_param   = params[:order]    || "asc"
    filters_param = params[:filters]  || {}
    { sort_by: sort_by, order: order_param , filters: filters_param }
  end
end