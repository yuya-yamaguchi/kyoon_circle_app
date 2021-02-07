class Api::PartCategoriesController < ApplicationController

  def index
    part_categories = PartCategory.all.order('id')
    render status: 200, json: part_categories
  end
end
