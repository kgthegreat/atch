class Image < Asset
  has_attached_file :attachment,
  :styles => { :mini => '48x48>', :small => '100x100>', :product => '240x240>', :large => '600x600>' },
  :default_style => :product,
  :path => "assets/products/:id/:style/:basename.:extension" ,
  :storage => :s3,
  :bucket => 'aag-atch',
  :s3_credentials => {
    :access_key_id => ENV['S3_KEY'],
    :secret_access_key => ENV[['S3_SECRET']
  }
end
