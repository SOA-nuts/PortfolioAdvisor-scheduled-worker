# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    PortfolioAdvisor::App.DB.run('PRAGMA foreign_keys = OFF')
    PortfolioAdvisor::Database::TargetOrm.map(&:destroy)
    PortfolioAdvisor::Database::ArticleOrm.map(&:destroy)
    PortfolioAdvisor::Database::HistoryOrm.map(&:destroy)
    PortfolioAdvisor::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
