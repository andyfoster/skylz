# frozen_string_literal: true

class StaticPagesController < ApplicationController

  def home
    render layout: 'guest'
  end

  def faq
    render layout: 'guest'
  end

  def api
    # render layout: 'guest'
    @api = File.read("#{Rails.root}/developers.md")
  end

  # def api_docs
  #   # render layout: 'guest'
  #   #   display markdown file
  #   # render file: 'static_pages/api_docs.md', layout: 'guest'
  #   render 'static_pages/api_docs.md', layout: false, content_type: 'text/plain'
  # end
end
