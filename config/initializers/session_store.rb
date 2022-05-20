Rails.application.config.session_store :cookie_store, key: "_rate_school_program_app", domain: "rate-school-program.com"
Rails.application.config.middleware.use ActionDispatch::Cookies
Rails.application.config.middleware.use Rails.application.config.session_store