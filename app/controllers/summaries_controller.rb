require 'summarize'

class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show, :new, :create]
  skip_before_action :verify_authenticity_token

  # GET /summaries
  # GET /summaries.json
  def index
    @user = current_user
    @user.summaries = Summary.all
  end

  # GET /summaries/1
  # GET /summaries/1.json
  def show
    @slogan = params[:slogan]
    @related_summaries = @summary.find_related_tags
  end

  # GET /summaries/new
  def new
    @user = current_user
    @summary = Summary.new
    @summary.user = @user
  end

  # GET /summaries/1/edit
  # def edit
  # end

  # POST /summaries
  # POST /summaries.json
  def create
    article_url = params.dig(:summary, :article_url)
    @summary = Summary.new(article_url: article_url)

    digested_summary = Summarize.digest article_url
    @summary.title = digested_summary["title"]
    @summary.text = digested_summary["text"]

    @user = current_user
    @summary.user = @user

    uri = URI("https://aip.baidubce.com/rpc/2.0/nlp/v1/news_summary?charset=UTF-8&access_token=24.1ea3089fa3c4d91ea21b83759caeaae1.2592000.1578482131.282335-17980393")
    response = Net::HTTP::Post.new(uri)
    data = response.set_form_data("title" => Summary.find(6).title, "content" => Summary.find(6).text)

    respond_to do |format|
      if @summary.save
        format.html { redirect_to @summary, notice: 'Summary was successfully created.' }
        format.json { render json: @summary.text, status: :unprocessable_entity }
        format.js
        # format.json #{ render :partial => "summaries/show.json" }
      else
        format.html { render :new }
        format.json { render :create, status: :created, location: @summary }
      end
    end
  end

  # PATCH/PUT /summaries/1
  # PATCH/PUT /summaries/1.json
  def update
    respond_to do |format|
      if @summary.update(summary_params)
        format.html { redirect_to summaries_url, notice: 'Summary was successfully updated.' }
        format.js { head :no_content } #returning no content!!!
      else
        format.html { render :edit }
        format.json { render json: @summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /summaries/1
  # DELETE /summaries/1.json
  def destroy
    @summary.destroy
    respond_to do |format|
      format.html { redirect_to summaries_url, notice: 'Summary was successfully removed from Dashboard' }
      format.json { head :no_content }
    end
  end

  def favorite

  end

private

  def tagged
    @user = current_user
    if params[:tag].present?
      @summaries = Summary.tagged_with(params[:tag])
    else
      @summaries = Summary.all
    end
  end

  def add_tags
    @summary
    @summary.tag_list.add(params[:tag])
    @summary.save
  end

  def remove_tags
    @summary.tag_list.remove(params[])
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_summary
      @summary = Summary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def summary_params
      params.require(:summary).permit(:user_id, :title, :text, :article_url, :tag_list)
    end
end
