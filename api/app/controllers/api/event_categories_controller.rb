class Api::EventCategoriesController < ApplicationController

  def index
    event_categories = EventCategory.order('id')
    render status: 200, json: event_categories
  end
end
