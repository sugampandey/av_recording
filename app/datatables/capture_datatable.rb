class CaptureDatatable
  include Rails.application.routes.url_helpers
  delegate :params, :h, :link_to, :number_to_capture, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: ::Capture.count,
      iTotalDisplayRecords: resources.total_count,
      aaData: data
    }
  end

private

  def data
    resources.map do |capture|
      if capture.completed?
        download_link = link_to('Download',capture.expiring_url, class: 'btn btn-xs btn-success', target: '_blank')
      else
        download_link = ""
      end
      [
        capture.id,
        capture.time_zone,
        capture.start_time.strftime('%D %T'), 
        capture.end_time.strftime('%D %T'), 
        capture.camera.name,
        capture.state,
        download_link,
        [ link_to('Edit', edit_capture_path(capture), class: 'btn btn-xs btn-info'),
          link_to('Destroy', capture_path(capture), class: 'btn btn-xs btn-danger', data: { method: :delete, confirm: 'Are you sure?' }) 
        ].join(' ')
      ]
    end
  end

  def resources
    @resources ||= fetch_resources
  end

  def fetch_resources
    resources = ::Capture.joins(:camera).order("#{sort_column} #{sort_direction}").page(page).per(per_page)
    if params[:sSearch].present?
      conds = %w[captures.id lower(time_zone) start_time end_time lower(cameras.name) lower(state)].map{|x| " #{x} like :query " }.join(" or ")
      resources = resources.where([conds, :query => "%#{params[:sSearch]}%"])
    end
    resources
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[captures.id time_zone start_time end_time cameras.name state]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
