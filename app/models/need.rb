require "active_model"

class Need
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  class NotFound < StandardError
    attr_reader :need_id

    def initialize(need_id)
      super("Need with ID #{need_id} not found")
      @need_id = need_id
    end
  end

  JUSTIFICATIONS = [
    "it's something only government does",
    "the government is legally obliged to provide it",
    "it's inherent to a person's or an organisation's rights and obligations",
    "it's something that people can do or it's something people need to know before they can do something that's regulated by/related to government",
    "there is clear demand for it from users",
    "it's something the government provides/does/pays for",
    "it's straightforward advice that helps people to comply with their statutory obligations"
  ]
  IMPACT = [
    "Endangers the health of individuals",
    "Has serious consequences for the day-to-day lives of your users",
    "Annoys the majority of your users. May incur fines",
    "Noticed by the average member of the public",
    "Noticed by an expert audience",
    "No impact"
  ]
  NUMERIC_FIELDS = ["monthly_user_contacts", "monthly_site_views", "monthly_need_views", "monthly_searches"]
  FIELDS = ["role", "goal", "benefit", "organisation_ids", "impact", "justifications", "met_when",
    "currently_met", "other_evidence", "legislation"] + NUMERIC_FIELDS
  attr_accessor *FIELDS
  attr_reader :need_id

  validates_presence_of ["role", "goal", "benefit"]
  validates :impact, inclusion: { in: IMPACT }, allow_blank: true
  validates_each :justifications do |record, attr, value|
    record.errors.add(attr, "must contain a known value") unless (value.nil? || value.all? { |v| JUSTIFICATIONS.include? v })
  end
  NUMERIC_FIELDS.each do |field|
    validates_numericality_of field, :only_integer => true, :allow_blank => true, :greater_than_or_equal_to => 0
  end

  # Retrieve a need from the Need API, or raise NotFound if it doesn't exist.
  #
  # This works in roughly the same way as an ActiveRecord-style `find` method,
  # just with a different exception type.
  def self.find(need_id)
    need_response = Maslow.need_api.need(need_id)
    if need_response
      # Discard fields from the API we don't understand. Coupling the fields
      # this app understands to the fields it expects from clients is fine, but
      # we don't want to couple that with the fields we can use in the API.
      self.new(need_response.to_hash.slice(*FIELDS + ["id"]), true)
    else
      raise NotFound, need_id
    end
  end

  def initialize(attrs, existing = false)
    if existing
      @need_id = attrs.delete("id")
    end
    @existing = existing

    unless (attrs.keys - FIELDS).empty?
      raise(ArgumentError, "Unrecognised attributes present in: #{attrs.keys}")
    end
    attrs.keys.each do |f|
      send("#{f}=", attrs[f])
    end
  end

  def as_json(options = {})
    # Build up the hash manually, as ActiveModel::Serialization's default
    # behaviour serialises all attributes, including @errors and
    # @validation_context.
    res = FIELDS.each_with_object({}) do |field, hash|
      hash[field] = send(field) if send(field).present?
    end
    NUMERIC_FIELDS.each do |field|
      res[field] = Integer(res[field]) if res[field].present?
    end
    res["currently_met"] = (currently_met == true || currently_met == 'true') unless currently_met.nil?
    res
  end

  def save
    raise("The save_as method must be used when persisting a need, providing details about the author.")
  end

  def save_as(author)
    atts = as_json.merge("author" => {
      "name" => author.name,
      "email" => author.email,
      "uid" => author.uid
    })

    Maslow.need_api.create_need(atts)
  end

  def persisted?
    @existing
  end
  end
end
