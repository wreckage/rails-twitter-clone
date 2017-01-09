require 'rails_helper'

describe "User pages" do

    subject { page }

    describe "signup page" do
        before { visit signup_path }
        it { is_expected.to have_selector('h1', text: 'Sign up') }
        it { is_expected.to have_title("Sign Up | Ruby on Rails Tutorial Sample App") }
    end
end

