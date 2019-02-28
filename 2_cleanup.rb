#!/usr/bin/env ruby
require 'csv'

Record = Struct.new(*%i(page_num permit_year permit customer_name effective_date))
SCREWY_DATE_REGEX = %r{(?<effective_date>\d+/\d+/\d{2,4})(?<permit_year>\d{4})}

def concat_field(cur_val, new_val)
  return cur_val if (!new_val || new_val.empty?)
  return new_val if (!cur_val || cur_val.empty?)
  return cur_val + ' ' + new_val
end

output = CSV.open('./nyc_dot_placards_2015-2018.csv', 'w+')
output << %w(page_num permit_year permit_type customer_name effective_date)

record = Record.new
curpage = 1
lineno = 0

CSV.foreach('./extracted.csv') do |line|
  lineno += 1

  if record.all?
    unless /\d{4}/ =~ record.permit_year
      raise StandardError.new("Invalid permit year on line #{lineno}")
    end

    unless %r{\d{1,2}/\d{1,2}/\d{2,4}} =~ record.effective_date
      raise StandardError.new("Invalid effective date on line #{lineno}")
    end

    unless /\w+/ =~ record.customer_name
      raise StandardError.new("Invalid customer name on line #{lineno}")
    end

    unless %w(AAOSP ABPP CAPP).include? record.permit
      raise StandardError.new("Invalid permit #{record.permit} on line #{lineno}")
    end

    output << record.to_a
    output.flush
    curpage = line[0].to_i
    record = Record.new
  else
    if curpage != line[0].to_i
      raise StandardError.new("Truncated record at line #{lineno}")
    end
  end

  if (parts = SCREWY_DATE_REGEX.match(line[1]))
    permit_year = parts[:permit_year]
    effective_date = parts[:effective_date]
    puts "Correcting screwy date on line #{lineno}"
  else
    permit_year = line[1]
    effective_date = line[4]
  end

  record.page_num       = line[0]
  record.permit_year    = concat_field(record.permit_year, permit_year)
  record.permit         = concat_field(record.permit, line[2])
  record.customer_name  = concat_field(record.customer_name, line[3])
  record.effective_date = concat_field(record.effective_date, effective_date)
end
