describe MalParsers::FetchEntryAuthorized do
  # TODO: move :vcr to MalParsers::AnimeAuthorized and
  #       stub call to MalParsers::AnimeAuthorized here
  describe '#perform', :vcr do
    before { Timecop.freeze '2017-01-18 23:28:00' }
    after { Timecop.return }

    subject!(:call) { described_class.new.perform anime_id }

    let(:anime_id) { 28_851 }
    let(:anime) { Anime.find(anime_id) }

    it do
      anime.reload
      expect(anime.external_links).to have(4).items
      expect(anime.authorized_imported_at)
        .to be_within(0.1).of(Time.zone.now)
    end
  end
end
