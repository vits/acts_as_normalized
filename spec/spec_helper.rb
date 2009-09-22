begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db(table, columns)
  tmp = $stdout
  $stdout = StringIO.new # disable AR schema statements
  ActiveRecord::Schema.define(:version => 1) do
    create_table table do |t|
      columns.each_pair do |name, type|
        t.column name, type
      end
    end
  end
  $stdout = tmp
end
 
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
