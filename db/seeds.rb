require "./db/models.rb"

def destroy_all
    Child.destroy_all
    Parent.destroy_all
end

def put_all
    puts Child.find_each.as_json
    puts Parent.find_each.as_json
end

destroy_all
# put_all

#------------------

## TODO: user constructors
def seed
    child = Child.new
    child.name = "ребенок тест"
    child.auth_token = "CHILD_TOKEN"
    child.connect_key = "CONNECT_KEY"
    child.save
    
    parent = Parent.new
    parent.name = "родитель тест"
    parent.auth_token = "PARENT_TOKEN"
    parent.save         
end

seed

#------------------

put_all
