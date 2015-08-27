def idDecode(id)
  id.split '@'
end

def idEncode(id, part)
  "#{id}@#{part}"
end


# arr -- list of course ids
# info -- map: id -> CourseInfo object
def optionsToHtml(arr, descriptions)
  arr.map {|elem| "<option value='#{elem}'>#{elem} (#{descriptions[idDecode(elem)[0]].name})</option>"}
     .join
end
