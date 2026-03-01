require 'addressable/uri'

module Portholes
  module URL

    TRACKING_PARAMS = ['affil', 'affiliate', 'app_id', 'client_', 'fb_', 'fbclid', 'ga_', 'hmb_', 'ic_', 'ncid', 'ocid', 'pd_rd', 'ref', 'ref_', 'referer', 'referrer', 'service_', 'share_', 'token', 'twclid', 'utm_', 'xid', 'yclid']

    # https://www.bleepingcomputer.com/news/security/new-firefox-privacy-feature-strips-urls-of-tracking-parameters/
    # Olytics: oly_enc_id=, oly_anon_id=
    # Drip: __s=
    # Vero: vero_id=
    # HubSpot: _hsenc=
    # Marketo: mkt_tok=
    # Facebook: fbclid=, mc_eid=

    def self.untrack(url)
      u = Addressable::URI.parse(url)
      return url unless u.query_values
      query_values = u.query_values.delete_if do |query_key, _|
        TRACKING_PARAMS.any? { |param_key| query_key.start_with?(param_key) }
      end
      u.query_values = query_values.length > 0 ? query_values : nil
      u.to_s
    end

  end
end
