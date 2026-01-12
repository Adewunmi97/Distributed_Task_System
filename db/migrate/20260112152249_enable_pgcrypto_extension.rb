class EnablePgcryptoExtension < ActiveRecord::Migration[8.0]
  def change
    # Enable extensions if not already enabled
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  end
end
