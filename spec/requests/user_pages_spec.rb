require 'rails_helper'

describe "User pages" do

    subject { page }

    describe "profile page" do
        let(:user) { FactoryGirl.create(:user) }
        before { visit user_path(user) }
        it { is_expected.to have_selector('h1', text: user.name) }
    end


    describe "signup page" do
        before { visit signup_path }
        it { is_expected.to have_selector('h1', text: 'Sign up') }
        it { is_expected.to have_title("Sign Up | Ruby on Rails Tutorial Sample App") }
    end

    describe "signup" do
        before { visit signup_path }
        let(:submit) { "Create my account" }

        describe "with invalid information" do
            it "does not create a user" do
                expect { click_button submit }.not_to change(User, :count)
            end
        end

        describe "with valid information" do
            before do
              fill_in "Name",         with: "Example User"
              fill_in "Email",        with: "user@example.com"
              fill_in "Password",     with: "foobar"
              fill_in "Password confirmation", with: "foobar"
            end

            it "creates a user" do
              expect { click_button submit }.to change(User, :count).by(1)
            end
        end
    end
end
