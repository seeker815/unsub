module Unsub
  module Service
    class Base
      def extend_host h ; h end
      def log ; @log end
    end
  end
end