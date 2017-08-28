# frozen_string_literal: true

require 'spec_helper'

describe iam_group('TFUsersGroup') do
  it { should exist }
  it { should have_inline_policy('TFUsersPolicy') }
end

describe iam_user('tf_user') do
  it { should exist }
  it { should belong_to_iam_group('TFUsersGroup') }
end
