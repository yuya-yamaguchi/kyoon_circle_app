class StayroomReserve < ApplicationRecord
  belongs_to :stayroom

  before_validation :can_reserve

  scope :reserve_duplicate, ->(checkin_date, checkout_date) do
    where('(checkin_date <= ? AND checkout_date > ?) OR
           (checkin_date < ? AND checkout_date >= ?) OR
           (? <= checkin_date AND checkout_date <= ?)',
           checkin_date,  checkin_date,
           checkout_date, checkout_date,
           checkin_date,  checkout_date)
  end

  # 1ヶ月分の予約情報を取得
  def self.one_month_resreves(params)
    reserves = []
    stayroom_reserves = StayroomReserve.where('checkin_date between ? AND ?', params[:calendar_start], params[:calendar_end])
    stayroom_reserves.each do |stayroom_reserve|
      reserve_days = (stayroom_reserve.checkout_date - stayroom_reserve.checkin_date).to_i
      reserve_days.times do |i|
        reserves << { id: stayroom_reserve.id,
                      stayroom_id: stayroom_reserve.stayroom_id,
                      user_id: stayroom_reserve.user_id,
                      date: stayroom_reserve.checkin_date + i
                    }
      end
    end
    return reserves
  end

  def can_reserve
    # 部屋を指定する場合
    if self.stayroom_id.to_i > 0
      results = StayroomReserve.where(stayroom_id: self.stayroom_id).reserve_duplicate(self.checkin_date, self.checkout_date)
      if results.count > 0
        errors[:base] << "すでに予約されています"
        throw(:abort)
      end
    # 部屋を指定しない場合
    else
      stayroom_id = vacant_room(self.checkin_date, self.checkout_date)
      if stayroom_id
        self.stayroom_id = stayroom_id
      else
        errors[:base] << "すでに予約されています"
        throw(:abort)
      end
    end
  end

  private
  # 予約日付内で空室の部屋(1部屋)を取得
  def vacant_room(checkin_date, checkout_date)
    stayrooms = Stayroom.all
    stayrooms.each do |stayroom|
      results = stayroom.stayroom_reserves.reserve_duplicate(checkin_date, checkout_date)
      if results.count == 0
        return stayroom.id
      end
    end
    return false
  end
end
