class LegacyProjectFaq < ActiveRecord::Base
  include LegacyBase
  establish_connection "legacy"

  self.table_name = "project_faqs"
  # self.primary_key = "old_id"

  # To use autogenerated ids uncomment below
  def dont_migrate_ids
    false
  end

  def migrate_where
    {id: self.id}
  end

  def map
    {
      answer: self.answer,
      title: self.title,
      project_id: self.project_id,
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  def associate
    {
      # association: records.to.associate
    }
  end

end