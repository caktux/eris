#!/usr/bin/env ruby

class VotePost
  attr_reader :voted

  def initialize post_id, up_or_down, up_down_vote_bylaw
    @voted = false
    if up_or_down == 'upvote' or up_or_down == 'downvote'
      if post_id
        set_baseline post_id, up_or_down
        build_transaction post_id, up_or_down, up_down_vote_bylaw
        get_values post_id, up_or_down
      end
    end
  end

  private

    def set_baseline post_id, up_or_down
      if up_or_down == 'upvote'
        @base = Celluloid::Actor[:eth].get_storage_at post_id, '0x19'
      elsif up_or_down == 'downvote'
        @base = Celluloid::Actor[:eth].get_storage_at post_id, '0x20'
      end
    end

    def build_transaction post_id, up_or_down, up_down_vote_bylaw
      data      = [ up_or_down, post_id ]
      Celluloid::Actor[:eth].transact up_down_vote_bylaw, data
    end

    def get_values post_id, up_or_down
      sleep 0.1                # to make sure the client has received the tx and posted to state machine
      if up_or_down == 'upvote'
        post = Celluloid::Actor[:eth].get_storage_at post_id, '0x19'
      elsif up_or_down == 'downvote'
        post = Celluloid::Actor[:eth].get_storage_at post_id, '0x20'
      end
      @voted = true if post != @base
    end
end