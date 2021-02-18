class StayroomReserve < ApplicationRecord

  def self.one_month_resreves(params)
    results = StayroomReserve.all
    # results = results.where(stayroom_id: params[:stayroom_id]) if params[:stayroom_id] > 0
    results = results.where('date between ? and ?', params[:calendar_start], params[:calendar_end])
    results
  end
end
