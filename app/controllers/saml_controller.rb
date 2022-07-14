class SamlController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:consume]

    def init
        request = OneLogin::RubySaml::Authrequest.new
        redirect_to(request.create(saml_settings, email: "siva.g@email.com"))
    end

    def consume
        response          = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)

        # We validate the SAML Response and check if the user already exists in the system
        if response.is_valid?
        # authorize_success, log the user
            session[:userid] = response.nameid
            session[:attributes] = response.attributes
            p session

            render plain: "Successfully authenticated...."
        else
            authorize_failure  # This method shows an error message
        # List of errors is available in response.errors array
        end
    end

    def saml_settings
        idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
        settings = idp_metadata_parser.parse_remote("http://localhost:3000/saml/metadata")

        settings.assertion_consumer_service_url = "http://localhost:4000/saml/consume"
        settings.sp_entity_id                   = "http://localhost:4000"
        settings.private_key                    = File.read("#{Rails.root}/private-key.pem")
        #settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
        # Optional for most SAML IdPs
        #settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

        settings
    end
end
