require File.expand_path("../../spec_helper", __FILE__)

# Runs against a real CouchDB that needs a login. Set COUCHUSER and COUCHPASSWORD to an admin login.
describe "Reading and writing CouchDB with username: and password:" do

  let(:db_name) { "couchrest-login-test" }
  let(:db_url) { "#{COUCHHOST}/#{db_name}" }
  let(:server) { CouchRest.new(:url => COUCHHOST, **COUCH_LOGIN) }

  before do
    pending "set COUCHUSER and COUCHPASSWORD to run against a CouchDB that needs a login" if COUCH_LOGIN[:username].nil?
    begin
      server.database(db_name).delete!
    rescue CouchRest::NotFound
      # nothing left from an earlier run
    end
    server.create_db(db_name).save_doc("_id" => "doc", "msg" => "it works")
  end

  after do
    server.database(db_name).delete! unless COUCH_LOGIN[:username].nil?
  end

  it "should return documents through a Server" do
    db = server.database(db_name)
    expect(db.get("doc")["msg"]).to eql("it works")
    expect(db.all_docs["rows"].map { |row| row["id"] }).to eql(["doc"])
  end

  it "should return documents through CouchRest.database" do
    db = CouchRest.database(db_url, **COUCH_LOGIN)
    expect(db.get("doc")["msg"]).to eql("it works")
  end

  it "should return documents through CouchRest.get" do
    expect(CouchRest.get("#{db_url}/doc", COUCH_LOGIN.dup)["msg"]).to eql("it works")
  end

  it "should be refused without the login" do
    expect { CouchRest.new(:url => COUCHHOST).database(db_name).get("doc") }.to raise_error(CouchRest::Unauthorized)
  end

end
