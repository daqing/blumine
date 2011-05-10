namespace :blumine do
  desc "generate sample user data"
  task :sample_users => :environment do
    (1..30).each do |i|
      name = "nama-#{i}"
      User.create!(:name => name, :email => "#{name}@d.com", :password => name, :password_confirmation => name)
    end
  end
end
