module InvalidUsers

  #
  # usage: InvalidUsers.each {|params_hsh, msg| ... }
  #
  def self.each(&block)
    include ParamsHashes
    yield NoEmail, "no email was specified"
    yield NoPass, "no password was specified"
    yield NoName, "no name was specified"
    yield InvalidEmail, "the given email was invalid"
    yield ShortName, "the given name was too short"
    yield LongEmail, "the given email was too long"
  end

  module ParamsHashes

    # validates_presence_of

    NoEmail = {
      :name => "John Smith",
      :password => "password"
    }

    NoPass = {
      :name => "Another John Smith",
      :email => "email@smith.test"
    }

    NoName = {
      :password => "genomeviewer",
      :email => "genome@viewer.test"
    }

    # validates_format_of

    InvalidEmail = {
      :name => "genomeviewer",
      :password => "genomeviewer",
      :email => "I haven't got one"
    }

    # validates_lenght_of

    ShortName = {
      :name => "abc",
      :password => "somepass",
      :email => "test@test.end"
    }

    LongEmail = {
      :name => "Some Valid Name",
      :password => "passw",
      :email => "this.email.address.is.really.definitely.too.too.long.to@be_accept.ed"
    }
  end
end
