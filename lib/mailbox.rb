require 'yaml'
require 'pp'
require 'json'
require 'httparty'
require 'fileutils'

class Mailbox
  include HTTParty
  base_uri 'https://api.mailbox.org/v1/'
  AUTH_FILE = '.auth.yml'

  def initialize
    @options = {
        headers: {
            'User-Agent': 'mailbox-cli+ruby',
            'Content-Type': 'text/json',
            'Accept' => 'text/json'
        }
    }
  end

  def auth(user, pass)
    credentials = {
        user: user,
        pass: pass,
        auth_id: '',
        auth_level: ''
    }

    response = self.class.post('/', @options.merge({ body: request_object('auth', { user: credentials[:user], pass: credentials[:pass]}) }))
    begin
      body = JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError
      raise Thor::Error.new("Unexpected response from Mailbox API")
    end

    parse_response(body) do |response|
      credentials[:auth_id]    = response[:session]
      credentials[:auth_level] = response[:level]

      # Write auth id to file.
      File.open(AUTH_FILE, "w") { |file| file.write(credentials.to_yaml) }

      puts "\nAuthentication successful."
    end
  end

  def deauth
    send_request('deauth') do |response|
      if response.to_s == 'true'
        puts 'Successfully logged out.'
      else
        puts "Logout unsuccessful."
      end
      FileUtils.rm '.auth.yml'
      puts 'Existing AuthInfo deleted.'
    end
  end

  def hello_world
    send_request('hello.world') do |response|
      puts response
    end
  end

  def hello_innerworld
    send_request('hello.innerworld') do |response|
      puts response
    end
  end

  def account_add(account, password, plan, memo)
    send_request('account.add', { account: account, password: password, plan: plan, memo: memo }) do |response|
      response.each do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end

  def account_get
    account = session_account
    send_request('account.get', { account: account }) do |response|
      puts "\nListing account for #{account}:"
      response.each do |key, value|
        if value.is_a? Hash
          puts "\n"
          puts "#{key}:"
          value.each do |inner_key, inner_value|
            puts "\t#{inner_key}: #{inner_value}"
          end
          puts "\n"
        else
          puts "#{key}: #{value}"
        end
      end
    end
  end

  def account_list
    send_request('account.list') do |response|
    end
  end

  def context_list(account)
    send_request('context.list', { account: account }) do

    end
  end

  def domain_add(domain, password, context_id, create_new_context_id, memo)
    params = { account: session_account, domain: domain, password: password }
    params.merge!({context_id: context_id})                       if !context_id.nil? and context_id.length.positive?
    params.merge!({create_new_context_id: create_new_context_id}) if !create_new_context_id.nil? and create_new_context_id.length.positive?
    params.merge!({memo: memo})                                   if !memo.nil? and memo.length.positive?
    send_request('domain.add', params) do |response|
      response.each do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end

  def domain_get(domain)
    send_request('domain.get', { domain: domain }) do |response|
      puts "\nListing domain:"
      response.each do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end

  def domain_list(filter='')
    params = { account: session_account }
    params.merge!(filter: filter) if filter.length.positive?
    send_request('domain.list', params) do |response|
      puts "\nListing domains:"
      if response.length.positive?
        response.each do |r|
          domain, count_mails = r[:domain], r[:count_mails]
          puts "\n#{domain} | Count mails: #{count_mails}"
        end
      else
        puts "\nNo domains found."
      end
    end
  end

  def mail_backup_list(mail)
    send_request('mail.backup.list', { mail: mail }) do |response|

    end
  end

  def mail_blacklist_list(mail)
    send_request('mail.blacklist.list', { mail: mail }) do |response|
      puts "\nListing blacklisted mails:"
      if response.length.positive?
        response.each do |r|
          puts "#{r}"
        end
      else
        puts "\nNo blacklisted mails found."
      end
    end
  end

  def mail_del(mail)
    send_request('mail.del', { mail: mail }) do |response|
      puts "\nMail deleted? #{response}"
    end
  end

  def mail_list(domain)
    send_request('mail.list', { domain: domain }) do |response|
      puts "\nListing mails:"
      if response.length.positive?
        response.each do |r|
          mail, type = r[:mail], r[:type]
          puts "#{mail} | Type: #{type}"
        end
      else
        puts "\nNo mails found."
      end
    end
  end

  def mail_get(mail)
    send_request('mail.get', { mail: mail }) do |response|
      puts "\nMail info for #{mail}"
      response.each do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end

  def mail_set(mail, preference, value)
    send_request('mail.set', { mail: mail, "#{preference}": value }) do |response|
      puts "\nMail preference set for #{mail}"
      response.each do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end

  def mail_spamprotect_get(mail)
    send_request('mail.spamprotect.get', { mail: mail }) do |response|
      puts "\nMail spamprotection info for #{mail}"
      response.each do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end

  private

  def auth_from_file
    unless auth_credentials_exist?
      raise SystemExit, "No credentials present. Call auth-method first to save credentials to file."
    end

    credentials = YAML.load(IO.read(AUTH_FILE))

    auth(credentials[:user], credentials[:pass])
  end

  def send_request(method, params={}, id=1)
    if session_id_present?
      auth_from_file
    else
      raise Thor::Error.new("No session ID present. Please run auth command first before sending requests.")
    end

    options = @options.clone
    options.merge!({headers: {:'HPLS-AUTH' => session_id}})
    options.merge!({body: request_object(method, params, id)})

    response = self.class.post("/", options)
    body = JSON.parse(response.body, symbolize_names: true)

    parse_response(body) do |response|
      yield response
    end
  end

  def auth_credentials_exist?
    File.exist?(AUTH_FILE)
  end

  def session_id_present?
    return false unless auth_credentials_exist?
    credentials = YAML.load(IO.read(AUTH_FILE))
    !credentials[:auth_id].nil? and !credentials[:auth_id].empty?
  end

  def session_account
    credentials = YAML.load(IO.read(AUTH_FILE))
    credentials[:user]
  end

  def session_level
    credentials = YAML.load(IO.read(AUTH_FILE))
    credentials[:auth_level]
  end

  def session_id
    credentials = YAML.load(IO.read(AUTH_FILE))
    credentials[:auth_id]
  end

  def request_object(method, params={}, id=1)
    request = {
        jsonrpc: '2.0',
        method: method,
        params: params,
        id: id
    }

    request.to_json
  end

  def parse_response(response)
    if response[:error].nil?
      if response[:result].nil?
        yield response # String response.
      else
        yield response[:result] # Object response.
      end
    else
      puts "\n\nMailbox.org API responded with the following error\n-----------------------------------------------------------\n\n"
      puts "Code: #{parse_error(response, :code)}\n"
      puts "Message: #{parse_error(response, :message)}\n"
      puts "Data:\n#{parse_error(response, :data)}\n\n"
      raise Thor::Error.new("Execution halted.")
    end
  end

  def parse_error(response, key)
    unless %i(message code data).include? key
      raise ArgumentError, "Non valid valid error key specified, only symbols are allowed not strings"
    end

    if !response.nil? and !response[:error].nil? and !response[:error][key].nil?
      return response[:error][key]
    end
    ''
  end
end
