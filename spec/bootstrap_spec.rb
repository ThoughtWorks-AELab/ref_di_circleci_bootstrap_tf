# frozen_string_literal: true

require 'spec_helper'

describe iam_user('circle-bootstrap') do
  it { should exist }
end
