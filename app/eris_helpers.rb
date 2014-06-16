#!/usr/bin/env ruby

helpers do
  def address_guard contract
    contract = "0x#{contract}" unless contract[0..1] == '0x'
    contract
  end

  def address_unguard contract
    if contract.class == String
      contract = contract[2..-1] if contract[0..1] == '0x'
    elsif contract.class == Array
      tmp = []
      until contract.empty?
        c = contract.shift
        c = c[2..-1] if c[0..1] == '0x'
        tmp.push c
      end
      contract = tmp
    end
    contract
  end

  def find_the_peak contract
    lineage  = []
    parent   = $eth.get_storage_at contract, '0x14'
    until parent == '0x'
      lineage << parent
      child  = parent
      parent = $eth.get_storage_at parent, '0x14'
      break if child == parent
    end
    return lineage
  end

  def get_dougs_storage position
    unless position[0..1] == '0x'
      position = EPM::HexData.construct_data [position]
    end
    return $eth.get_storage_at $doug, position
  end

  def contract_type this_contract, contents, lineage
    # type 0 is a post||individual blob
    # type 1 is a thread||middle group level
    # type 2 is a topic||high group level
    # type 3 is a swarum_top||top level AB
    begin
      if contents.count == 1 && this_contract == contents.first.first[0]
        return 0
      elsif lineage.count == 0
        return 3
      elsif lineage.count == 1
        return 2
      end
    end
    return 1
  end
end