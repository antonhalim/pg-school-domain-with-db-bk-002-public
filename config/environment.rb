require 'pg'
require_relative '../lib/student'

# DB = {:conn => SQLite3::Database.new("db/students.db")}
DB = {:conn => PG.connect(dbname: 'students')}
