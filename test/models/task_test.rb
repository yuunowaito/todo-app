require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "requires a title" do
    task = Task.new(title: "")
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "defaults to not completed" do
    assert_not Task.new(title: "something").completed
  end

  test "ordered puts incomplete tasks before completed ones" do
    Task.delete_all
    done = Task.create!(title: "done", completed: true)
    todo = Task.create!(title: "todo", completed: false)
    assert_equal [ todo, done ], Task.ordered.to_a
  end
end
