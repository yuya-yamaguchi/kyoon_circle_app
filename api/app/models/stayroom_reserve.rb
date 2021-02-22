class StayroomReserve < ApplicationRecord
  belongs_to :stayroom

  def self.one_month_resreves(params)
    results = StayroomReserve.all
    results = results.where('date between ? AND ?', params[:calendar_start], params[:calendar_end])
    results
  end

  def can_reserve?(params)
    can_reserve = false
    # 部屋を指定する場合
    if params[:stayroom_id].to_i > 0
      results = StayroomReserve.where(stayroom_id: params[:stayroom_id])
                               .where('? <= checkin_date  AND checkin_date  < ?', params[:checkin_date], params[:checkout_date])
                               .where('? <= checkout_date AND checkout_date < ?', params[:checkin_date], params[:checkout_date])
      can_reserve = true if results.count == 0
    # 部屋を指定しない場合
    else
      if vacant_room(params[:checkin_date], params[:checkout_date])
        can_reserve = true
      end
    end
    return can_reserve
  end

  def create_reserves(params)
    stayroom_id = 0
    if !can_reserve?(params)
      errors[:base] << "すでに予約されています"
      return false
    end
    if params[:stayroom_id].to_i == 0
      # 空いている部屋を取得
      stayroom_id = vacant_room(params[:checkin_date], params[:checkout_date])
    else
      # frontで指定された部屋を設定
      stayroom_id = params[:stayroom_id]
    end
    # 予約日数分登録する
    StayroomReserve.create(user_id: params[:user_id],
                            stayroom_id: stayroom_id,
                            checkin_date: checkin_date,
                            checkout_date: checkout_date
                          )
  end
  
  private
  # 予約日付内で空室の部屋を取得
  def vacant_room(checkin_date, checkout_date)
    stayrooms = Stayroom.all
    stayrooms.each do |stayroom|
      results = stayroom.stayroom_reserves.where('? <= checkin_date AND checkin_date < ?', checkin_date, checkout_date)
      if results.count == 0
        return stayroom.id
      end
    end
    return false
  end
end
