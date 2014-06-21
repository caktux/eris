#!/usr/bin/env ruby

class MemberRegistration

  def initialize member_registration_bylaw
    if member_registration_bylaw
      build_transaction member_registration_bylaw
    end
  end

  private

    def build_transaction member_registration_bylaw
      data      = [  ]
      Celluloid::Actor[:eth].transact member_registration_bylaw, data
    end
end