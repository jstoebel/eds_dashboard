Paperclip.interpolates('bnum') do |attachment, style|
	#for adm_tep
  attachment.instance.Student_Bnum
end

Paperclip.interpolates('term') do |attachment, style|
	#for adm_tep
  attachment.instance.BannerTerm_BannerTerm
end

Paperclip.interpolates('altid') do |attachment, style|
	#for AltID
  attachment.instance.AltID
end

