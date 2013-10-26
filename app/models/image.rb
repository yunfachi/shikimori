class Image < ActiveRecord::Base
  include PermissionsPolicy
  belongs_to :uploader, class_name: User.name,
                        foreign_key: :uploader_id
  belongs_to :owner, polymorphic: true

  has_attached_file :image,
                    styles: {
                      main: '1920x1200>',
                      preview: '178x534>'
                    },
                    url: '/images/image/:style/:id.:extension',
                    path: ':rails_root/public/images/image/:style/:id.:extension',
                    processors: [:cropper]

  validates_attachment_presence :image
  validates_presence_of :uploader
  validates_presence_of :owner

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_image, if: :cropping?

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank? && crop_h != '0' && crop_w != '0'
  end

  def to_param
    "#{id}-#{updated_at.to_i}"
  end

  def geometry(style=:main)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end

private
  def reprocess_image
    image.reprocess!
    FileUtils.cp(image.path(:main), image.path(:original))
  end
end
