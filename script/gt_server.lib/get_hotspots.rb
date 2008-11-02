module GT
  class ImageInfo
    def get_hotspots()
      hotspots = []
      self.each_hotspot do |x1, y1, x2, y2, fn|
        hotspot = []
        hotspot[0] = x1
        hotspot[1] = y1
        hotspot[2] = x2
        hotspot[3] = y2
        feature = {}
        feature[:ID] = fn.get_attribute("ID")
        feature[:range] = fn.get_range
        feature[:type] = fn.get_type
        feature[:score] = fn.get_score
        feature[:attributes] = []
        fn.each_attribute do |key, value|
          feature[:attributes] << [key, value]
        end
        hotspot[4] = feature
        hotspots << hotspot
      end
      hotspots
    end
  end
end
