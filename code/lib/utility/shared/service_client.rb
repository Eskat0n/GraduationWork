require 'net/http'
require 'uri'
require 'nokogiri'

module SHR
  module Shared
    class ServiceClient
      def initialize service_url, fname_parameter, auth_params={}
        @service_url = URI.parse(service_url)
        @fname_parameter = fname_parameter
        @auth_params = auth_params
      end

      def method_missing method, *args
        params = (args.first or {})
                    .merge(@fname_parameter => method.to_s)
                    .merge(@auth_params)
                    
        responce = Net::HTTP.post_form(@service_url, params)
        process_responce(responce.body)
      end

      private
      def process_responce responce
        xml = Nokogiri::XML.parse(responce);

        # check for exception raised by web service
        exception = xml.at_xpath('/EXCEPTION')
        unless exception.nil?
          classname = exception[:class]
          message = exception.at_css('MESSAGE').text
          debuginfo = exception.at_css('DEBUGINFO').text

          raise WebServiceError.new(classname, message, debuginfo)
        end

        # fetch arrays and hashes from responce
        fetch(xml.at_xpath('/RESPONSE/*'))
      end

      private
      def fetch node
        method(:"fetch_#{node.name.downcase}").(node)
      end

      private
      def fetch_multiple node
        node.xpath('*').collect { |x| fetch(x) }
      end

      private
      def fetch_single node
        node.xpath('KEY').collect { |x| [ x[:name].to_sym, fetch(x.at_xpath('*')) ] }.hashize
      end

      private
      def fetch_value node
        node.text
      end
    end

    class WebServiceError < RuntimeError
      attr_reader :classname, :debuginfo

      def initialize classname, message, debuginfo
        super(message)
        @classname, @debuginfo = classname, debuginfo
      end
    end
  end
end
