# frozen_string_literal: true

class UsersController < ApplicationController
    def delete_account
      render inertia: 'users/index'
    end
  end
  