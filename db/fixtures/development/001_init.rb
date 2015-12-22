uploader_dir = "#{Rails.root}/public/uploads"
if File.exist?(uploader_dir)
  FileUtils::rm_r(uploader_dir)
end


emails = %w{ andrew.zhyl@gmail.com 381051507@qq.com}
emails.each_with_index do |email, index|
  User.seed do |s|
    s.id    = index + 1
    s.email = email
    s.password = "111111"
    s.password_confirmation = "111111"
    if email == 'andrew.zhyl@gmail.com'
      s.role = :admin
    end
  end
end