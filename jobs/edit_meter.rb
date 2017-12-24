# Read all edit-meter fields from disk and send to the widgets
Dir["data/edit-meter/*"].each do |filename|
  id = filename.split('/')[-1]
  value = File.read(filename).to_i
  send_event(id, {value: value})
end


# When the user edits a field, write it to disk
# This is a terrible security situation and we should switch this out for a database
on_event 'edit-meter' do |data|
  # Never enough validation
  if data.key?('id') && data['id'].length < 128 && data['id'] =~ /[a-z\-]+/
    File.write("data/edit-meter/#{data['id']}", data['value'])
    send_event(data['id'], {value: data['value']})
  end
end
