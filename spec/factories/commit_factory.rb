require "as-duration"

FactoryBot.define do
  factory :commit, class: FakeGit::Commit do
    skip_create

    repo { nil }
    message { Faker::Lorem.sentence(rand(3..10)) }
    changed_files { [SecureRandom.hex(20).to_s] }
    author_name { Faker::Name.name }
    author_email { Faker::Internet.email }
    author_date {
      [
        Faker::Time.between(1.minute.ago, Time.now, :between),
        Faker::Time.between(1.hour.ago, 1.minute.ago, :between),
        Faker::Time.between(1.day.ago, 1.hour.ago, :between),
        Faker::Time.between(1.week.ago, 1.day.ago, :between),
        Faker::Time.between(1.month.ago, 1.week.ago, :between),
        Faker::Time.between(1.year.ago, 1.month.ago, :between),
        Faker::Time.between(10.years.ago, 1.year.ago, :between),
      ].sample
    }

    after(:create) do |commit, evaluator|
      evaluator.repo.commits << commit if evaluator.repo
    end
  end
end
