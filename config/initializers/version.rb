# Version of the OpenVox Workshop currently running
OPENVOX_WORKSHOP_VERSION = "#{`git describe --tags --always`.chomp} (#{Rails::VERSION::STRING})".freeze
