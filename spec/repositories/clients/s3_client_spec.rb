# frozen_string_literal: true

require 'repositories/clients/s3_client'

RSpec.describe S3Client do
  subject(:put) { described_class.put(key, content, content_type) }

  let(:key) { 'object-key' }
  let(:content) { 'bla' }
  let(:content_type) { 'application/json' }
  let(:bucket_name) { 'dummy-s3-bucket' }
  let(:s3) { instance_double(Aws::S3::Resource) }
  let(:bucket) { instance_double(Aws::S3::Bucket) }
  let(:object) { instance_double(Aws::S3::Object) }

  before do
    allow(ENVied).to receive(:HOLDING_DATA_S3_BUCKET).and_return(bucket_name)
    allow(Aws::S3::Resource).to receive(:new).and_return(s3)
    allow(s3).to receive(:bucket).and_return(bucket)
    allow(bucket).to receive(:object).and_return(object)
    allow(object).to receive(:put)
  end

  it 'accesses the S3 bucket' do
    expect(s3).to receive(:bucket).with(bucket_name).once
    put
  end

  it 'instantiates the S3 object with the key' do
    expect(bucket).to receive(:object).with(key).once
    put
  end

  it 'puts the content to s3' do
    expect(object).to receive(:put).with(
      body: content, content_type: content_type
    ).once
    put
  end
end
