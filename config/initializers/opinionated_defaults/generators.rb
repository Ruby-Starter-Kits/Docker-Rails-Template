# Disable a few of the generators I often just delete after they're created.
Rails.application.config.generators do |g|
  g.assets false
  g.helper false
  g.view_specs false
  g.decorator false
  g.system_tests = nil
  g.jbuilder false
end
