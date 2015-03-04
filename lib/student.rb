require 'pry'
class Student

  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography

  def self.db
    DB[:conn]
  end

  def db
    self.class.db
  end

  def self.drop_table
      execute("DROP TABLE IF EXISTS students")
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students
    (id SERIAL PRIMARY KEY,
    name TEXT,
    tagline TEXT,
    github TEXT,
    twitter TEXT,
    blog_url TEXT,
    image_url TEXT,
    biography TEXT)
    SQL
    execute(sql)
  end

  def self.execute(sql, args=[])
    db.exec_params(sql, args)
  end

  def execute(sql, args=[])
    self.class.execute(sql, args)
  end

  def insert
      result = execute("INSERT INTO students (name, tagline, github, twitter, blog_url, image_url, biography) VALUES
    ($1, $2, $3, $4, $5, $6, $7) RETURNING id", [name, tagline, github, twitter, blog_url, image_url, biography])
    self.id = result[0]["id"].to_i
  end

  def self.new_from_db(hash)
    student = Student.new
    student.id = hash["id"].to_i
    student.name = hash["name"]
    student.tagline = hash["tagline"]
    student.github = hash["github"]
    student.twitter = hash["twitter"]
    student.blog_url = hash["blog_url"]
    student.image_url = hash["image_url"]
    student.biography = hash["biography"]
    student
  end

  def self.find_by_name(string)
    begin
    result = execute('SELECT * FROM students WHERE name = $1', [string])
    new_from_db(result[0])
  rescue
    nil
  end
  end

  def save
    if self.id == nil
    self.insert
  else
    update
  end
  end

  def update
    name = self.name
    id = self.id
    param = [name, id]
    execute('UPDATE students SET name = $1 WHERE id = $2', param)
  end

end
