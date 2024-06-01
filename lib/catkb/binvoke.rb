require "open3"

module CatKB
  def self.binvoke(exe, args = [], &block)
    exe = CatKB::ROOT_DIR / "target" / "release" / exe.to_s if exe.is_a?(Symbol)
    Open3.popen3(exe.to_s, *args) do |sin, sout, serr, thr|
      res = block.call(sin, sout, serr)

      sin.close
      sout.close
      serr.close
      thr.value

      res
    end
  end
end
