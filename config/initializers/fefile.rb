require 'refile/s3'

if Rails.env.production?
  aws = {
    access_key_id: ENV['S3_ACCESS_KEY_ID'], # アクセスキーID
    secret_access_key: ENV['S3_SECRET_ACCESS_KEY'], # シークレットアクセスキー
    region: 'ap-northeast-1',
    bucket: 'my-games-files',
  }
  Refile.cache = Refile::S3.new(prefix: 'cache', **aws)
  Refile.store = Refile::S3.new(prefix: 'store', **aws)
end