#!/opt/ruby
str = "Ramesh Rathode (Adilabad (ST)), Zahid Ali Khan (Hyderabad), Jitender Reddy (Chevella), Nama Nageswara Rao (Khammam), Kinjarapu Yerrannaidu (Srikakulam), Kondapalli Appala Naidu (Vizianagaram), M.V.S.Murthy (Visakhapatnam), Suryaprakasa Rao (Anakapalle), Vasamsetti Satya (Kakinada), Varalakshmi (Amalapuram (SC)), Maganti Babu (Eluru), Konigalla Narayana (Machilipatnam), Vamsi Mohan (Vijayawada), Modugula Venugopal Reddy (Narasaraopet), Sriram Malaydri (Bapatla (SC)), M.M. Kondaiah (Ongole), Farooq (Nandyal), K. Srinivasulu (Anantapur), Palem Srikanth Reddy (Kadapa), Vonteru Venugopal Reddy (Nellore), E. Jyostna (Tirupati (SC)), N. Shiva Prasad (Chittoor (SC))"
str.split(",").each do |p|
  list = p.split("(")
  city= list[1]
  city.index(")").nil? ? city : city.gsub!(")","")
  puts "- #{city.strip}"
  puts "- #{list[0].strip}"
end
