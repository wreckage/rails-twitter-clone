require 'rails_helper'

describe ApplicationHelper do
    describe "full_title" do
        let(:base_title) { "Ruby on Rails Tutorial Sample App" }
        it "returns the correct title" do
            expect(full_title("foo")).to eq("foo | #{base_title}")
        end

        it "does not include a bar for the home page" do
            expect(full_title("")).to eq(base_title)
        end
    end
end

