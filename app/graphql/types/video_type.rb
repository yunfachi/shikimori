class Types::VideoType < Types::BaseObject
  field :id, ID
  field :name, String
  field :url, String
  field :kind, Types::Enums::Video::KindEnum
end