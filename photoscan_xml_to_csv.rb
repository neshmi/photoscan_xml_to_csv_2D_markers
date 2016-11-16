require 'nokogiri'

Struct.new("Camera", :label, :id)
Struct.new("Location", :file_id, :gcp_id, :x, :y)

doc = Nokogiri::XML(File.read('test.xml'))

cameras = []
locations = []

doc.xpath('//camera').each do |xml_camera|
  camera = Struct::Camera.new
  camera.label = xml_camera.attributes["label"].value
  camera.id = xml_camera.attributes["id"].value
  cameras << camera
end

doc.xpath('//location').each do |xml_location|
  location = Struct::Location.new
  file_id = cameras.select{|camera| camera.id == xml_location.attributes["camera_id"].value}.first.label
  location.file_id = file_id
  location.gcp_id = xml_location.parent.attributes["label"].value
  location.x = xml_location.attributes["x"].value.to_f
  location.y = xml_location.attributes["y"].value.to_f
  locations << location
end

file = File.open("output.csv","w")
locations.each do |location|
  file.puts "#{location.file_id},#{location.gcp_id},#{location.x},#{location.y}"
end
file.close


