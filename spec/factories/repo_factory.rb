require "tmpdir"

FactoryBot.define do
  factory :repo, class: FakeGit::Repo do
    skip_create

    directory { Dir.mktmpdir("gitrepo") }
    commits { [] }
  end
end
