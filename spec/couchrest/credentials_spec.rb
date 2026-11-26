require File.expand_path("../../spec_helper", __FILE__)

describe CouchRest::Credentials do

  let(:credentials) { CouchRest::Credentials.new("user", "secret") }

  it "should keep the password out of inspect, to_s and JSON" do
    text = [credentials.inspect, credentials.to_s, credentials.as_json, credentials.to_json, MultiJson.encode(:login => credentials)].join("\n")
    expect(text).not_to include("secret")
  end

  it "should be empty without a username" do
    expect(CouchRest::Credentials.new(nil, "secret")).to be_empty
    expect(credentials).not_to be_empty
  end

  it "should compare by value" do
    expect(credentials).to eql(CouchRest::Credentials.new("user", "secret"))
    expect(credentials.hash).to eql(CouchRest::Credentials.new("user", "secret").hash)
    expect(credentials).not_to eql(CouchRest::Credentials.new("user", "other"))
  end

end
