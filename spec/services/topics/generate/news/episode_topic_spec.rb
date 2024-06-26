# frozen_string_literal: true

describe Topics::Generate::News::EpisodeTopic do
  subject do
    described_class.call(
      model: model,
      user: user,
      aired_at: aired_at,
      episode: episode
    )
  end

  let(:model) { create :anime }
  let(:episode) { 5 }

  let(:user) { BotsService.get_poster }
  let(:aired_at) { 2.days.ago }

  context 'without existing news topic' do
    it do
      expect { subject }.to change(Topic, :count).by 1
      is_expected.to have_attributes(
        forum_id: Topic::FORUM_IDS[model.class.name],
        generated: true,
        linked: model,
        user: user,
        processed: false,
        action: AnimeHistoryAction::Episode,
        value: episode.to_s
      )
      expect(subject.created_at.to_i).to eq aired_at.to_i
      expect(subject.updated_at).to be_nil
    end
  end

  context 'with existing news topic' do
    let!(:topic) do
      create :news_topic,
        linked: model,
        action: AnimeHistoryAction::Episode,
        value: topic_episodes_aired
    end
  end
end
