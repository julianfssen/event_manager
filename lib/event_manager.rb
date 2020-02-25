require "csv"
puts "Event Manager Initialized"

def clean_zipcode(zip)
    if zip.nil?
        zip = '00000'
    elsif zip.length > 5
        zip = zip[0..4]
    elsif zip.length < 5
        zip = zip.rjust 5, "0"
    else
        zip
    end
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
    name = row[:first_name]
    zip = row[:zipcode]

    zip = clean_zipcode(zip)

    puts "#{name}, #{zip}"
end