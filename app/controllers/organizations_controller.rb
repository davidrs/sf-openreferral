class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :set_organization_groups, :set_tags

  def index
    sidebar
  end

  def pending
    @organizations = Organization.where(status: "pending")
  end

  def change_status
    @organization = Organization.find(params[:id])
    @organization.update(status: params[:status])
    render :show
  end

  def sidebar
    @organization_groups = Organization.
      order(status: :desc, name: :asc).
      group_by(&:status)
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to @organization, notice: t(".success")
    else
      render :new
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: t(".success")
    else
      render :edit
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: t(".success")
  end

  private

  def set_organization_groups
    @organization_groups = Organization.all.group_by(&:status)
  end

  def set_tags
    @tags = ActsAsTaggableOn::Tag.all
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(
      :accessibility,
      :address,
      :demographics,
      :description,
      :fees,
      :name,
      :service_list,
      :status,
      :url,
      emails: [],
      languages: [],
      phones: [],
    )
  end
end
