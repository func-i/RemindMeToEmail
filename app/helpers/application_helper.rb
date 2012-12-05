module ApplicationHelper
  def table_sort_link(label, key)
    if sort_by == key.to_s
      if params[:sort_order] == 'ASC'
        link_to %{#{label} <span class="caret reverse" style="margin-top: 8px;"></span>}.html_safe, params.merge(:sort_by => key.to_s, :sort_order => 'DESC'), :class => 'sort-link active'
      else
        link_to %{#{label} <span class="caret" style="margin-top: 8px;"></span>}.html_safe, params.merge(:sort_by => key.to_s, :sort_order => 'ASC'), :class => 'sort-link active'
      end
    else
      link_to %{#{label} <span class="caret" style="margin-top: 8px;"></span>}.html_safe, params.merge(:sort_by => key.to_s, :sort_order => 'DESC'), :class => 'sort-link'
    end
  end

end
