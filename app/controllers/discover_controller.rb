class DiscoverController < ApplicationController

  FILTERS = [ 'recommended', 'expiring', 'recent', 'successful', 'soon' ]

  def index
    @avaliable_filters = FILTERS
    @filters = {}
    @tags = Tag.all
    @projects = Project.visible.order_for_search

    if params[:filter].present? && FILTERS.include?(params[:filter].downcase)
      @projects = @projects.send(params[:filter].downcase)
      @filters.merge! filter: params[:filter].downcase
    end

    if params[:near].present?
      @projects = @projects.near(params[:near], 30)
      @filters.merge! near: params[:near]
    end

    if params[:category].present?
      category = Category.where('name_en ILIKE ?', params[:category]).first
      if category.present?
        @projects = @projects.by_category_id(category.id)
        @filters.merge! category: category.name_en
      end
    end

    if params[:tags].present?
      tags = Project::TagList.new params[:tags]
      @projects = @projects.joins("JOIN taggings ON taggings.project_id = projects.id AND taggings.tag_id IN (SELECT id FROM tags WHERE tags.name IN (#{tags.map { |t| "'#{t}'"}.join(',')}))")
      @filters.merge! tags: tags
    end

    if params[:search].present?
      @projects = @projects.pg_search(params[:search])
      @filters.merge! search: params[:search]
    end
  end
end