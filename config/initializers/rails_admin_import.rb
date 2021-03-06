RailsAdmin.config do |config|
  # REQUIRED:
  # Include the import action
  # See https://github.com/sferik/rails_admin/wiki/Actions
  header_converter = lambda do |header|
    # check for nil/blank headers
    next if header.blank?
    header
  end

  config.configure_with(:import) do |config|
    config.header_converter = lambda do |header|
      header
    end
  end


  config.actions do
    all
    import
  end


end
