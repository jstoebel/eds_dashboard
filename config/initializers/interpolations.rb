Paperclip.interpolates('bnum') do |attachment, style|

  attachment.instance.student_id
end

Paperclip.interpolates('term') do |attachment, style|
  attachment.instance.BannerTerm_BannerTerm
end

#not in use
# Paperclip.interpolates('altid') do |attachment, style|
# 	#for AltID
#   attachment.instance.AltID

  Paperclip.interpolates('id') do |attachment, style|
	#for id
  attachment.instance.id
end

