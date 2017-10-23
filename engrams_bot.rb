require_relative 'token'
require 'excon'
require 'json'

api_key = API_KEY

vendors = {
  0 => 'Devrim Kay',
  1 => 'MIDA Mini-Tool',
  2 => 'Sloane',
  3 => 'Failsafe',
  4 => 'Asher Mir',
  5 => 'Man O War',
  7 => 'Drang',
  8 => 'Commander Zavala',
  9 => 'Lord Shaxx',
  10 => 'Banshee-44',
  11 => 'Ikora Rey',
  12 => 'Benedict 99-40',
  13 => 'Lakshmi-2',
  14 => 'Executor Hideo',
  15 => 'Arach Jalaal',
  16 => 'The Emissary',
  17 => 'Lord Saladin'
}

types = {
  0 => '295',
  1 => '296-299',
  2 => 'possible 300',
  3 => '300',
  4 => 'need more data'
}

def map_vendor(id, hash)
  hash[id]
end

def map_type(id, hash)
  hash[id]
end

def fetch_all_drops(key)
  response = Excon.get("https://api.vendorengrams.xyz/getVendorDrops?key=#{key}&vendor=0")
  JSON.parse(response.body)
end

def extract_drops(drops, vendor_hash, type_hash)
  drops.select do |drop|
    drop["verified"] != 0
  end.map do |valid_drops|
    vendor = map_vendor(valid_drops["vendor"], vendor_hash)
    type = map_type(valid_drops["type"], type_hash)
    [vendor, type]
  end
end

def run_methods(api_key, vendor_hash, type_hash, past_drops = nil)
  fetched_drops = fetch_all_drops(api_key)
  extracted_drops = extract_drops(fetched_drops, vendor_hash, type_hash)
  if past_drops.nil? || extracted_drops != past_drops
    p extracted_drops
  end
  sleep(5)
  run_methods(api_key, vendor_hash, type_hash, extracted_drops)
end

run_methods(api_key, vendors, types)
