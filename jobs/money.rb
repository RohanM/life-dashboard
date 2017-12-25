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
  most_recent = expenses.map { |e| e[:date] }.max

  expenses.
    select { |e| e[:date] > (most_recent - 1.month) }.
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
    first(8).
    each_with_index.
    map do |(tag, amount), i|

    {x: i, y: amount, label: tag}
  end
end

def top_expense_tags_table(expenses)
  [['Category', 'Amount']] +

    expenses.
      to_a.
      sort_by { |e| e[1] }.
      reverse.map { |tag, amount| [tag.capitalize, "$#{"%.2f" % amount}"] } +

    [['', ''],
     ['Total', "$#{"%.2f" % expenses.values.sum}"]]
end

SCHEDULER.every '1m' do
  expenses = load_expenses
  recent_expenses = recent(expenses)
  tagged_expenses = expenses_by_tag(recent_expenses)
  top_expense_points = top_expense_tags_graph(tagged_expenses)
  top_expense_point_labels = top_expense_points.map { |p| p[:label] }
  top_expenses_table = top_expense_tags_table(tagged_expenses)

  send_event('money-top-expenses', points: top_expense_points, graphtype: 'bar', x_labels: top_expense_point_labels)
  send_event('money-top-expenses-table', table: top_expenses_table)
end
