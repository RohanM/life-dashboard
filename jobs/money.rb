require 'csv'
require 'pry'

def load_expenses
  expenses = []
  CSV.foreach('data/expenses.csv', col_sep: ';') do |row|
    next if row[0] == 'Date,Amount,Note,Tag' # Skip header row
    next if (row[2] || '').downcase == 'income' # Skip income

    expenses << {date: Date.parse(row[0]),
                 amount: row[1].to_f,
                 note: row[2],
                 tag: row[3]}
  end
  expenses
end

def recent(expenses)
  expenses.
    select { |e| e[:date] > 1.month.ago }.
    sort_by { |e| e[:date] }
end

def expenses_by_tag(expenses)
  expenses_by_tag = {}

  expenses.each do |e|
    expenses_by_tag[e[:tag]] ||= 0
    expenses_by_tag[e[:tag]] += e[:amount]
  end

  expenses_by_tag
end

def top_expense_tags_graph(expenses)
  expenses.
    to_a.
    sort_by { |e| e[1] }.
    reverse.
    first(10).
    each_with_index.
    map do |(tag, amount), i|

    {x: i, y: amount, label: tag}
  end
end

expenses = load_expenses
recent_expenses = recent(expenses)
tagged_expenses = expenses_by_tag(recent_expenses)
top_expense_points = top_expense_tags_graph(tagged_expenses)
top_expense_point_labels = top_expense_points.map { |p| p[:label] }

send_event('money-top-expenses', points: top_expense_points, graphtype: 'bar', x_labels: top_expense_point_labels)
