require 'rails_helper'

describe "Static pages" do

    subject { page }

    describe "Home page" do
        before { visit root_path }
        it { is_expected.to have_content('Sample App') }
        it { is_expected.to have_title("Ruby on Rails Tutorial Sample App") }

        describe "for users not signed in" do
            it { is_expected.to have_link(text: /Log in/i, href: login_path) }
            it { is_expected.to have_link(text: /Home/i, href: root_path) }
            it { is_expected.to have_link(text: /Help/i, href: help_path) }
        end

        describe "for signed in users" do
            let(:user) { FactoryGirl.create(:user_with_microposts) }
            before do
                log_in user
                visit root_path
            end

            it { is_expected.to have_link(text: /Log out/i, href: logout_path) }

            it "renders the user's feed" do
                user.feed.each { |item| expect(page).to have_content item.content }
            end

            describe "follower/following counts" do
                let(:other_user) { FactoryGirl.create(:user) }
                before do
                  other_user.follow(user)
                  visit root_path
                end

                it { is_expected.to have_link("0 following", href: following_user_path(user)) }
                it { is_expected.to have_link("1 followers", href: followers_user_path(user)) }
            end

        end
    end

    describe "About page" do
        before { visit about_path }
        it { is_expected.to have_content('About') }
        it { is_expected.to have_title("About | Ruby on Rails Tutorial Sample App") }
    end

    describe "Help page" do
        before { visit help_path }
        it { is_expected.to have_content('Help') }
        it { is_expected.to have_title("Help | Ruby on Rails Tutorial Sample App") }
    end

    describe "Contact page" do
        before { visit contact_path }
        it { is_expected.to have_content('Contact') }
        it { is_expected.to have_title("Contact | Ruby on Rails Tutorial Sample App") }
    end
end

