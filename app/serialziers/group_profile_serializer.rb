class GroupProfileSerializer < GroupSerializer
  attributes :description, :description_html, :image, :mangas, :characters
  has_many :members, :animes, :mangas, :characters, :images

  def image
    {
      original: object.logo.url(:original),
      main: object.logo.url(:main),
      x73: object.logo.url(:x73),
      xo64: object.logo.url(:x48)
    }
  end
end
