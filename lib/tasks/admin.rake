# TODO: Should create admin in a seed. No need for user input.
namespace :admin do
  # TODO: Why TODO??
  desc "TODO"
  task create: :environment do
    puts 'Enter admin name: '
    name = STDIN.gets.chomp
    puts 'email: '
    email = STDIN.gets.chomp
    p 'enter address: '
    address = STDIN.gets.chomp
    p 'enter contact no: '
    contact_no = STDIN.gets.chomp
    p 'enter about you: '
    about_me = STDIN.gets.chomp
    p 'enter password: '
    password = STDIN.gets.chomp

    a = Admin.create(name: name, email: email, address: address, about_me: about_me, contact_no: contact_no, password: password )
    p a.save
  end

end
