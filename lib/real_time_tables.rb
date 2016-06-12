require 'soap/rpc/driver'

module RealTimeTables

  # Endpoints specified at:
  #   http://developer.reittiopas.fi/media/Omat_Lahdot_v101.pdf

  HSL_URL             = 'http://omatlahdot.hkl.fi/interfaces/kamo'
  INTERFACE_NAMESPACE = 'urn:seasam'

  class Stop
    DEFAULT_COUNT = 20

    def initialize(stop_id)
      @hsl_api = SOAP::RPC::Driver.new(HSL_URL, INTERFACE_NAMESPACE)
      @hsl_api.add_method('getNextDeparturesExtRT', 'String_1', 'Date_2', 'int_3')
      @stop_id = stop_id
    end

    def get_next_20_departures
      @hsl_api.getNextDeparturesExtRT(@stop_id, Time.now, DEFAULT_COUNT)
    end

    def parse_hsl_api_response(response)
      response.map { |departure| [departure.time, departure.rtime, departure.line] }
    end

  end
end
