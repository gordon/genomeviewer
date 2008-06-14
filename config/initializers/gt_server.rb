require 'drb'
DRb.start_service
GTServer = DRbObject.new(nil, 'druby://localhost:7777')
