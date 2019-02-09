class Dog
  attr_accessor :name, :breed 
  attr_reader :id 
  
  def initialize(id:nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed 
  end
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      )
    SQL
    
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"

    DB[:conn].execute(sql)  
  end
  
  def self.new_from_db(row)
    new_dog = self.new(row[0], row[1], row[2])
    new_dog
  end
  
  def self.find_by_name(name)
    sql = "SELECT * FROM dogS WHERE name = ? LIMIT 1"
    result = DB[:conn].execute(sql, name)
    Dog.new(result[0], result[1], result[2])
  end
     
  def update
    sql = "UPDATE dogs SET  name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def save
    if self.id
      self.update 
    else
      self.insert
    end
    self
  end
  
  def insert 
    sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
        
  def self.create(hash)
    dog = Dog.new(name, breed)
    dog.save 
    dog
  end
      
end