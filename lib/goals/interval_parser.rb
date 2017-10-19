class Goals::IntervalParser
  def initialize(interval)
    # intervalを、[0]日数と[1]時間に分ける
    # day(s)判定を行っているのは、Postgresql上では文字列day(s)が自動的に付与されるため、保存前との形式の差異を吸収するため
    _interval = interval =~ /day/ ? interval.split(/\s[a-z]{3,4}\s/) : interval.split(/\s/)
    if _interval[1]
      @interval = { days: _interval[0].to_i, time: _interval[1] }
    else
      @interval = { days: 0, time: _interval[0] }
    end
  end

  def to_seconds
    @interval[:days].days.to_i + (Time.zone.parse(@interval[:time]) - Time.zone.parse('0:00:00')).to_i
  end
end
