require 'pg'
require_relative '../lib/student'

DB = {:conn => PG.connect(dbname: 'students')}
