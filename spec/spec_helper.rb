RSpec.configure do |config|
  config.color = true
  config.tty = true

  config.before(:all) do
    unless File.exist?("cflinuxfs3.tar.gz")
      puts "Running `make` to create cflinuxfs3.tar.gz"
			IO.popen('make') do |io|
				while (line = io.gets) do
					puts line
				end
			end
    end
    puts "Importing cflinuxfs3/testing docker image created from cflinuxfs3.tar.gz"
    `docker import cflinuxfs3.tar.gz cflinuxfs3/testing`
  end
end
