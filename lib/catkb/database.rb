require 'sequel'

module CatKB
  @db = nil

  def self.db_table
    {
      'part' => :parts,
      'note' => :notes,
      'project' => :projects,
      'container' => :containers,
    }
  end

  def self.db
    @db ||= self._db_connect
  end

  private

  def self._db_connect
    db = Sequel.connect(ENV['DATABASE_URL'])
    db.run (CatKB::ROOT_DIR / 'init.sql').read
    db
  end
end
