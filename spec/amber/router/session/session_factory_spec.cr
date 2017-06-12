
require "../../spec_helper"

module Amber::Router::Session

  describe StoreFactory do

    it "creates a cookie session store" do
      store = StoreFactory.build()
    end

    it "creates a redis session store" do

    end
  end
end