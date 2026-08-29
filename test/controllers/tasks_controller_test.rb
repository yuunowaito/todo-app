require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "index lists tasks" do
    get root_url
    assert_response :success
    assert_select "li.task", count: Task.count
  end

  test "creates a task" do
    assert_difference -> { Task.count }, 1 do
      post tasks_url, params: { task: { title: "新しいタスク" } }
    end
    assert_redirected_to tasks_url
  end

  test "does not create a task without a title" do
    assert_no_difference -> { Task.count } do
      post tasks_url, params: { task: { title: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "toggles completion" do
    task = tasks(:write_code)
    patch toggle_task_url(task)
    assert_redirected_to tasks_url
    assert task.reload.completed

    patch toggle_task_url(task)
    assert_not task.reload.completed
  end

  test "destroys a task" do
    task = tasks(:write_code)
    assert_difference -> { Task.count }, -1 do
      delete task_url(task)
    end
    assert_redirected_to tasks_url
  end
end
