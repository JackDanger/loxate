root = File.expand_path(File.dirname(__FILE__))

require File.join(root, 'datastore')

autoload :Email,    File.join(root, 'email')
autoload :Location, File.join(root, 'location')
autoload :Visit,    File.join(root, 'visit')
['email', 'location', 'visit'].each do |model|
  require File.join(root, model)
end
