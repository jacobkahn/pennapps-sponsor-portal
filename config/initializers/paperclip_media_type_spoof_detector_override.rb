require 'paperclip/media_type_spoof_detector'

# Paperclip doesn't unfortunately work correctly with SVGs
# this overrides the spoofing protection that prevents
# the file metadata content type mismatch to the
# incorrect file mappings withing the module.
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
