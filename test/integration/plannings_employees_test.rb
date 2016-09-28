# encoding: utf-8

require 'test_helper'

class PlanningsEmployeesTest < ActionDispatch::IntegrationTest

  setup :list_plannings

  test 'create and update planning entries' do
    page.assert_selector('.planning-calendar .-definitive', count: 0)
    page.assert_selector('.planning-calendar .-provisional', count: 0)
    page.assert_selector('.planning-calendar .-selected', count: 0)
    all('.planning-calendar-week')[0].assert_text('0%')
    all('.planning-calendar-week')[1].assert_text('0%')
    page.assert_selector('.planning-panel', visible: false)

    page.assert_no_selector(row_selector)
    find('.add').click

    selectize('add_work_item_select_id', 'PITC-PT: PuzzleTime')
    page.assert_selector(row_selector, text: 'PITC-PT: PuzzleTime')

    row.all('.day')[0].assert_text('')
    drag(row.all('.day')[0], row.all('.day')[4])

    page.assert_selector('.planning-calendar .-selected', count: 5)
    page.assert_selector('.planning-panel', visible: true)

    within '.planning-panel' do
      fill_in 'percent', with: '50'
      click_button 'OK'
    end

    page.assert_selector('.planning-calendar .-definitive', count: 5)
    page.assert_selector('.planning-calendar .-provisional', count: 0)
    page.assert_selector('.planning-calendar .-selected', count: 0)
    all('.planning-calendar-week')[0].assert_text('50%')
    all('.planning-calendar-week')[1].assert_text('0%')
    page.assert_selector('.planning-panel', visible: false)
    row.all('.day')[0].assert_text('50')
    row.all('.day')[1].assert_text('50')
    row.all('.day')[2].assert_text('50')
    row.all('.day')[3].assert_text('50')
    row.all('.day')[4].assert_text('50')
    row.all('.day')[5].assert_text('')
    row.all('.day')[6].assert_text('')

    drag(row.all('.day')[3], row.all('.day')[6])
    page.assert_selector('.planning-calendar .-selected', count: 4)
    page.assert_selector('.planning-panel', visible: true)

    within '.planning-panel' do
      fill_in 'percent', with: '75'
      click_button 'provisorisch'
      click_button 'OK'
    end

    page.assert_selector('.planning-calendar .-definitive', count: 3)
    page.assert_selector('.planning-calendar .-provisional', count: 4)
    page.assert_selector('.planning-calendar .-selected', count: 0)
    all('.planning-calendar-week')[0].assert_text('60%')
    all('.planning-calendar-week')[1].assert_text('30%')
    page.assert_selector('.planning-panel', visible: false)
    row.all('.day')[0].assert_text('50')
    row.all('.day')[1].assert_text('50')
    row.all('.day')[2].assert_text('50')
    row.all('.day')[3].assert_text('75')
    row.all('.day')[4].assert_text('75')
    row.all('.day')[5].assert_text('75')
    row.all('.day')[6].assert_text('75')
  end

  private

  def row_selector
    "#planning_row_employee_#{employees(:mark).id}_work_item_#{work_items(:puzzletime).id}"
  end

  def row
    find(row_selector)
  end

  def list_plannings
    login_as :mark
    visit plannings_employee_path(employees(:mark))
  end

end