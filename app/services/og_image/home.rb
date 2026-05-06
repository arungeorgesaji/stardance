module OgImage
  class Home < IndexPage
    PREVIEWS = {
      "default" => -> { new }
    }.freeze

    def initialize
      super(title: "Stardance")
    end
  end
end
