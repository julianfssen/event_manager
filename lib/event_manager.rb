require "csv"
require 'sunlight/congress'
puts "Event Manager Initialized"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zip)
    zip.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
    legislators = Sunlight::Congress::Legislator.by_zipcode(zip)

    legislator_names = legislators.collect do |legislator|
        "#{legislator.first_name} #{legislator.last_name}"
    end

    legislators_string = legislator_names.join(', ')
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
    name = row[:first_name]
    zip = row[:zipcode]

    zip = clean_zipcode(zip)
    legislators = legislators_by_zipcode(zip)

    puts "#{name}, #{zip}, #{legislators}"
end