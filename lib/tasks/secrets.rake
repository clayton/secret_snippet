namespace :secrets do
  desc "Removes expired secrets from the database"
  task expire: :environment do
    Secret.where(["expires_at < ?", Time.now]).delete_all
  end

end
