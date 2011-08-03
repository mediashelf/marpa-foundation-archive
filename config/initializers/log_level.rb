### For some reason the log level is defaulting to :fatal, so force it back to debug

Rails.logger.level = 0 if Rails.env == 'development'
