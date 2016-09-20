require 'sqlite3'

db = SQLite3::Database.new 'barbershop.db'
#db.results_as_hash = true
@barbers = db.execute('select * from Barbers');
print @barbers
print db.execute('select count(*) from users')[0][0]
puts
db.execute('select * from users') do |row|
  #puts "#{row['Name']}\t-\t#{row['DateStamp']}"
  #row.each {|key, val| puts "#{key}, #{val}"}
  #puts "<td>#{row.join("</td><td>")}</td>"
  #puts row.slice!(0)
  @usr_table = Hash.new([])
    db.execute('select * from users order by id desc') do |row|
      @usr_table[row.slice!(0)] = "<td>#{row.join("</td><td>")}</td>"
  end
end
  print @usr_table
