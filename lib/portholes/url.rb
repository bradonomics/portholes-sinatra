require 'addressable/uri'

module Portholes
  module URL

    TRACKING_PARAMS = ['affil', 'affiliate', 'app_id', 'client_', 'fb_', 'fbclid', 'ga_', 'hmb_', 'ic_', 'ncid', 'ocid', 'pd_rd', 'ref', 'ref_', 'referer', 'referrer', 'service_', 'share_', 'twclid', 'utm_', 'xid', 'yclid']

    def self.untrack(url)
      u = Addressable::URI.parse(url)
      return url unless u.query_values
      query_values = u.query_values.delete_if do |query_key|
        TRACKING_PARAMS.each do |param_key|
          TRACKING_PARAMS.include? query_key
        end
      end
      u.query_values = query_values.length > 0 ? query_values : nil
      u.to_s
    end

  end
end
