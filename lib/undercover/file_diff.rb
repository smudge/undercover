module Undercover
  class FileDiff
    def initialize(l_file, r_file)
      self.left = l_file
      self.right = r_file
    end

    def changed?
      left&.coverage != right&.coverage
    end

    def filename
      left&.filename || right.filename
    end

  private

    attr_accessor :left, :right
  end
end
