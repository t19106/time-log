module DateValidation
  extend ActiveSupport::Concern

  def validate_date_uri
    begin
      Time.zone.local(params[:year], params[:month], params[:day])
    rescue ArgumentError
      flash[:alert] = '存在しない日付へアクセスされようとしました。今月のページへ戻ります。'
      redirect_to tasks_months_path year: Time.zone.now.year, month: Time.zone.now.month
    end
  end
end
