class Search < ActiveRecord::Base

  def self.search(query)
    # determine if we're using PostgresQL's to_tsquery or plainto_tsquery
    @plain = (/.*[&|!].*/ =~ query) == nil

    ids = []
    ids += search_needs(query)
    ids += search_tags(query)
    ids += search_notes(query)

    Need.where("id in (?)", ids.uniq)
  end

private

  def self.search_needs(query)
    sql = <<-SQL
      select id from needs
      where to_tsvector(
        coalesce(role, '') || ' ' ||
        coalesce(goal, '') || ' ' ||
        coalesce(benefit, '') || ' ' ||
        coalesce(met_when[1], '') || ' ' ||
        coalesce(met_when[2], '') || ' ' ||
        coalesce(met_when[3], '') || ' ' ||
        coalesce(met_when[4], '') || ' ' ||
        coalesce(met_when[5], '') || ' ' ||
        coalesce(other_evidence, '') || ' ' ||
        coalesce(why_impact, ''))
    SQL
    common(sql, query)
  end

  def self.search_tags(query)
    sql = <<-SQL
      select
        tn.need_id as id
      from
        taggings tn,
        tags t,
        tag_types tt
      where
        tn.tag_id = t.id
        and t.tag_type_id = tt.id
        and to_tsvector(coalesce(t.name, '') || ' ' || coalesce(tt.name, ''))
    SQL
    common(sql, query)
  end

  def self.search_notes(query)
    sql = <<-SQL
      select need_id as id
      from activity_items
      where
        item_type = 'note'
        and to_tsvector(coalesce(data::json->>'body', ''))
    SQL
    common(sql, query)
  end

  def self.common(sql, query)
    if @plain
      sql += "@@ plainto_tsquery(?);"
    else
      sql += "@@ to_tsquery(?);"
    end
    result = self.connection.execute(sanitize_sql([sql, query]))
    result.map { |row| row["id"] }
  end
end
