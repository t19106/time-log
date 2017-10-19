require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
  end

  test 'passes validation' do
    tag = Tag.new(user: @user, name: 'Study Programming')
    assert tag.save
  end

  test 'fails validation' do
    # タグ名がない
    # タグ名が空である
    tag = Tag.new(user: @user)
    refute tag.save
    tag = Tag.new(user: @user, name: '')
    refute tag.save

    # タグ名が20文字以上である
    tag = Tag.new(user: @user, name: 'Study Programming and Get Feedback from Reviewer')
    refute tag.save
  end
end
