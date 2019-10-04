module Util
  module TypeChecking
    private

    def check_type(obj, type = self.class)
      raise TypeError unless obj.is_a?(type)
    end
  end
end
