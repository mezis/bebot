require 'spec_helper'
require 'bebot/models/contributor'
require 'bebot/models/comparator'
require 'yaml'

describe Bebot::Models::Comparator do

  let(:client) { double('client') }
  let(:data) { DATA_COMPARE } 
  subject { described_class.new client:client, repo:'superbath', from:'master', to:'production' }

  before do
    allow(client).to receive(:compare) {
      Hashie::Mash.new(YAML.load(data))
    }
  end

  describe '#contributors' do
    it 'lists contributors' do
      expect(subject.contributors).to be_a_kind_of(Array)
      subject.contributors.each do |c|
        expect(c).to be_a_kind_of(Bebot::Models::Contributor)
      end
    end

    it 'orders by descending staleness' do
      expect(subject.contributors.first.login).to eq('charlie')
    end

    it 'excludes mergers' do
      expect(subject.contributors.map(&:login)).not_to include('alice')
    end

    context 'when branches are identical' do
      let(:data) { DATA_COMPARE_EMPTY }

      it 'is empty' do
        expect(subject.contributors).to be_empty
      end
    end
  end

  describe '#staleness' do
    it 'returns seconds since oldest commit' do
      Timecop.freeze '2013-07-21T11:22:42Z' do
        expect(subject.staleness).to eq(2.0)
      end
    end
  end

  describe '#commits' do
    it 'returns number of commits' do
      expect(subject.commits).to eq(4)
    end
  end

  describe '#pull_requests' do
    it 'returns number of pull requests' do
      expect(subject.pull_requests).to eq(1)
    end
  end

end



DATA_COMPARE = <<-YAML
---
status: ahead
ahead_by: 6
behind_by: 0
total_commits: 6
commits:
- sha: 5d434dfca61ca06525760c94f36bffde02a9516c
  commit:
    author:
      name: Bob
      email: bob@foo.com
      date: 2013-07-23T09:22:42Z
    committer:
      name: Bob
      email: bob@foo.com
      date: 2013-07-23T09:22:42Z
    message: hi there
    tree:
      sha: e5c35a72aeed9c32da531e4289864123c3619727
    comment_count: 0
  author:
    login: bob
    id: 605293
    gravatar_id: '5678'
    type: User
  committer:
    login: bob
    id: 605293
    gravatar_id: '5678'
    type: User
  parents:
  - sha: 2e5c2eef3be198db9528458b6a628c6cd74ab4a6
- sha: 99d311a1018e77d02e4931af3988535ced4aee8c
  commit:
    author:
      name: Charlie
      email: charlie@foo.com
      date: 2013-07-23T10:43:56Z
    committer:
      name: Charlie
      email: charlie@foo.com
      date: 2013-07-23T10:43:56Z
    message: hi there
    tree:
      sha: 327b8fd89f7ba43db93b3ca4e178afa30937800a
    comment_count: 0
  author:
    login: charlie
    id: 115590
    gravatar_id: 90ab
    type: User
  committer:
    login: charlie
    id: 115590
    gravatar_id: 90ab
    type: User
  parents:
  - sha: 2ea6b41aa882201bae9dca59b9ada6074054d889
- sha: 362ab02a61740c5e5c224e473162b20975e14b96
  commit:
    author:
      name: Charlie
      email: charlie@foo.com
      date: 2013-07-23T11:31:08Z
    committer:
      name: Charlie
      email: charlie@foo.com
      date: 2013-07-23T11:31:08Z
    message: hi there
    tree:
      sha: 327b8fd89f7ba43db93b3ca4e178afa30937800a
    comment_count: 0
  author:
    login: charlie
    id: 115590
    gravatar_id: 90ab
    type: User
  committer:
    login: charlie
    id: 115590
    gravatar_id: 90ab
    type: User
  parents:
  - sha: 2ea6b41aa882201bae9dca59b9ada6074054d889
  - sha: 99d311a1018e77d02e4931af3988535ced4aee8c
- sha: 76e1b1c12f6e42973c4c647e9fb046156016f5d7
  commit:
    author:
      name: Alice
      email: alice@foo.com
      date: 2013-07-21T09:22:42Z
    committer:
      name: Alice
      email: alice@foo.com
      date: 2013-07-23T12:36:45Z
    message: 'Merge pull request #1337 from org/foo/bar'
    tree:
      sha: 5fa0031d17eef58eaa5b01351f25316e89c699e5
    comment_count: 0
  author:
    login: alice
    id: 353922
    gravatar_id: '1234'
    type: User
  committer:
    login: alice
    id: 353922
    gravatar_id: '1234'
    type: User
  parents:
  - sha: 362ab02a61740c5e5c224e473162b20975e14b96
  - sha: ea72a8d1c4ccad1ba06dc5e775e2f8af6660123c
YAML


DATA_COMPARE_EMPTY = <<-YAML
---
status: identical
ahead_by: 0
behind_by: 0
total_commits: 0
commits: []
YAML
