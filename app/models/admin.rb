class Quickadmin::Admin
  
  def self.find(openid_url)
    file = Merb.root / 'config' /  'quickadmins.yaml'
    admins = YAML::load(File.open(file))
    result = nil
    admins.each do |a|
      if normalize_url(a) == normalize_url(openid_url)
        result = normalize_url(a)
      end
      break if result
    end
    result
  end
  
  private
  
  def self.normalize_url(url)
    url =~ /^(http(s)?:\/\/)?([^\/]+)/
    $3
  end

end