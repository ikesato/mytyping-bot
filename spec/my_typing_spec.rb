# -*- coding: utf-8 -*-
require 'spec_helper'
require 'my_typing'

describe MyTyping do
  it "should set appid and location" do
    mt = MyTyping.new
    mt.scrape("39679")
    expect(w.appid).to eq "abc"
    expect(w.location).to eq({lat: 35.0, lng: 139.0})
  end
end
