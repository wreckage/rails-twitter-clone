require 'rails_helper'

describe "Static pages" do

    subject { page }

    describe "Home page" do
        before { visit root_path }
        it { is_expected.to have_content('Sample App') }
        it { is_expected.to have_title("Ruby on Rails Tutorial Sample App") }
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

