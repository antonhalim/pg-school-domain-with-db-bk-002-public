require_relative '../config/environment'
PG.connect.exec('DROP DATABASE IF EXISTS school_domain_test')
PG.connect.exec('CREATE DATABASE school_domain_test')
DB[:conn] = PG.connect(dbname: 'school_domain_test')

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :progress # :progress, :html, :textmate

  #you can do global before/after here like this:
  config.before(:each) do
    if Student.respond_to?(:create_table)
      Student.drop_table
      Student.create_table
    else
      DB[:conn].exec("DROP TABLE IF EXISTS students")
      DB[:conn].exec("CREATE TABLE IF NOT EXISTS students (id SERIAL PRIMARY KEY, name TEXT, tagline TEXT, github TEXT, twitter TEXT, blog_url TEXT, image_url TEXT, biography TEXT)")
    end
  end

  config.after(:each) do
    if Student.respond_to?(:drop_table)
      Student.drop_table
    else
      DB[:conn].exec("DROP TABLE IF EXISTS students")
    end
  end
end
