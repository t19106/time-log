class Task::Relation
  attr_reader :relation

  def initialize(date, user)
    @date = date
    @user = user
  end

  def tasks_by_month
    monthly_tasks_by_start.merge(monthly_tasks_by_end) do |_k, v1, v2|
      v1.concat(v2).uniq.sort_by(&:starts_at)
    end
  end

  def tasks_by_date
    tasks = same_day_tasks_by_start.or(same_day_tasks_by_end).map do |task|
      task.adjust_overnight_range(task.starts_at)
    end
    tasks.sort_by(&:starts_at)
  end

  private

  def monthly_tasks_by_start
    tasks = @user.tasks.where(user: @user, starts_at: @date.beginning_of_month..@date.end_of_month)
    tasks.map { |task| task.adjust_overnight_range(task.starts_at) }.group_by { |t| t.starts_at.day }
  end

  def monthly_tasks_by_end
    tasks = @user.tasks.where(user: @user, ends_at: @date.beginning_of_month..@date.end_of_month)
    tasks.map { |task| task.adjust_overnight_range(task.ends_at) }.group_by { |t| t.ends_at.day }
  end

  def same_day_tasks_by_start
    @user.tasks.where(user: @user, starts_at: @date.beginning_of_day..@date.end_of_day)
  end

  def same_day_tasks_by_end
    @user.tasks.where(user: @user, ends_at: @date.beginning_of_day..@date.end_of_day)
  end
end
