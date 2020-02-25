require "csv"
require 'sunlight/congress'
require 'erb'
puts "Event Manager Initialized"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zip)
    zip.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
    legislators = Sunlight::Congress::Legislator.by_zipcode(zip)
end

def generate_letter(id, form_letter)
    Dir.mkdir("output") unless Dir.exists? "output"

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
        file.puts form_letter
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
    id = row[0]
    name = row[:first_name]
    zip = row[:zipcode]

    zip = clean_zipcode(zip)
    legislators = legislators_by_zipcode(zip)

    form_letter = erb_template.result(binding)

    generate_letter(id, form_letter)
end