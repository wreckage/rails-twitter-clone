require 'rails_helper'

describe "Authentication" do

  subject { page }

  describe "log in page" do
    before { visit login_path }

    it { is_expected.to have_selector('h1', text: 'Log in') }
  end

  describe "log in" do
    before { visit login_path }

    describe "with invalid information" do
        before { click_button "Log in" }
        it { is_expected.to have_selector('h1', text: 'Log in') }
        it { is_expected.to have_content("Invalid") }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: "password"
        click_button "Log in"
      end

      it { is_expected.to have_link('Profile', href: user_path(user)) }
      it { is_expected.to have_link('Log out', href: logout_path) }
      it { is_expected.not_to have_link('Log in', href: login_path) }
    end
  end

  #describe "authorization" do
  #    describe "for non-signed-in users" do
  #    end
  #end
end
