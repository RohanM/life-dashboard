# Read all edit-text fields from disk and send to the widgets
Dir["data/edit-text/*"].each do |filename|
  id = filename.split('/')[-1]
  content = File.read(filename)
  send_event(id, {content: content})
end


# When the user edits a field, write it to disk
# This is a terrible security situation and we should switch this out for a database
on_event 'edit-text' do |data|
  # Never enough validation
  if data.key?('id') && data['id'].length < 128 && data['id'] =~ /[a-z\-]+/
    File.write("data/edit-text/#{data['id']}", data['content'])
    send_event(data['id'], {content: data['content']})
  end
end
